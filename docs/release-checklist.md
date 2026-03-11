# Release Checklist

1. Run linting and tests in CI.
2. Validate permissions flows on Android 12+ and 14+.
3. Verify accessibility service onboarding copy and consent.
4. Verify fallback UI/UX on iOS.
5. Create and push a semantic tag (`vX.Y.Z`).
6. Confirm `.github/workflows/android-release.yml` succeeded.
7. Verify `app-release.apk` is attached to the GitHub release assets.
8. Publish release notes with known platform limitations.
