import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});
  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  int step = 0;
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Text(
                  'Step ${step + 1} of 3',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (_) => false,
                  ),
                  child: const Text('Skip'),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: (step + 1) / 3,
              color: const Color(0xFFE4B63F),
            ),
            const SizedBox(height: 24),
            Text(
              [
                'Where does your money come from?',
                'Set your monthly budgets',
                'You’re all set!',
              ][step],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              step == 0
                  ? 'Expected values do not change your balance until an actual income is recorded.'
                  : 'Adjust the built-in October demo values.',
            ),
            const SizedBox(height: 18),
            if (step == 0)
              ...f.incomeSources.entries.map(
                (e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(f.money(e.value)),
                ),
              ),
            if (step == 1)
              ...f.budgets.entries.map(
                (e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(f.money(e.value)),
                ),
              ),
            if (step == 2)
              const OwlCard(
                child: Text(
                  'Your demo account is ready. Income and expense totals use one shared in-memory ledger.',
                ),
              ),
            const SizedBox(height: 20),
            OwlButton(
              label: step == 2 ? 'Go to home' : 'Continue',
              onPressed: () {
                if (step < 2) {
                  setState(() => step++);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
