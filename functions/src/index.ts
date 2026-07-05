import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { beforeUserCreated } from "firebase-functions/v2/identity";

initializeApp();

/** BRD 9.1 — onUserCreate */
export const onUserCreate = beforeUserCreated(async (event) => {
  const uid = event.data.uid;
  await getFirestore().collection("users").doc(uid).set(
    {
      username: event.data.displayName ?? "user",
      phone: event.data.phoneNumber ?? "",
      role: "pet_owner",
      verified: false,
      suspended: false,
      createdAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
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
