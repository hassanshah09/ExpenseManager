# Owlance — offline Flutter demo

Owlance is a local-only expense-management demo. It uses Flutter, Provider/ChangeNotifier, and a single in-memory finance ledger. There is no database, API, authentication server, payment gateway, or cloud connection. State resets when the app process restarts.

## Run

The repository includes `pubspec.lock` so everyone resolves the same package versions. On Windows, install Git, Flutter (Dart SDK is included), and Android Studio with the Android SDK first. Then clone this repository, start an Android emulator (or connect a device with USB debugging), and double-click `run.bat`. The script fetches the pinned Dart/Flutter packages and launches the app.

Alternatively, from the project folder run:

```powershell
flutter pub get
flutter run
```

The first run requires an internet connection to download packages. Flutter and the platform toolchains cannot be bundled into the repository: each user's computer needs a compatible Flutter SDK (Dart >= 3.10.8) and a platform toolchain. For Android, install Android Studio's **Android SDK Command-line Tools**, **Android Emulator**, and an Android system image; create/start a device in Device Manager; accept licenses with `flutter doctor --android-licenses`; and confirm setup with `flutter doctor`. For desktop or web, install the relevant Flutter platform prerequisites instead.

## Architecture

- `lib/main.dart`, `lib/app.dart` — Provider setup, theme selection, and named navigation.
- `lib/core/app_theme.dart` — Owlance navy/gold palette and light/dark themes.
- `lib/models/transaction_entry.dart` — shared transaction model.
- `lib/providers/finance_store.dart` — shared seeded ledger, income/budget values, totals, and mutations.
- `lib/mock/` — the single home for demo transactions, budgets, income sources, cart items, sample receipt data, notifications, app defaults, and test fixtures.
- `lib/mock/mock_users.dart` — change the default offline demo user ID, email, and password here.
- `lib/screens/` — one Dart file per screen; shared interface pieces are in `lib/widgets/owl_widgets.dart`.
- `test/widget_test.dart` — initial ledger math and dashboard rendering tests.

The October 2026 demo ledger starts at income Rs. 80,000, spending Rs. 34,800, available balance Rs. 45,200, and category limits totaling Rs. 50,700. All dashboard, transaction, and category-budget totals derive from the same ledger. Expected income-source values are intentionally kept separate from received income. The editable seed data and test fixtures are stored under `lib/mock/`.

## Demo accounts

- Abbas · Owl avatar — ID `OWL-1001`, `abbas@example.com`, password `Owlance@123`
- Danish · Monkey avatar — ID `OWL-1002`, `danish@example.com`, password `Danish@123`
- Syed Hassan Shah · Lion avatar — ID `OWL-1003`, `hassan@example.com`, password `Hassan@123`

Choose a demo user from the login dropdown to prefill that account's email/password. Change the users, IDs, emails, passwords, or avatar emoji in `lib/mock/mock_users.dart`. Sign-up creates a different in-memory demo account; it does not persist after restarting the app. These credentials are public sample data for this offline demo, not secure authentication; never put a real password here.

## Screen inventory

Each screen has its own source file: Splash, Onboarding, Login, Signup, Forgot Password, Initial Setup, Home, Add Expense, Stats, Transactions, Transaction Detail, Category Budgets, Receipt Scanner, Scan Review, Cart Lists, Cart Category, AI Coach, Income Sources, Statements, Recurring, Notifications, Profile, and Settings.

## Simulated / incomplete features

- Login, signup, Google sign-in, and password reset are local demo flows; no account service or email is contacted.
- Receipt capture displays a built-in sample; no camera capture or OCR is performed.
- Coach answers use deterministic local rules; no AI service is called.
- Reminder switches are preferences only; no background notifications are scheduled.
- Statement PDF and image export controls currently report that export is unavailable and do not create files.
- Some secondary screen interactions and visual details remain demo-level rather than production-complete. The provided attachment was a composite screen collage; an individual-resolution `MAD PROJECT.zip` was not present in the workspace, so pixel-by-pixel comparison against the original files has not been possible.

## Validation

Run `flutter analyze` and `flutter test` from this directory. Android emulator execution depends on completing the local Android SDK setup above.
