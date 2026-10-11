import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class CategoryBudgetsScreen extends StatelessWidget {
  const CategoryBudgetsScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Budgets',
              onBack: Navigator.of(context).canPop()
                  ? () => Navigator.pop(context)
                  : null,
              trailing: IconButton(
                onPressed: () => _edit(context, f, null),
                icon: const Icon(Icons.add_circle, color: OwlColors.navy),
              ),
            ),
            const SizedBox(height: 10),
            OwlCard(
              color: OwlColors.navy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly budget',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    f.money(f.budgetTotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${f.money(f.totalSpent)} used  ·  ${f.money(f.budgetTotal - f.totalSpent)} left',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (f.totalSpent / f.budgetTotal).clamp(0, 1),
                    color: OwlColors.gold,
                    backgroundColor: Colors.white24,
                  ),
                ],
              ),
            ),
            const SectionTitle('Categories', action: 'Edit limits'),
            ...f.categories.map((c) {
              final limit = f.budgets[c] ?? 0;
              final spent = f.spentFor(c);
              final ratio = limit == 0 ? 0 : spent / limit;
              final color = ratio >= 1
                  ? OwlColors.red
                  : ratio >= .8
                  ? OwlColors.gold
                  : OwlColors.green;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OwlCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: color.withValues(alpha: .12),
                            child: Icon(
                              Icons.wallet_outlined,
                              size: 17,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              c,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${(ratio * 100).round()}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _edit(context, f, c),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                          ),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0).toDouble(),
                        color: color,
                        backgroundColor: OwlColors.border,
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Text(
                            '${f.money(spent)} used',
                            style: const TextStyle(
                              fontSize: 11,
                              color: OwlColors.muted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Limit ${f.money(limit)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: OwlColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SectionTitle('Alerts'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Warn me at 80%'),
              value: true,
              onChanged: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Budget alert preference updated for this demo.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> _edit(
    BuildContext context,
    FinanceStore f,
    String? category,
  ) async {
    final name = TextEditingController(text: category ?? '');
    final amount = TextEditingController(
      text: category == null
          ? ''
          : (f.budgets[category] ?? 0).round().toString(),
    );
    final result = await showDialog<(String, double)?>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(category == null ? 'Add budget' : 'Edit $category budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              enabled: category == null,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly limit'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final n = double.tryParse(amount.text);
              if (name.text.trim().isNotEmpty && n != null && n > 0) {
                Navigator.pop(c, (name.text.trim(), n.toDouble()));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) f.setBudget(result.$1, result.$2);
  }
}
