# Pet Services App — Phase 1 Boilerplate

Flutter mobile app boilerplate for the **Pet App BRD v1** (Saudi Arabia).  
Architecture: **feature-first + clean layers**, **Riverpod**, **go_router**, **Firebase**, **Arabic RTL + English**.

## What's included (Phase 1)

| Module | Screens | Status |
|--------|---------|--------|
| Auth | Login, Register, OTP, Forgot/Set Password | UI + Firebase email auth |
| Home & Drawer | Home, sidebar navigation | Done |
| Profile | View, Edit, Service history | Done |
| Pets | List, Add, Edit/Delete | Firestore CRUD |
| Rides | Request → Review → Pay → Search → Driver → Status → Confirm | Flow wired |
| Checkout | Checkout, Success, Failure | Mock payment |
| Verification | Account type, Documents, Status | Shell |
| Admin | Dashboard, Pending drivers | Shell (admin entry) |

## Project structure

```
lib/
├── main.dart              # Consumer app entry
├── main_admin.dart        # Admin app entry
├── app.dart               # MaterialApp + RTL/l10n
├── bootstrap/             # Firebase init + emulators
├── core/                  # theme, router, config, errors
├── shared/                # models, widgets, services, providers
└── features/              # auth, pets, rides, home, profile, ...
functions/                 # Cloud Functions (calculateFare, allocateDriver)
firebase/                  # Security rules
l10n/                      # English + Arabic strings
```

## Prerequisites

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.16+)
2. [Firebase CLI](https://firebase.google.com/docs/cli)
3. Android Studio / Xcode (for emulators)

## First-time setup

```powershell
cd "c:\Users\Mubeen\Desktop\pets project"

# Generate android/ ios/ if missing
flutter create . --project-name pet_app --org com.petservices

# Install dependencies + generate l10n
flutter pub get

# Configure Firebase (creates real firebase_options.dart)
dart pub global activate flutterfire_cli
flutterfire configure

# Start Firebase emulators (recommended for dev)
firebase emulators:start

# Run consumer app
flutter run -t lib/main.dart

# Run admin app
flutter run -t lib/main_admin.dart
```

## Environment notes

- `lib/firebase_options.dart` is a **placeholder** until you run `flutterfire configure`.
- `AppConfig.useFirebaseEmulator` defaults to `true` in debug — connects to local emulators.
- Login uses **email + password** for dev speed; swap to **phone OTP** when Firebase Phone Auth is configured (BRD 5.1).
- Payment uses `MockPaymentService` — replace with Moyasar/Tap behind `PaymentServiceFactory`.

## Phase 1 next steps

1. Run `flutterfire configure` and enable Auth, Firestore, Functions, Storage
2. Wire `calculateFare` Cloud Function in ride review screen
3. Implement admin `allocateDriver` in pending driver requests screen
4. Add Google Sign-In + Phone OTP
5. Connect managed SQL for rides (currently Firestore for Phase 1 dev simplicity)
6. Add Google Maps to ride request screens

## Scripts

```powershell
flutter analyze
flutter test
flutter run -t lib/main.dart
cd functions && npm install && npm run build
```

## BRD reference

See `Pet App BRD v1.pdf` in project root for full requirements.
