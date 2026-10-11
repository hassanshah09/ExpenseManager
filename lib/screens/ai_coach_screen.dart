import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';
import '../mock/mock_app_defaults.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});
  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final input = TextEditingController();
  final messages = <String>[];
  String period = 'Weekly';
  void ask(FinanceStore f) {
    final q = input.text.trim().toLowerCase();
    if (q.isEmpty) return;
    String answer;
    if (q.contains('spend')) {
      answer = 'You have recorded ${f.money(f.totalSpent)} in expenses.';
    } else if (q.contains('save')) {
      answer =
          'Your recorded balance is ${f.money(f.balance)}. Savings are separate.';
    } else if (q.contains('budget') || q.contains('over')) {
      final over = f.categories
          .where((c) => f.spentFor(c) > (f.budgets[c] ?? 0))
          .toList();
      answer = over.isEmpty
          ? 'No category is over budget.'
          : 'Over budget: ${over.join(', ')}.';
    } else {
      answer = 'Your available demo balance is ${f.money(f.balance)}.';
    }
    setState(() {
      messages.add('You: ${input.text}\nCoach (offline demo): $answer');
      input.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'AI Coach',
              onBack: Navigator.of(context).canPop()
                  ? () => Navigator.pop(context)
                  : null,
            ),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Weekly', label: Text('Weekly')),
                ButtonSegment(value: 'Monthly', label: Text('Monthly')),
              ],
              selected: {period},
              onSelectionChanged: (s) => setState(() => period = s.first),
            ),
            const SizedBox(height: 12),
            OwlCard(
              color: OwlColors.navy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$period overview · October',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    f.money(f.totalSpent),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Balance ${f.money(f.balance)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SectionTitle('Insights'),
            ...f.categories
                .where((c) => f.spentFor(c) > (f.budgets[c] ?? 0) * .8)
                .map(
                  (c) => OwlCard(
                    child: Text('$c spending is near its budget limit.'),
                  ),
                ),
            const SectionTitle('Ask the Coach'),
            ...messages.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OwlCard(child: Text(m)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: 'How much did I spend?',
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => ask(f),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              MockAppDefaults.localCoachDisclosure,
              style: TextStyle(color: OwlColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}
