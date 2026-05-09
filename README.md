# assessment_app (Flutter + Firebase Notes)

Notes application built in Flutter using:

- Firebase Authentication (email/password)
- Cloud Firestore (secure per-user notes)

## Features

- Sign up / Login / Logout
- Session persistence (Auth state gate)
- Notes CRUD
  - Each note has `title` + `content`
  - Create, Edit, Delete, List
- Secure data isolation
  - Notes are stored under: `users/{uid}/notes/{noteId}`
- Additional requirement implemented: Search notes by title (client-side)

## Auth approach

- Firebase Authentication using Email/Password.
- Session persistence is handled by listening to `FirebaseAuth.instance.authStateChanges()` and showing `HomeScreen` when a user is signed in, otherwise `LoginScreen`.

## Project Setup

### 1) Flutter

Ensure Flutter is installed:

```bash
flutter --version
```

Install deps:

```bash
flutter pub get
```

### 2) Firebase setup

1. Create a Firebase project in Firebase Console.
2. Add Android app (package name from `android/app/build.gradle` / `applicationId`).
3. Download and place:

- `android/app/google-services.json`

4. Enable Authentication:

- Sign-in method: Email/Password

5. Enable Cloud Firestore.

### 3) Firestore schema / collections

This app stores notes under each user:

- `users/{uid}/notes/{noteId}`

Fields per note:

- `title` (string)
- `content` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

## Security (Mandatory)

The app uses per-user scoped paths. You must also enforce Firestore rules.

Example rules (Firebase Console → Firestore → Rules):

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Run

```bash
flutter run
```

## Build Android APK

Debug APK:

```bash
flutter build apk --debug
```

Release APK:

```bash
flutter build apk --release
```

The APK will be available under:

- `build/app/outputs/flutter-apk/`

## Submission notes

- If you attach an APK for reviewers, prefer a GitHub Release.
- Make sure `android/app/google-services.json` matches your `applicationId` (Android package name) so Firebase initializes correctly.

## Assumptions / Trade-offs

- Notes are scoped per authenticated user using a Firestore path per user.
- Search is implemented client-side (acceptable per assignment).
- Firestore security rules must be applied in Firebase Console to enforce per-user isolation.
