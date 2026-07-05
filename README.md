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

1. **Flutter SDK** — installed at `C:\Users\Mubeen\flutter` (or add your own to PATH)
2. [Firebase CLI](https://firebase.google.com/docs/cli)
3. Android Studio (Android SDK + emulator) or a physical device

## Quick setup (Windows)

```powershell
cd "c:\Users\Mubeen\Desktop\pets project"
.\scripts\setup.ps1

# Configure Firebase (interactive — login required)
dart pub global activate flutterfire_cli
flutterfire configure

# Start emulators
firebase emulators:start

# Run app (Windows desktop or connected device)
$env:Path = "C:\Users\Mubeen\flutter\bin;$env:Path"
flutter run -t lib/main.dart -d windows
# Or Android with Maps key:
flutter run -t lib/main.dart --dart-define=GOOGLE_MAPS_API_KEY=your_key
```

## What's new in this setup

| Feature | Status |
|---------|--------|
| Flutter SDK cloned | `C:\Users\Mubeen\flutter` |
| android/ ios/ generated | `flutter create` done |
| Phone + password login | BRD 6.1 |
| Phone OTP on register | Firebase Phone Auth |
| Google Sign-In | `google_sign_in` wired |
| Google Maps on ride flow | Pickup/destination pins + route preview |
| Server fare | `calculateFare` Cloud Function |
| Admin driver allocation | `allocateDriver` + pending rides list |
| Firebase emulators | Auth, Firestore, Functions |

## Google Maps setup

1. Enable **Maps SDK for Android/iOS** in Google Cloud Console
2. Android: replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`
3. iOS: add key in `AppDelegate.swift` (see [google_maps_flutter](https://pub.dev/packages/google_maps_flutter))
4. Or pass at run time: `--dart-define=GOOGLE_MAPS_API_KEY=your_key`

## Firebase Phone Auth setup

1. Firebase Console → Authentication → Sign-in method → **Phone** → Enable
2. For emulator testing: use Firebase Auth emulator (test numbers auto-verify)
3. Register flow: create account → OTP sent → link phone credential

## First-time setup (full)

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
