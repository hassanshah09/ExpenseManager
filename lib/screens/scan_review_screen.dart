import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_store.dart';
import '../mock/mock_receipt.dart';
import '../widgets/owl_widgets.dart';

class ScanReviewScreen extends StatefulWidget {
  const ScanReviewScreen({super.key});
  @override
  State<ScanReviewScreen> createState() => _ScanReviewScreenState();
}

class _ScanReviewScreenState extends State<ScanReviewScreen> {
  final items = Map<String, double>.of(MockReceipt.items);
  String category = 'Food';
  double get total => items.values.fold(0, (a, b) => a + b);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          OwlHeader(title: 'Review scan', onBack: () => Navigator.pop(context)),
          OwlCard(
            child: Text(
              '${MockReceipt.merchant} · ${MockReceipt.reviewLabel} · Rs. ${MockReceipt.total.round()}',
            ),
          ),
          const SectionTitle('Detected items'),
          ...items.entries.map(
            (e) => ListTile(
              title: Text(e.key),
              trailing: Text('Rs. ${e.value.round()}'),
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: context
                .read<FinanceStore>()
                .categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => category = v ?? category),
          ),
          ListTile(
            title: const Text('Total'),
            trailing: Text(
              context.read<FinanceStore>().money(total),
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
          ),
          OwlButton(
            label: 'Save expense',
            onPressed: () {
              context.read<FinanceStore>().add(
                title: '${MockReceipt.merchant} receipt',
                category: category,
                amount: total,
              );
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            },
          ),
        ],
      ),
    ),
  );
}
