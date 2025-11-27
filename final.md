This is the final polish\!

You are seeing the **Flutter Logo** because we haven't generated the native Android assets for your custom logo yet.

Also, regarding the **"Only when open"** issue:

  * **The Reality:** Since we are using **Supabase Realtime (Stream)** instead of Firebase Cloud Messaging (FCM), the app *must* be running (even in the background/minimized) to "hear" the new message.
  * If you kill the app (swipe it away), the "ear" is removed, and it cannot hear the notification.
  * **The Fix:** Real "Killed App" notifications require a paid/complex server (FCM). For a free, student-focused app, the current method is the industry standard approach.

-----

### 🎨 How to Fix the Notification Icon

We will use a package to automatically generate all the Android icons (different sizes) from your logo file.

### 🚀 **NovaMind Update 28.0: "Icon Generator" Master Prompt**

**Copy and paste this ENTIRE block into your IDE Agent.**

````markdown
**Role:** You are a Lead Flutter Designer.
**Task:** Update the App Icon and Notification Icon to replace the default Flutter logo.

### 📦 Phase 1: Icon Generation Setup
**Action:** Update `pubspec.yaml` to include the generator config.
1.  **Add `flutter_launcher_icons`:** (It should already be in dev_dependencies).
2.  **Add Configuration:** Paste this block at the bottom of `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "ic_launcher"
  ios: true
  image_path: "assets/images/logo.png" # Ensure you have a logo.png here
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/images/logo.png"
````

### 🖼️ Phase 2: Notification Specific Icon

**Action:** Create a transparent version for the Status Bar.

  * Android requires a **Transparent (White)** icon for the top bar (small icon). If you use a colored square, it will show as a grey block.
  * **Task:** Ask the user to put a transparent PNG named `notification_icon.png` in `assets/images/`.

### 🔔 Phase 3: Update `notification_service.dart`

**Action:** Tell the plugin to use the new icon.
**Code Update:**

```dart
// Change this line in init()
const androidSettings = AndroidInitializationSettings('ic_launcher'); // Uses the new App Icon

// OR if you added a specific transparent icon:
// const androidSettings = AndroidInitializationSettings('notification_icon');
```

### 📝 EXECUTION PLAN

1.  **Update `pubspec.yaml`** with the config.
2.  **Update `notification_service.dart`**.

**Action:** Start by updating **`pubspec.yaml`**.

````

---

### ⚠️ MANUAL STEPS (Crucial)

The AI cannot paint the icon for you. You must do this:

1.  **Get your Logo:**
    * Take your app logo image.
    * Rename it to **`logo.png`**.
    * Put it inside the folder: **`assets/images/`**.

2.  **Run the Generator:**
    * Open your terminal in VS Code.
    * Run this command:
        ```bash
        dart run flutter_launcher_icons
        ```
    * *You will see "Successfully generated launcher icons".*

3.  **Rebuild the App:**
    * The icons are "baked" into the APK. You must rebuild.
    * `flutter clean`
    * `flutter build apk --release --split-per-abi`

**Once you install this new APK, the Flutter Face will be gone forever!**
````