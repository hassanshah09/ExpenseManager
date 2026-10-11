import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/transaction_entry.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) {
      final matches = f.entries.where((e) => e.id == id);
      if (matches.isEmpty) {
        return const Scaffold(
          body: EmptyMessage(text: 'Transaction not found.'),
        );
      }
      final e = matches.first;
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              OwlHeader(
                title: 'Transaction',
                onBack: () => Navigator.pop(context),
                trailing: IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share preview: Owlance transaction'),
                    ),
                  ),
                  icon: const Icon(Icons.ios_share),
                ),
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 38,
                backgroundColor: OwlColors.gold.withValues(alpha: .2),
                child: Icon(
                  e.isIncome ? Icons.south_west : Icons.restaurant,
                  size: 34,
                  color: OwlColors.navy,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  e.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 21,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${e.isIncome ? '+' : '−'}${f.money(e.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: e.isIncome ? OwlColors.green : OwlColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OwlCard(
                child: Column(
                  children: [
                    _detail('Category', e.category),
                    _detail(
                      'Date',
                      '${e.date.day}/${e.date.month}/${e.date.year}',
                    ),
                    _detail('Payment method', e.paymentMethod),
                    _detail('Added by', f.userName),
                    _detail('Note', e.note.isEmpty ? '—' : e.note),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OwlButton(
                      label: 'Delete',
                      icon: Icons.delete_outline,
                      outlined: true,
                      onPressed: () async {
                        final yes = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Delete transaction?'),
                            content: const Text(
                              'This will update your balances and budget totals.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(c, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (yes == true) {
                          f.remove(e.id);
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OwlButton(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditEntryScreen(entry: e),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  Widget _detail(String t, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(t, style: const TextStyle(color: OwlColors.muted)),
        ),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class EditEntryScreen extends StatefulWidget {
  const EditEntryScreen({required this.entry, super.key});
  final TransactionEntry entry;
  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late final title = TextEditingController(text: widget.entry.title);
  late final amount = TextEditingController(
    text: widget.entry.amount.toStringAsFixed(0),
  );
  late String category = widget.entry.category;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OwlHeader(
            title: 'Edit transaction',
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: category,
            items: context
                .read<FinanceStore>()
                .categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => category = v!),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 20),
          OwlButton(
            label: 'Save changes',
            onPressed: () {
              final value = double.tryParse(amount.text);
              if (title.text.trim().isEmpty || value == null || value <= 0) {
                return;
              }
              context.read<FinanceStore>().update(
                widget.entry,
                title: title.text.trim(),
                category: category,
                amount: value,
                isIncome: widget.entry.isIncome,
                date: widget.entry.date,
                note: widget.entry.note,
                paymentMethod: widget.entry.paymentMethod,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
