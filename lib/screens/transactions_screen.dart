import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final search = TextEditingController();
  String filter = 'All';
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) {
      final q = search.text.toLowerCase();
      final rows =
          f.entries
              .where(
                (e) =>
                    (filter == 'All' ||
                        (filter == 'Income' ? e.isIncome : !e.isIncome)) &&
                    (e.title.toLowerCase().contains(q) ||
                        e.category.toLowerCase().contains(q) ||
                        e.note.toLowerCase().contains(q)),
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              OwlHeader(
                title: 'Transactions',
                onBack: Navigator.of(context).canPop()
                    ? () => Navigator.pop(context)
                    : null,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search transactions',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.tune),
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'All', label: Text('All')),
                  ButtonSegment(value: 'Expense', label: Text('Expenses')),
                  ButtonSegment(value: 'Income', label: Text('Income')),
                ],
                selected: {filter},
                onSelectionChanged: (s) => setState(() => filter = s.first),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _tot('Money in', f.money(f.totalIncome), OwlColors.green),
                  const SizedBox(width: 10),
                  _tot('Money out', f.money(f.totalSpent), OwlColors.red),
                ],
              ),
              const SectionTitle('October 2026'),
              if (rows.isEmpty)
                const EmptyMessage(text: 'No transactions match your search.'),
              ...rows.map(
                (e) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 3),
                  leading: CircleAvatar(
                    backgroundColor: OwlColors.gold.withValues(alpha: .16),
                    child: Icon(
                      e.isIncome ? Icons.south_west : Icons.north_east,
                      color: e.isIncome ? OwlColors.green : OwlColors.navy,
                    ),
                  ),
                  title: Text(
                    e.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${e.category} · ${e.date.day}/${e.date.month}/${e.date.year}',
                  ),
                  trailing: Text(
                    '${e.isIncome ? '+' : '−'}${f.money(e.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: e.isIncome ? OwlColors.green : null,
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/transaction',
                    arguments: e.id,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  Widget _tot(String t, String v, Color c) => Expanded(
    child: OwlCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t, style: const TextStyle(color: OwlColors.muted, fontSize: 12)),
          Text(
            v,
            style: TextStyle(fontWeight: FontWeight.w800, color: c),
          ),
        ],
      ),
    ),
  );
}
