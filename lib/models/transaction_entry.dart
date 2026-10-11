class TransactionEntry {
  TransactionEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.isIncome = false,
    this.note = '',
    this.paymentMethod = 'Cash',
  });

  final String id;
  String title;
  String category;
  double amount;
  DateTime date;
  bool isIncome;
  String note;
  String paymentMethod;
}
