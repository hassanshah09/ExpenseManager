import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class StatementsScreen extends StatefulWidget {
  const StatementsScreen({super.key});
  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  String range = 'This month';
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Statements',
              onBack: () => Navigator.pop(context),
            ),
            Wrap(
              spacing: 7,
              children: ['This month', 'Last 2 months', 'This year']
                  .map(
                    (x) => ChoiceChip(
                      label: Text(x),
                      selected: range == x,
                      onSelected: (_) => setState(() => range = x),
                    ),
                  )
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: OwlCard(
                    child: Text(
                      'Income\n${f.money(f.totalIncome)}',
                      style: const TextStyle(color: OwlColors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OwlCard(
                    child: Text(
                      'Expenses\n${f.money(f.totalSpent)}',
                      style: const TextStyle(color: OwlColors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SectionTitle('Transaction records'),
            ...f.entries.map(
              (e) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(e.title),
                subtitle: Text(
                  '${e.date.day}/${e.date.month}/${e.date.year} · ${e.category}',
                ),
                trailing: Text('${e.isIncome ? '+' : '−'}${f.money(e.amount)}'),
              ),
            ),
            OwlButton(
              label: 'Export statement · PDF',
              icon: Icons.picture_as_pdf_outlined,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'PDF export is unavailable; no file was generated.',
                  ),
                ),
              ),
            ),
            OwlButton(
              label: 'Export image',
              icon: Icons.image_outlined,
              outlined: true,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Image export is unavailable; no file was generated.',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
