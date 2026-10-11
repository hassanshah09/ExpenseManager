import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';
import '../mock/mock_stats.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Stats',
              trailing: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/statements'),
                child: const Text('Statements'),
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'Week', label: Text('Week')),
                ButtonSegment(value: 'Month', label: Text('Month')),
                ButtonSegment(value: 'Year', label: Text('Year')),
              ],
              selected: {'Month'},
              onSelectionChanged: (_) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _metric(
                  context,
                  'Income',
                  f.money(f.totalIncome),
                  OwlColors.green,
                ),
                const SizedBox(width: 8),
                _metric(
                  context,
                  'Spending',
                  f.money(f.totalSpent),
                  OwlColors.red,
                ),
                const SizedBox(width: 8),
                _metric(context, 'Balance', f.money(f.balance), OwlColors.gold),
              ],
            ),
            const SectionTitle('Monthly spending'),
            OwlCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.money(f.totalSpent),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(6, (i) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 27,
                              height: 110 * MockStats.spendingBarHeights[i],
                              decoration: BoxDecoration(
                                color: i == 5
                                    ? OwlColors.gold
                                    : OwlColors.navy.withValues(alpha: .18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              MockStats.monthLabels[i],
                              style: const TextStyle(
                                fontSize: 10,
                                color: OwlColors.muted,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SectionTitle('By category'),
            ...f.categories.map((c) {
              final value = f.spentFor(c);
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: OwlCard(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(f.money(value)),
                          const SizedBox(width: 8),
                          Text(
                            '${f.totalSpent == 0 ? 0 : (value / f.totalSpent * 100).round()}%',
                            style: const TextStyle(color: OwlColors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: f.totalSpent == 0 ? 0 : value / f.totalSpent,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(8),
                        color: OwlColors.gold,
                      ),
                    ],
                  ),
                ),
              );
            }),
            SectionTitle(
              'Top expenses',
              action: 'See all',
              onTap: () => Navigator.pushNamed(context, '/transactions'),
            ),
            ...f.expenses
                .take(3)
                .map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.title),
                    subtitle: Text(e.category),
                    trailing: Text(
                      f.money(e.amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
  Widget _metric(BuildContext c, String label, String value, Color color) =>
      Expanded(
        child: OwlCard(
          padding: const EdgeInsets.all(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: OwlColors.muted),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
