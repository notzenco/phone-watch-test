# Phone Watch Test

A private SwiftUI habit tracker for iPhone and Apple Watch. Habits are stored
locally and synchronized between the companion apps with Watch Connectivity.

## Development model

The source is edited on Windows. GitHub Actions generates the Xcode project,
builds both apps with Xcode 27, and runs the unit tests. Distribution builds are
uploaded privately to TestFlight.

## Targets

- `PhoneWatchTest`: iPhone habit list, progress, streaks, and habit creation.
- `PhoneWatchTestWatch`: quick habit check-offs from Apple Watch.
- `PhoneWatchTestTests`: deterministic model tests.

## Generate the project on macOS

The generated `.xcodeproj` is intentionally not committed.

```sh
xcodegen generate
```

XcodeGen is pinned to version 2.45.4 in CI.

## Bundle identifiers

- iOS: `com.notzenco.phonewatchtest`
- watchOS: `com.notzenco.phonewatchtest.watchkitapp`

Signing credentials are never stored in this repository.

