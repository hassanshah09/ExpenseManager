import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'providers/finance_store.dart';
import 'screens/add_expense_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/cart_lists_screen.dart';
import 'screens/category_budgets_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/income_sources_screen.dart';
import 'screens/initial_setup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recurring_screen.dart';
import 'screens/receipt_scanner_screen.dart';
import 'screens/scan_review_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/statements_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/cart_category_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/app_shell.dart';

class OwlanceApp extends StatelessWidget {
  const OwlanceApp({super.key});
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, store, _) => MaterialApp(
      title: 'Owlance',
      debugShowCheckedModeBanner: false,
      theme: buildOwlTheme(),
      darkTheme: buildOwlTheme(dark: true),
      themeMode: store.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/setup': (_) => const InitialSetupScreen(),
        '/home': (_) => const AppShell(),
        '/add': (_) => const AddExpenseScreen(),
        '/stats': (_) => const StatsScreen(),
        '/transactions': (_) => const TransactionsScreen(),
        '/budgets': (_) => const CategoryBudgetsScreen(),
        '/scanner': (_) => const ReceiptScannerScreen(),
        '/review': (_) => const ScanReviewScreen(),
        '/cart': (_) => const CartListsScreen(),
        '/cart-category': (_) => const CartCategoryScreen(),
        '/coach': (_) => const AiCoachScreen(),
        '/income': (_) => const IncomeSourcesScreen(),
        '/statements': (_) => const StatementsScreen(),
        '/recurring': (_) => const RecurringScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/forgot': (_) => const ForgotPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/transaction') {
          return MaterialPageRoute(
            builder: (_) =>
                TransactionDetailScreen(id: settings.arguments as String),
          );
        }
        return null;
      },
    ),
  );
}
