# Architecture

## Goals

- Shared cross-platform UI and state management.
- Android-first production behavior for always-on voice gesture detection + reel scrolling.
- iOS-compatible app experience with capability fallback.

## Layering

1. **Presentation (`lib/src/features`)**
   - Home screen for command setup.
   - Listening mode controls and diagnostics.
2. **Domain (`lib/src/core/models`)**
   - `VoiceCommand` entity.
3. **Infrastructure (`lib/src/core/services`)**
   - `CommandStore`: local persistence.
   - `PlatformVoiceBridge`: Flutter MethodChannel entrypoint.
4. **Platform adapters**
   - Android: `VoiceCommandForegroundService` (continuous recognition + phrase match), `ReelScrollAccessibilityService`.
   - iOS: `AppDelegate.swift` method channel handling.

## Production hardening checklist

- Add encrypted local storage for command phrases.
- Implement confidence thresholds + wake-word rejection.
- Add telemetry (voice trigger latency, false-positive rate).
- Add battery and thermal controls for listening loops.
- Add crash reporting and ANR monitoring.
- Add policy-safe onboarding and explicit disclosures.

## Compliance notes

- Android Accessibility usage must be clearly disclosed and user-enabled.
- iOS cannot support the same third-party app control behavior with public APIs.
