# read_radius

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Known iOS warning

When running on iOS, Flutter may print this warning:

"The following plugins do not support Swift Package Manager for ios:
	- flutter_facebook_auth"

This project currently uses CocoaPods for iOS dependencies, so this is a non-blocking warning.
The app can still build and run normally.

## iOS Facebook Login Configuration

Facebook login on iOS requires these keys in [ios/Runner/Info.plist](ios/Runner/Info.plist):

- `FacebookAppID`
- `FacebookClientToken`
- `FacebookDisplayName`
- `CFBundleURLTypes -> CFBundleURLSchemes` containing `fb<FACEBOOK_APP_ID>`
- `LSApplicationQueriesSchemes` containing `fbapi`, `fb-messenger-share-api`, `fbauth2`, `fbshareextension`

If these values are missing, the Facebook SDK can terminate the app at runtime during login.
