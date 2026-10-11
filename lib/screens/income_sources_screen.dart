import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class IncomeSourcesScreen extends StatelessWidget {
  const IncomeSourcesScreen({super.key});
  Future<void> edit(
    BuildContext context,
    FinanceStore f,
    String? old,
    double amount,
  ) async {
    final name = TextEditingController(text: old ?? '');
    final value = TextEditingController(
      text: amount == 0 ? '' : amount.round().toString(),
    );
    final result = await showDialog<(String, double)>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(old == null ? 'Add source' : 'Edit source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Source'),
            ),
            TextField(
              controller: value,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Expected monthly amount',
              ),
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
              final n = double.tryParse(value.text);
              if (name.text.trim().isNotEmpty && n != null && n > 0) {
                Navigator.pop(c, (name.text.trim(), n));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      if (old != null && old != result.$1) f.removeIncomeSource(old);
      f.setIncomeSource(result.$1, result.$2);
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Income Sources',
              onBack: Navigator.of(context).canPop()
                  ? () => Navigator.pop(context)
                  : null,
              trailing: IconButton(
                onPressed: () => edit(context, f, null, 0),
                icon: const Icon(Icons.add_circle, color: OwlColors.navy),
              ),
            ),
            OwlCard(
              color: OwlColors.navy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expected monthly income',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    f.money(f.incomeSources.values.fold(0.0, (a, b) => a + b)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Expected amounts are not counted as received income.',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SectionTitle('My sources'),
            ...f.incomeSources.entries.map(
              (e) => OwlCard(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.payments_outlined),
                  ),
                  title: Text(e.key),
                  subtitle: const Text('Monthly · Expected'),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(f.money(e.value)),
                      IconButton(
                        onPressed: () => edit(context, f, e.key, e.value),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
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
