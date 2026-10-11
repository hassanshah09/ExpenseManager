import '../models/transaction_entry.dart';

abstract final class MockTransactions {
  static final reportingDate = DateTime(2026, 10, 11, 12);
  static List<TransactionEntry> create() {
    final now = reportingDate;
    return [
      TransactionEntry(id: '1', title: 'Burger', category: 'Food', amount: 500, date: now.subtract(const Duration(hours: 2))),
      TransactionEntry(id: '2', title: 'Chai & snacks', category: 'Food', amount: 250, date: now.subtract(const Duration(days: 1))),
      TransactionEntry(id: '3', title: 'Weekly groceries', category: 'Food', amount: 11750, date: now.subtract(const Duration(days: 3))),
      TransactionEntry(id: '4', title: 'Careem ride', category: 'Transport', amount: 1200, date: now.subtract(const Duration(days: 1))),
      TransactionEntry(id: '5', title: 'Petrol', category: 'Transport', amount: 5800, date: now.subtract(const Duration(days: 4))),
      TransactionEntry(id: '6', title: 'T-shirt', category: 'Shopping', amount: 2200, date: now.subtract(const Duration(days: 2))),
      TransactionEntry(id: '7', title: 'Online shopping', category: 'Shopping', amount: 4100, date: now.subtract(const Duration(days: 6))),
      TransactionEntry(id: '8', title: 'Electricity bill', category: 'Bills', amount: 5800, date: now.subtract(const Duration(days: 5))),
      TransactionEntry(id: '9', title: 'Course supplies', category: 'Others', amount: 3200, date: now.subtract(const Duration(days: 7))),
      TransactionEntry(id: '10', title: 'Job Salary', category: 'Salary', amount: 60000, date: DateTime(2026, 10, 1), isIncome: true),
      TransactionEntry(id: '11', title: 'Trading', category: 'Trading', amount: 12000, date: DateTime(2026, 10, 3), isIncome: true),
      TransactionEntry(id: '12', title: 'Online store sales', category: 'E-commerce', amount: 8000, date: DateTime(2026, 10, 8), isIncome: true),
    ];
  }
}
