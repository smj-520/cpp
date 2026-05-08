# Custom Auth Web Handler

This folder contains a branded Firebase email action handler page (same style as the app) for:

- Verify email (`mode=verifyEmail`)
- Reset password (`mode=resetPassword`)
- Recover email (`mode=recoverEmail`)

## Files

- `index.html` - page UI
- `styles.css` - app-like design system
- `app.js` - logic (Identity Toolkit REST calls)
- `config.json` - Firebase config for the web handler

## Configure

1. Update `config.json`:
   - `apiKey`: Firebase Web API key (already set from your project)
   - `continueUrl`: optional deep link/app URL after success

2. Host this folder at a public HTTPS URL, e.g.:
   - `https://YOUR_DOMAIN/auth/index.html`

## Connect with Flutter app

Set URL in `lib/services/auth_action_settings.dart`:

```dart
const String kCustomAuthHandlerUrl = 'https://YOUR_DOMAIN/auth/index.html';
```

Then app emails (verify/reset) will open this custom page.

## Firebase Console note

In Authentication templates, keep default action handling. The app sends a custom `ActionCodeSettings.url`, so Firebase will route users here automatically.
