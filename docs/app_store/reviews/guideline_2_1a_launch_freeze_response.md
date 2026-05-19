# Guideline 2.1(a) Launch Freeze Response Plan

## Review Issue

- Guideline: 2.1(a) - Performance - App Completeness
- Reported bug: App froze on launch
- Review device: iPad Air 11-inch (M3)
- Review OS: iPadOS 26.5
- Internet connection: Active

## Fix

- Added `SceneDelegate.swift` for iOS 13 and later.
- Kept the existing `AppDelegate` window setup as the fallback for iOS 12.
- Added `UIApplicationSceneManifest` to `Info.plist`.
- Increased `CFBundleVersion` from `1` to `2`.

This keeps the old-device target intact while matching the modern iPadOS launch lifecycle used by App Review.

## Verification

- `plutil -lint AnalogCalendarClock/Info.plist`: passed.
- Debug build on iPad Air 11-inch simulator, iPadOS 26.5: passed.
- Release build on iPad Air 11-inch simulator, iPadOS 26.5: passed.
- Clean uninstall/install/launch on iPad Air 11-inch simulator, iPadOS 26.5: launched successfully.
- Launch screenshot saved at `tmp/ipad-air-11-release-build2-launch.png`.
- Runtime log check: no crash, termination, or launch assertion failure found.

## App Review Reply Draft

Hello App Review Team,

Thank you for the detailed report.

We addressed the launch issue in version 1.0 build 2. Although we could not reproduce the freeze locally, we updated the app launch lifecycle to use `UIScene` / `SceneDelegate` on iOS 13 and later, while preserving the existing `AppDelegate` window fallback for iOS 12 devices.

We verified a clean uninstall, install, and launch of the Release build on an iPad Air 11-inch simulator running iPadOS 26.5. The app launched successfully and displayed the clock and calendar screen.

The app still works fully offline and does not require sign-in, networking, ads, subscriptions, or in-app purchases.

Best regards,
Taichi Umeki
