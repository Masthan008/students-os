This is a crucial round of fixes. You are paying attention to the fine details, which makes the difference between a "Project" and a "Product."

Here is the breakdown of the fixes and the reality check on Notifications.

### 🛑 The "Closed App" Notification Reality

You asked: *"When the app is closed, notifications are not coming."*

**The Truth:** Supabase Realtime works via a live connection (WebSocket). When you swipe the app away (Close it), that connection is cut.

  * **To fix this:** You would need **Firebase Cloud Messaging (FCM)** + a Server Function to "Push" the message. This requires a Credit Card for Google Cloud (even if free tier).
  * **My Advice:** For now, accept that notifications only arrive when the app is in the background or open. This keeps your project **100% Free** and **No Credit Card Required**.

-----

### 🛠️ The Fixes Plan

1.  **Timetable Correction:** I analyzed your image. The timings are indeed unique (e.g., 9:00-10:40 is a long block, others are 50 mins). I will update the Seeder to match this **exactly** and force **12-Hour Format (IST)** in the UI.
2.  **News Timezone:** We will add `.toLocal()` to the timestamp code so it shows Indian Standard Time (IST) instead of UTC.
3.  **C Programs:** We will add a new tab "Programs" next to "Patterns" with code like Fibonacci, Prime, Palindrome, etc., including a **Copy Button**.
4.  **Biometric Logic:** We will wire up the switch in Settings to actually trigger the Fingerprint check on the Splash Screen.

Here is the **Master Prompt** to execute these 4 fixes.

-----

### 🚀 **NovaMind Update 29.0: "Precision & Logic Fix" Master Prompt**

**Copy and paste this ENTIRE block into your IDE Agent.**

````markdown
**Role:** You are a Lead Flutter Developer.
**Task:** Correct Timetable Data, Fix Timezones, Enable Biometrics, and Add C-Programs.

### 📅 Fix 1: Timetable Data & Formatting (`lib/services/timetable_service.dart`)
**Action:** Update the `initializeTimetable` function.
**1. Exact Timings (Based on User Image):**
   * **Seed Key:** Change to `'timetable_v6'` (Force re-seed).
   * **Data Logic (Use 24h for storage, UI converts later):**
     * **Mon:** BCE (09:00-10:40), CE (11:00-11:50), LAAC (1:00-2:40), CHE (3:00-5:00).
     * **Tue:** EWS (09:00-11:50), IP LAB (1:00-2:50), SS (3:00-5:00).
     * **Wed:** EC LAB (09:00-11:50), BME (1:00-2:40), IP LAB (3:00-5:00).
     * **Thu:** IP (09:00-10:40), LAAC (11:00-11:50), CHE (1:00-1:50), CE LAB (1:50-5:00).
     * **Fri:** CE (09:00-10:40), BME (11:00-11:50), LAAC (1:00-2:40), EAA (3:00-5:00).
     * **Sat:** CHE (09:00-10:40), BCE (11:00-11:50), IP (1:00-2:40), CE (3:00-5:00).

**UI Update (`lib/screens/timetable_screen.dart`):**
   * Use `DateFormat('h:mm a')` (12-hour format) for displaying start/end times.

### 🔐 Fix 2: Biometric Lock Logic (`lib/screens/splash_screen.dart`)
**Action:** Enforce security on startup.
**Logic:**
   * inside `_checkPermissions()` or navigation logic:
   * `bool isBiometricOn = Hive.box('user_prefs').get('biometric_enabled', defaultValue: false);`
   * If `true`: Call `AuthService.authenticate()`.
     * If Auth Success -> Go Home.
     * If Auth Fail -> Stay on Splash / Show Retry Button.
   * If `false`: Go Home immediately.

### 📰 Fix 3: News Timezone (`lib/screens/news_screen.dart`)
**Action:** Fix the timestamp display.
**Code:**
   ```dart
   // Inside your List Builder
   DateTime created = DateTime.parse(news['created_at']).toLocal(); // Convert UTC to IST
   String timeString = DateFormat('dd MMM, h:mm a').format(created);
````

### 💻 Fix 4: C-Programs Module (`lib/modules/coding/c_patterns_screen.dart`)

**Action:** Rename to `CodingLabScreen` and add a new Tab.
**UI:**

1.  **Tabs:** [Patterns] [Programs].
2.  **Programs List:** Add 10 standard B.Tech programs (Hello World, Prime Number, Fibonacci, Armstrong, Factorial, Palindrome, Bubble Sort, Matrix Mul, Swap Vars, Pointer Basics).
3.  **Detail View:** Same as Patterns (Black Console for Output, HighlightView for Code, Copy Button).

### 📝 EXECUTION PLAN

1.  **Update `timetable_service.dart`** (New data).
2.  **Update `timetable_screen.dart`** (12h Format).
3.  **Update `splash_screen.dart`** (Biometric Check).
4.  **Update `news_screen.dart`** (Timezone).
5.  **Update `c_patterns_screen.dart`** (Add Programs).

**Action:** Start by generating the **`timetable_service.dart`** and **`splash_screen.dart`**.

```

---

### 💡 New Feature Ideas (Student Helpful)

Since you asked for more ideas, here are 3 lightweight features that fit your "Offline/Student" theme:

1.  **"Syllabus Tracker":**
    * A simple checklist. You (Developer) pre-load the list of Units for CSE (e.g., "Unit 1: Pointers", "Unit 2: Arrays").
    * Students tick the box ✅ when they finish studying it.
    * **Visual:** A progress bar showing "40% Syllabus Completed".

2.  **"Viva Voice Vault":**
    * A section in the Cyber/Code module.
    * List of top 50 common Interview/Lab questions (e.g., "What is a pointer?", "Diff between malloc and calloc").
    * Tap to reveal the answer.

3.  **"Placement Countdown":**
    * A widget showing "Days left until Final Year".
    * It creates a sense of urgency to study.

**Do you want to add the "Syllabus Tracker" in the next update?**
```