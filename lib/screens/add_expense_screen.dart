import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';
import '../mock/mock_quick_expense_rules.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  final note = TextEditingController();
  String category = 'Food';
  String payment = 'Cash';
  bool isIncome = false;
  DateTime date = DateTime.now();
  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  void parseQuick() {
    final text = title.text.toLowerCase();
    final match = RegExp(r'\d+(?:\.\d{1,2})?').firstMatch(text);
    if (match != null) amount.text = match.group(0)!;
    for (final rule in MockQuickExpenseRules.categoryKeywords.entries) {
      if (rule.value.any((keyword) => text.contains(keyword))) {
        category = rule.key;
        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OwlHeader(title: 'Add Expense', onBack: () => Navigator.pop(context)),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Expense'),
                icon: Icon(Icons.arrow_upward),
              ),
              ButtonSegment(
                value: true,
                label: Text('Income'),
                icon: Icon(Icons.arrow_downward),
              ),
            ],
            selected: {isIncome},
            onSelectionChanged: (v) => setState(() {
              isIncome = v.first;
              if (isIncome) {
                category = 'Salary';
              } else {
                category = 'Food';
              }
            }),
          ),
          const SizedBox(height: 18),
          const Text(
            'Quick add',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: title,
            decoration: InputDecoration(
              hintText: MockQuickExpenseRules.exampleCommand,
              suffixIcon: IconButton(
                onPressed: parseQuick,
                icon: const Icon(Icons.auto_awesome),
              ),
            ),
            onSubmitted: (_) => parseQuick(),
          ),
          const SizedBox(height: 22),
          Center(
            child: TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                prefixText: 'Rs. ',
                hintText: '0',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                (isIncome
                        ? ['Salary', 'Trading', 'E-commerce', 'Freelance']
                        : context.read<FinanceStore>().categories)
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: c == category,
                        onSelected: (_) => setState(() => category = c),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 17),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Date'),
            trailing: Text('${date.day}/${date.month}/${date.year}'),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (d != null) setState(() => date = d);
            },
          ),
          DropdownButtonFormField<String>(
            initialValue: payment,
            decoration: const InputDecoration(labelText: 'Payment method'),
            items: [
              'Cash',
              'Debit card',
              'Credit card',
              'Bank transfer',
              'Wallet',
            ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) => setState(() => payment = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: note,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: 24),
          OwlButton(
            label: isIncome ? 'Save Income' : 'Save Expense',
            icon: Icons.check,
            onPressed: () {
              final value = double.tryParse(amount.text.replaceAll(',', ''));
              if (title.text.trim().isEmpty || value == null || value <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a description and a valid amount.'),
                  ),
                );
                return;
              }
              context.read<FinanceStore>().add(
                title: title.text.trim(),
                category: category,
                amount: value,
                isIncome: isIncome,
                date: date,
                note: note.text.trim(),
                paymentMethod: payment,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isIncome ? 'Income added' : 'Expense saved'),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
