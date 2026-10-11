import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../mock/mock_cart.dart';
import '../widgets/owl_widgets.dart';

class CartCategoryScreen extends StatefulWidget {
  const CartCategoryScreen({super.key});
  @override
  State<CartCategoryScreen> createState() => _CartCategoryScreenState();
}

class _CartCategoryScreenState extends State<CartCategoryScreen> {
  final items = Map<String, double>.of(MockCart.weeklyGroceries);
  final bought = Set<String>.of(MockCart.initiallyBought);
  bool finished = false;
  double get spent => bought.fold(0, (sum, n) => sum + (items[n] ?? 0));
  Future<void> addItem() async {
    final name = TextEditingController();
    final price = TextEditingController();
    final result = await showDialog<(String, double)>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Item'),
            ),
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Expected price'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(price.text);
              if (name.text.trim().isNotEmpty && amount != null && amount > 0) {
                Navigator.pop(c, (name.text.trim(), amount));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => items[result.$1] = result.$2);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          OwlHeader(
            title: MockCart.defaultCategoryName,
            onBack: () => Navigator.pop(context),
          ),
          OwlCard(
            color: OwlColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Planned · Spent · Left',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  'Rs. ${MockCart.weeklyPlan.round()} · Rs. ${spent.round()} · Rs. ${(MockCart.weeklyPlan - spent).round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                LinearProgressIndicator(
                  value: (spent / MockCart.weeklyPlan).clamp(0.0, 1.0),
                  color: OwlColors.gold,
                  backgroundColor: Colors.white24,
                ),
              ],
            ),
          ),
          const SectionTitle(MockCart.toBuyLabel),
          ...items.entries
              .where((e) => !bought.contains(e.key))
              .map(
                (e) => CheckboxListTile(
                  value: false,
                  title: Text(e.key),
                  subtitle: Text('Rs. ${e.value.round()}'),
                  onChanged: (_) => setState(() => bought.add(e.key)),
                ),
              ),
          const SectionTitle(MockCart.boughtLabel),
          ...items.entries
              .where((e) => bought.contains(e.key))
              .map(
                (e) => CheckboxListTile(
                  value: true,
                  title: Text(e.key),
                  subtitle: Text('Rs. ${e.value.round()}'),
                  onChanged: (_) => setState(() => bought.remove(e.key)),
                ),
              ),
          OwlButton(label: 'Add item', outlined: true, onPressed: addItem),
          const SizedBox(height: 12),
          OwlButton(
            label: finished ? 'Shopping saved' : 'Finish and add to expenses',
            onPressed: finished
                ? null
                : () {
                    final ok = context.read<FinanceStore>().completeShopping({
                      for (final n in bought) n: items[n]!,
                    });
                    setState(() => finished = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Bought items added to expenses.'
                              : 'This list was already recorded.',
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    ),
  );
}
