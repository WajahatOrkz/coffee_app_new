# Google Sign-In Setup Guide

## ✅ Current Status

The Google Sign-In code is implemented but requires the **Web Client ID** (serverClientId) from Google Cloud Console.

### ❌ Current Error

```
Exception: Google Sign-In error: GoogleSignInException(code GoogleSignInExceptionCode.clientConfigurationError,
serverClientId must be provided on Android, null)
```

This means the `serverClientId` in the code needs to be replaced with your actual Web OAuth 2.0 Client ID.

## 🔧 How to Fix: Get Your Web Client ID

### Step 1: Go to Google Cloud Console

1. Visit [Google Cloud Console](https://console.cloud.google.com/)
2. Make sure your project is selected: `coffee-app-1cf8d`
3. Go to **APIs & Services** → **Credentials**

### Step 2: Find the Web Client ID

1. Look for **OAuth 2.0 Client IDs**
2. Find the entry with type **"Web application"**
3. Copy the **Client ID** (format: `123456789-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com`)

### Step 3: Update Your Code

Open [lib/features/auth/data/repositories/auth_repositories.dart](lib/features/auth/data/repositories/auth_repositories.dart) and replace this line:

```dart
'549640564957-jj8mj9d1q9q9q9q9q9q9q9q9q9q9q9q9.apps.googleusercontent.com' // TODO: Replace with your actual Web Client ID
```

With your actual Web Client ID:

```dart
'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com'
```

### Step 4: Test

After updating the code, rebuild and test the Google Sign-In button again.

---

## 📝 Original Setup Instructions

If you haven't configured Firebase yet, follow these:

Your Firebase project needs OAuth credentials to be configured. Here's how:

### Step 1: Enable Google Sign-In in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `coffee-app-1cf8d`
3. Navigate to **Authentication** → **Sign-in method**
4. Click on **Google** provider
5. Click **Enable**
6. Enter your **Project support email**
7. Click **Save**

### Step 2: Configure Android

1. In Firebase Console, go to **Project Settings** (⚙️ icon)
2. Under **Your apps**, find your Android app
3. Make sure the **SHA-1** and **SHA-256** fingerprints are added

   To get your SHA-1 fingerprint, run:

   ```bash
   cd android
   ./gradlew signingReport
   ```

   Or for debug keystore:

   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

4. Add the SHA-1 fingerprint to your Firebase Android app settings
5. Download the updated `google-services.json` file
6. Replace the current file at: `android/app/google-services.json`

### Step 3: Configure iOS

1. In Firebase Console, add an iOS app if you haven't already
2. Download the `GoogleService-Info.plist` file
3. Place it in: `ios/Runner/GoogleService-Info.plist`
4. Open the downloaded `GoogleService-Info.plist` and find the `REVERSED_CLIENT_ID`
5. Update `ios/Runner/Info.plist` to replace the placeholder:

   Replace:

   ```xml
   <string>com.googleusercontent.apps.123456789-abcdefg</string>
   ```

   With your actual REVERSED_CLIENT_ID from GoogleService-Info.plist

### Step 4: Test the Implementation

After configuring Firebase:

1. Run `flutter clean`
2. Run `flutter pub get`
3. Rebuild your app
4. Test the Google Sign-In button

## 📝 Current Code Implementation

The Google Sign-In button in [lib/features/auth/presentation/views/login.dart](lib/features/auth/presentation/views/login.dart) is now connected:

```dart
_SocialButton(
  icon: Icons.g_mobiledata,
  onPressed: () {
    controller.signInWithGoogle();
  },
),
```

The implementation includes:

- Proper error handling
- Loading states
- User feedback via snackbars
- Token retrieval
- Google Sign-Out on logout

## 🔧 Troubleshooting

### Error: "PlatformException(sign_in_failed)"

- Make sure you've added SHA-1 fingerprint for Android
- Verify that Google Sign-In is enabled in Firebase Console
- Check that google-services.json is updated

### Error: "An internal error has occurred"

- Make sure you've downloaded the latest configuration files after enabling Google Sign-In
- Clean and rebuild the app

### iOS: "No valid iOS URL scheme"

- Verify that REVERSED_CLIENT_ID is correctly added to Info.plist
- Make sure GoogleService-Info.plist is added to the iOS project

## 📱 Platform-Specific Notes

### Android

- Already configured with `play-services-auth:20.7.0`
- Requires valid SHA-1 fingerprint

### iOS

- Requires GoogleService-Info.plist file
- Requires URL scheme configuration in Info.plist
- The Info.plist currently has a placeholder that needs to be updated

## ✨ Next Steps

1. Complete Firebase Console configuration (Steps 1-3 above)
2. Download updated configuration files
3. Test the Google Sign-In functionality
4. Optionally implement Apple Sign-In (currently has empty onPressed)

---

**Note**: The code implementation is complete. You only need to configure Firebase Console and update the configuration files.
