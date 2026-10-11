import 'mock_users.dart';

abstract final class MockAppDefaults {
  static const String userName = MockUsers.demoName;
  static const String email = MockUsers.demoEmail;
  static const String currency = 'Rs.';
  static const double savingsBalance = 80500;
  static const String profileInitials = 'MA';
  static const int passwordResetCountdownSeconds = 30;
  static const String localCoachDisclosure =
      'Local demo responses only · no AI service is connected.';
  static const String passwordResetDisclosure =
      'Demo only: no reset email was sent.';
  static const List<String> supportedCurrencies = ['Rs.', 'USD'];
  static const List<String> languages = ['English', 'اردو · demo label'];
  static const String incomeCategory = 'Salary';
  static const String shoppingExpenseCategory = 'Food';
  static const String recurringExpenseCategory = 'Bills';
}
