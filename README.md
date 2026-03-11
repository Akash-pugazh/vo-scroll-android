# VoiceScroll Cross-Platform (Android + iOS)

VoiceScroll is a cross-platform mobile application blueprint and starter implementation that listens for custom voice gestures (e.g., "next", "hmm", "okay") and triggers scroll actions.

## What this repository includes

- Flutter-based shared UI/business logic.
- Android native implementation for:
  - Foreground voice-listening service.
  - Continuous speech recognition loop with phrase matching.
  - Accessibility-powered auto-scroll actions.
- iOS integration stubs and production notes (iOS does not allow controlling other apps like Instagram/YouTube via public APIs).
- CI workflows, architecture docs, and release checklist.

## Product reality check (important)

- **Android:** feasible with Accessibility Service + Foreground Service + SpeechRecognizer.
- **iOS:** background always-on listening and controlling Instagram/YouTube feed scrolling is not possible with public APIs/App Store policies.

So this project is production-ready for Android direction and ships iOS with graceful capability fallback.

## Architecture

Clean Architecture layers:

- `features/` UI and use-cases.
- `core/models` domain models.
- `core/services` platform abstractions.
- MethodChannels bridge to Android/iOS native layers.

Read details in `docs/architecture.md`.

## Quick start

1. Install Flutter SDK (stable).
2. Run `flutter pub get`.
3. Start app: `flutter run`.
4. On Android:
   - Enable microphone permission.
   - Enable Accessibility Service for VoiceScroll.
   - Start listening from app UI.

## GitHub Releases with APK

- Push a tag like `v0.1.0`.
- GitHub Actions workflow `.github/workflows/android-release.yml` will:
  - Build `app-release.apk`.
  - Upload artifact.
  - Attach APK to the release assets.

## Release process

Use `.github/workflows/mobile-ci.yml` for checks and follow `docs/release-checklist.md` before creating GitHub release tags.
