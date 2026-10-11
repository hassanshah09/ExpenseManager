import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../mock/mock_recurring.dart';
import '../mock/mock_app_defaults.dart';
import '../widgets/owl_widgets.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});
  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  final pending = Map<String, double>.of(MockRecurring.pending);
  final paid = Map<String, double>.of(MockRecurring.paid);
  Future<void> confirm(String name, double amount) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Confirm $name?'),
        content: const Text('This records one expense in your demo ledger.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (yes == true) {
      setState(() {
        pending.remove(name);
        paid[name] = amount;
      });
      context.read<FinanceStore>().add(
        title: name,
        category: MockAppDefaults.recurringExpenseCategory,
        amount: amount,
        note: 'Recurring payment',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          OwlHeader(
            title: 'Recurring',
            onBack: Navigator.of(context).canPop()
                ? () => Navigator.pop(context)
                : null,
          ),
          OwlCard(
            color: OwlColors.navy,
            child: Text(
              'Monthly fixed payments · Rs. ${[...pending.values, ...paid.values].fold<double>(0, (a, b) => a + b).round()}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SectionTitle('Waiting for you'),
          ...pending.entries.map(
            (e) => ListTile(
              title: Text(e.key),
              subtitle: Text('Due soon · Rs. ${e.value.round()}'),
              trailing: IconButton(
                onPressed: () => confirm(e.key, e.value),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: OwlColors.green,
                ),
              ),
            ),
          ),
          const SectionTitle('Paid this month'),
          ...paid.entries.map(
            (e) => ListTile(
              title: Text(e.key),
              trailing: Text('Rs. ${e.value.round()}'),
            ),
          ),
        ],
      ),
    ),
  );
}
