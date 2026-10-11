abstract final class MockCart {
  static const String defaultCategoryName = 'Weekly groceries';
  static const String toBuyLabel = 'To buy';
  static const String boughtLabel = 'Bought';
  static const List<String> categories = [
    'Weekly groceries',
    'Winter clothes',
    'University stationery',
    'Monthly grocery',
    'Party snacks',
  ];
  static const Map<String, double> weeklyGroceries = {
    'Milk': 560,
    'Bread': 180,
    'Eggs': 480,
    'Rice': 1880,
  };
  static const List<String> initiallyBought = ['Milk'];
  static const double weeklyPlan = 4000;
}
