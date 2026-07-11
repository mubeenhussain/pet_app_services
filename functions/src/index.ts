import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { beforeUserCreated } from "firebase-functions/v2/identity";

initializeApp();

const OTP_WINDOW_MS = 10 * 60 * 1000;
const OTP_MAX_REQUESTS = 3;

function normalizePhone(phone: string): string {
  const trimmed = phone.replace(/\s+/g, "");
  if (!trimmed.startsWith("+")) {
    throw new HttpsError("invalid-argument", "Phone must be E.164 format.");
  }
  return trimmed;
}

async function readOtpAttempts(phone: string): Promise<number[]> {
  const doc = await getFirestore().collection("otpRateLimits").doc(phone).get();
  const attempts = (doc.data()?.attempts as number[] | undefined) ?? [];
  const now = Date.now();
  return attempts.filter((timestamp) => now - timestamp < OTP_WINDOW_MS);
}

async function assertOtpAllowed(phone: string): Promise<void> {
  const attempts = await readOtpAttempts(phone);
  if (attempts.length >= OTP_MAX_REQUESTS) {
    const oldest = attempts[0] ?? Date.now();
    const retryMinutes = Math.max(
      1,
      Math.ceil((OTP_WINDOW_MS - (Date.now() - oldest)) / 60000),
    );
    throw new HttpsError(
      "resource-exhausted",
      `Too many OTP requests. Try again in ${retryMinutes} minutes.`,
    );
  }
}

/** BRD 9.1 — onUserCreate */
export const onUserCreate = beforeUserCreated(async (event) => {
  const data = event.data;
  if (!data) {
    return;
  }

  const uid = data.uid;
  const username = data.displayName ?? "user";

  await getFirestore().collection("users").doc(uid).set(
    {
      username,
      phone: data.phoneNumber ?? "",
      role: "pet_owner",
      verified: false,
      suspended: false,
      createdAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  await getFirestore()
    .collection("users")
    .doc(uid)
    .collection("notifications")
    .add({
      type: "welcome",
      title: "Welcome to Pet Services!",
      body: "Your account is ready. Explore services, buy pets, and book rides.",
      read: false,
      createdAt: FieldValue.serverTimestamp(),
    });
});

/** BRD — OTP rate limit check (max 3 / 10 min / number). */
export const assertOtpRateLimit = onCall(async (request) => {
  const phone = normalizePhone((request.data?.phone as string | undefined) ?? "");
  await assertOtpAllowed(phone);
  return { allowed: true };
});

/** BRD — record OTP send attempt after SMS is dispatched. */
export const recordOtpRequest = onCall(async (request) => {
  const phone = normalizePhone((request.data?.phone as string | undefined) ?? "");
  await assertOtpAllowed(phone);

  const ref = getFirestore().collection("otpRateLimits").doc(phone);
  const attempts = await readOtpAttempts(phone);
  attempts.push(Date.now());

  await ref.set({ phone, attempts }, { merge: true });
  return { recorded: true };
});

/** BRD 9.1 — calculateFare (callable) */
export const calculateFare = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }

  const { distanceKm = 5, durationMin = 15 } = request.data as {
    distanceKm?: number;
    durationMin?: number;
  };

  const base = 25;
  const perKm = 3.5;
  const perMin = 0.5;
  const fareAmount = base + distanceKm * perKm + durationMin * perMin;

  return { fareAmount: Math.round(fareAmount * 100) / 100, currency: "SAR" };
});

/** BRD 9.1 — allocateDriver (admin callable) */
export const allocateDriver = onCall(async (request) => {
  if (!request.auth?.token.admin) {
    throw new HttpsError("permission-denied", "Admin only.");
  }

  const { rideId, driverId } = request.data as {
    rideId: string;
    driverId: string;
  };

  await getFirestore().collection("rides").doc(rideId).update({
    driverId,
    status: "driver_allocated",
    allocatedBy: request.auth.uid,
    allocatedAt: FieldValue.serverTimestamp(),
  });

  return { success: true };
});
