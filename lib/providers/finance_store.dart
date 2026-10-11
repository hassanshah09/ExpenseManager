import 'package:flutter/foundation.dart';
import '../models/transaction_entry.dart';
import '../mock/mock_app_defaults.dart';
import '../mock/mock_budgets.dart';
import '../mock/mock_income.dart';
import '../mock/mock_transactions.dart';
import '../mock/mock_users.dart';

class FinanceStore extends ChangeNotifier {
  FinanceStore()
    : _entries = MockTransactions.create(),
      budgets = Map<String, double>.of(MockBudgets.monthlyLimits),
      incomeSources = Map<String, double>.of(MockIncome.expectedMonthlySources);

  final List<TransactionEntry> _entries;
  final Map<String, double> budgets;
  final Map<String, double> incomeSources;
  bool hideBalance = false;
  bool darkMode = false;
  bool _shoppingRecorded = false;
  String userName = MockAppDefaults.userName;
  String currency = MockAppDefaults.currency;
  String email = MockAppDefaults.email;
  String userId = MockUsers.demoUserId;
  String userPassword = MockUsers.demoPassword;
  String userAvatarEmoji = MockUsers.demoAvatar;

  bool authenticate(String emailAddress, String password) {
    final normalizedEmail = emailAddress.trim().toLowerCase();
    if (normalizedEmail == email.toLowerCase() && password == userPassword) {
      return true;
    }

    for (final account in MockUsers.accounts) {
      if (normalizedEmail == account.email.toLowerCase() &&
          password == account.password) {
        userId = account.id;
        userName = account.name;
        email = account.email;
        userPassword = account.password;
        userAvatarEmoji = account.avatarEmoji;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  List<TransactionEntry> get entries => List.unmodifiable(_entries);
  List<TransactionEntry> get expenses =>
      _entries.where((e) => !e.isIncome).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  List<TransactionEntry> get incomes =>
      _entries.where((e) => e.isIncome).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  double get totalIncome =>
      _entries.where((e) => e.isIncome).fold(0, (sum, e) => sum + e.amount);
  double get totalSpent =>
      _entries.where((e) => !e.isIncome).fold(0, (sum, e) => sum + e.amount);
  double get balance => totalIncome - totalSpent;
  double get budgetTotal => budgets.values.fold(0, (sum, value) => sum + value);
  double get savings => MockAppDefaults.savingsBalance;
  List<String> get categories => budgets.keys.toList();
  double spentFor(String category) => expenses
      .where((e) => e.category == category)
      .fold(0, (sum, e) => sum + e.amount);

  void add({
    required String title,
    required String category,
    required double amount,
    bool isIncome = false,
    DateTime? date,
    String note = '',
    String paymentMethod = 'Cash',
  }) {
    _entries.add(
      TransactionEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        category: category,
        amount: amount,
        date: date ?? DateTime.now(),
        isIncome: isIncome,
        note: note,
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }

  void update(
    TransactionEntry entry, {
    required String title,
    required String category,
    required double amount,
    required bool isIncome,
    required DateTime date,
    required String note,
    required String paymentMethod,
  }) {
    entry.title = title;
    entry.category = category;
    entry.amount = amount;
    entry.isIncome = isIncome;
    entry.date = date;
    entry.note = note;
    entry.paymentMethod = paymentMethod;
    notifyListeners();
  }

  void remove(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  bool completeShopping(Map<String, double> purchasedItems) {
    if (_shoppingRecorded) return false;
    _shoppingRecorded = true;
    for (final item in purchasedItems.entries) {
      _entries.add(
        TransactionEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString() + item.key,
          title: item.key,
          category: MockAppDefaults.shoppingExpenseCategory,
          amount: item.value,
          date: DateTime.now(),
          note: 'Shopping list purchase',
        ),
      );
    }
    notifyListeners();
    return true;
  }

  void setBudget(String category, double amount) {
    budgets[category] = amount;
    notifyListeners();
  }

  void setIncomeSource(String name, double amount) {
    incomeSources[name] = amount;
    notifyListeners();
  }

  void removeIncomeSource(String name) {
    incomeSources.remove(name);
    notifyListeners();
  }

  void toggleBalance() {
    hideBalance = !hideBalance;
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void setCurrency(String value) {
    currency = value;
    notifyListeners();
  }

  void setProfile({required String name, required String emailAddress}) {
    userName = name;
    email = emailAddress;
    notifyListeners();
  }

  void createDemoAccount({
    required String id,
    required String name,
    required String emailAddress,
    required String password,
    String avatarEmoji = MockUsers.demoAvatar,
  }) {
    userId = id;
    userName = name;
    email = emailAddress.trim();
    userPassword = password;
    userAvatarEmoji = avatarEmoji;
    notifyListeners();
  }

  void resetDemoData() {
    final defaults = FinanceStore();
    _entries
      ..clear()
      ..addAll(defaults._entries);
    budgets
      ..clear()
      ..addAll(defaults.budgets);
    incomeSources
      ..clear()
      ..addAll(defaults.incomeSources);
    userName = MockAppDefaults.userName;
    email = MockAppDefaults.email;
    userId = MockUsers.demoUserId;
    userPassword = MockUsers.demoPassword;
    userAvatarEmoji = MockUsers.demoAvatar;
    currency = MockAppDefaults.currency;
    _shoppingRecorded = false;
    hideBalance = false;
    notifyListeners();
  }

  String money(num amount) =>
      '$currency ${amount.round().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}';
}
