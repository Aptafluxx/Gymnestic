# Gymnestic

Gymnestic is a sleek fitness and wellness mobile app built with Flutter. It helps users stay consistent with their training by combining workout programs, daily goal tracking, personal progress monitoring, and motivational health content in a single dark-mode experience.

## Features

- Guided onboarding flow for first-time users
- Firebase authentication with login, sign-up, and password reset flows
- Personalized dashboard with exercise/activity programs
- Daily goal checklists and workout progress tracking
- Performance insights with charts and weekly fitness metrics
- User profile management for bio, skills, and progress overview
- Fitness articles and educational content for better habits
- Persistent local preferences for onboarding and app state

## Tech Stack

- Flutter + Dart
- GetX for state management and routing
- Firebase Auth and Cloud Firestore
- SharedPreferences for local persistence
- FlChart for activity and progress visualizations
- Custom dark-themed design system and branded assets

## Project Structure

```text
gymnestic/
├── android/
├── ios/
├── lib/
│   ├── core/
│   │   ├── bindings/
│   │   ├── errors/
│   │   ├── routes/
│   │   ├── services/
│   │   └── theme/
│   ├── features/
│   │   ├── articles/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   ├── splash/
│   │   ├── statistics/
│   │   └── workouts/
│   ├── firebase_options.dart
│   ├── main.dart
│   └── ...
├── assets/
├── web/
├── firebase.json
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
├── .gitignore
└── ...
```

## Getting Started

### Prerequisites

- Flutter SDK 3.13.3 or newer
- Android Studio / Xcode for mobile builds
- Firebase project configured for the app

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Firebase setup

This project is configured to use Firebase services. Make sure the generated Firebase configuration files are present:

- `android/app/google-services.json`
- `lib/firebase_options.dart`

If needed, regenerate them with:

```bash
flutterfire configure
```

### Available targets

The app is set up for multi-platform Flutter development, including Android, iOS, web, Linux, macOS, and Windows.

## App Identity

- App name: Gymnestic
- Package/application ID: `com.aptaflux.gymnestic`
- Branding theme: dark fitness interface with red accent styling

## License

This project is for internal or personal development use unless otherwise specified by the repository owner.
