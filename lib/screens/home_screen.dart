import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: OwlColors.navy,
                  child: Text('🦉', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OWLANCE',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Good morning,',
                        style: TextStyle(color: OwlColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  f.userName.split(' ').first,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/notifications'),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/scanner'),
                  icon: const Icon(Icons.document_scanner_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: OwlColors.navy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'This month’s balance',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      IconButton(
                        onPressed: f.toggleBalance,
                        icon: Icon(
                          f.hideBalance
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    f.hideBalance ? '••••••' : f.money(f.balance),
                    style: const TextStyle(
                      fontSize: 31,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _summary(
                          'INCOME',
                          f.money(f.totalIncome),
                          Icons.arrow_downward,
                          OwlColors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summary(
                          'SPENDING',
                          f.money(f.totalSpent),
                          Icons.arrow_upward,
                          OwlColors.gold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _quick(
                    'Remaining',
                    f.money(f.balance),
                    Icons.account_balance_wallet_outlined,
                    OwlColors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _quick(
                    'Spent',
                    f.money(f.totalSpent),
                    Icons.trending_down,
                    OwlColors.red,
                  ),
                ),
              ],
            ),
            const SectionTitle('Spending by category', action: 'This month'),
            OwlCard(
              child: Column(
                children: f.categories
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(_icon(c), size: 18, color: _color(c)),
                            const SizedBox(width: 9),
                            Expanded(child: Text(c)),
                            SizedBox(
                              width: 88,
                              child: LinearProgressIndicator(
                                value: (f.spentFor(c) / (f.budgets[c] ?? 1))
                                    .clamp(0, 1),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(8),
                                color: _color(c),
                                backgroundColor: OwlColors.border,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              f.money(f.spentFor(c)),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
            OwlCard(
              color: const Color(0xFFFFF7DD),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, color: OwlColors.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Safe to spend today',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          f.money(f.balance / 20),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SectionTitle(
              'Budget alerts',
              action: 'See all',
              onTap: () => Navigator.pushNamed(context, '/budgets'),
            ),
            ...f.categories
                .where((c) => f.spentFor(c) >= (f.budgets[c] ?? 1) * .8)
                .take(2)
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OwlCard(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: OwlColors.gold,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$c budget is ${((f.spentFor(c) / (f.budgets[c] ?? 1)) * 100).round()}% used',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            OwlCard(
              color: OwlColors.gold,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/coach'),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Coach',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'You’re doing well—keep an eye on your category budgets.',
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            SectionTitle(
              'Recent transactions',
              action: 'See all',
              onTap: () => Navigator.pushNamed(context, '/transactions'),
            ),
            ...f.entries
                .take(4)
                .map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: _color(
                        e.category,
                      ).withValues(alpha: .12),
                      child: Icon(
                        _icon(e.category),
                        color: _color(e.category),
                        size: 19,
                      ),
                    ),
                    title: Text(
                      e.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${e.category} · ${e.isIncome ? 'Income' : e.paymentMethod}',
                    ),
                    trailing: Text(
                      '${e.isIncome ? '+' : '−'}${f.money(e.amount)}',
                      style: TextStyle(
                        color: e.isIncome ? OwlColors.green : OwlColors.ink,
                        fontWeight: FontWeight.w800,
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
    ),
  );
  Widget _summary(String title, String value, IconData icon, Color color) =>
      Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white60, fontSize: 9),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  Widget _quick(String title, String amount, IconData icon, Color color) =>
      OwlCard(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Icon(icon, color: color, size: 19),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: OwlColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  IconData _icon(String c) => switch (c) {
    'Food' => Icons.restaurant,
    'Transport' => Icons.directions_car,
    'Shopping' => Icons.shopping_bag,
    'Bills' => Icons.receipt_long,
    _ => Icons.category,
  };
  Color _color(String c) => switch (c) {
    'Food' => const Color(0xFFF3B743),
    'Transport' => OwlColors.blue,
    'Shopping' => OwlColors.purple,
    'Bills' => OwlColors.teal,
    _ => OwlColors.green,
  };
}
