abstract final class MockQuickExpenseRules {
  static const Map<String, List<String>> categoryKeywords = {
    'Transport': ['petrol', 'ride', 'careem'],
    'Shopping': ['shirt', 'clothes', 'store'],
    'Bills': ['bill', 'electric'],
    'Food': ['food', 'burger', 'chai'],
  };
  static const String exampleCommand = 'e.g. 500 burger';
}
