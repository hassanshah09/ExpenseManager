// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:owlance/providers/finance_store.dart';
import 'package:owlance/screens/app_shell.dart';
import 'package:owlance/mock/mock_finance_expectations.dart';
import 'package:owlance/mock/mock_users.dart';

void main() {
  test('initial demo balances match the supplied values', () {
    final store = FinanceStore();
    expect(store.totalIncome, MockFinanceExpectations.monthlyIncome);
    expect(store.totalSpent, MockFinanceExpectations.monthlyExpenses);
    expect(store.balance, MockFinanceExpectations.availableBalance);
    expect(store.budgetTotal, MockFinanceExpectations.monthlyBudgetLimits);
  });

  test('mock user credentials authenticate and can be changed in memory', () {
    final store = FinanceStore();
    expect(MockUsers.accounts, hasLength(3));
    expect(store.userId, MockUsers.demoUserId);
    expect(
      store.authenticate(MockUsers.demoEmail, MockUsers.demoPassword),
      isTrue,
    );
    expect(store.authenticate(MockUsers.demoEmail, 'wrong-password'), isFalse);

    final danish = MockUsers.accounts[1];
    expect(store.authenticate(danish.email, danish.password), isTrue);
    expect(store.userId, danish.id);
    expect(store.userAvatarEmoji, '🐵');

    final hassan = MockUsers.accounts[2];
    expect(store.authenticate(hassan.email, hassan.password), isTrue);
    expect(store.userId, hassan.id);
    expect(store.userAvatarEmoji, '🦁');

    store.createDemoAccount(
      id: 'OWL-NEW-USER',
      name: 'Demo Person',
      emailAddress: 'new@example.com',
      password: 'new-pass-123',
    );
    expect(store.authenticate('new@example.com', 'new-pass-123'), isTrue);
    expect(store.userId, 'OWL-NEW-USER');
  });

  test('adding and deleting an expense updates all totals', () {
    final store = FinanceStore();
    store.add(
      title: MockFinanceExpectations.sampleAddedExpenseTitle,
      category: MockFinanceExpectations.sampleAddedExpenseCategory,
      amount: MockFinanceExpectations.sampleAddedExpenseAmount,
    );
    expect(
      store.totalSpent,
      MockFinanceExpectations.spendingAfterSampleExpense,
    );
    expect(store.balance, MockFinanceExpectations.balanceAfterSampleExpense);
    expect(
      store.spentFor(MockFinanceExpectations.sampleAddedExpenseCategory),
      MockFinanceExpectations.foodSpendingAfterSampleExpense,
    );
    store.remove(store.expenses.first.id);
    expect(store.totalSpent, MockFinanceExpectations.monthlyExpenses);
    expect(store.balance, MockFinanceExpectations.availableBalance);
  });

  testWidgets('dashboard shows shared monthly summary', (tester) async {
    final store = FinanceStore();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: store,
        child: const MaterialApp(home: AppShell()),
      ),
    );
    expect(find.text('This month’s balance'), findsOneWidget);
    expect(
      find.text(store.money(MockFinanceExpectations.availableBalance)),
      findsWidgets,
    );
  });
}
