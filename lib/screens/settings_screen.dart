import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';
import '../mock/mock_app_defaults.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool reminders = true;
  String language = 'English';
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Settings',
              onBack: Navigator.of(context).canPop()
                  ? () => Navigator.pop(context)
                  : null,
            ),
            const SectionTitle('Appearance'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark mode'),
              value: f.darkMode,
              onChanged: (_) => f.toggleTheme(),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Language'),
              subtitle: Text(language),
              trailing: const Icon(Icons.chevron_right),
              onTap: selectLanguage,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Currency'),
              subtitle: Text(f.currency == 'Rs.' ? 'PKR (Rs.)' : f.currency),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => selectCurrency(context, f),
            ),
            const SectionTitle('Reminders and privacy'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Daily log reminder'),
              subtitle: const Text(
                'App preference only; no device notification is scheduled.',
              ),
              value: reminders,
              onChanged: (v) => setState(() => reminders = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hide balance on open'),
              value: f.hideBalance,
              onChanged: (_) => f.toggleBalance(),
            ),
            const SectionTitle('Data'),
            OwlCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delete all demo data',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: OwlColors.red,
                    ),
                  ),
                  const Text('Restore the original sample ledger.'),
                  TextButton(
                    onPressed: () => reset(context, f),
                    child: const Text('Reset demo data'),
                  ),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Owlance · Offline demo',
                  style: TextStyle(color: OwlColors.muted),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> selectLanguage() async {
    final value = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Language'),
        children: MockAppDefaults.languages
            .map(
              (x) => SimpleDialogOption(
                onPressed: () => Navigator.pop(c, x),
                child: Text(x),
              ),
            )
            .toList(),
      ),
    );
    if (value != null) setState(() => language = value);
  }

  Future<void> selectCurrency(BuildContext context, FinanceStore f) async {
    final value = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Currency'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(c, MockAppDefaults.currency),
            child: const Text('PKR · Rs.'),
          ),
          SimpleDialogOption(
            onPressed: () =>
                Navigator.pop(c, MockAppDefaults.supportedCurrencies[1]),
            child: const Text('USD · no exchange conversion'),
          ),
        ],
      ),
    );
    if (value != null) f.setCurrency(value);
  }

  Future<void> reset(BuildContext context, FinanceStore f) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Reset demo data?'),
        content: const Text(
          'This restores the original sample transactions and budgets.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (yes == true) f.resetDemoData();
  }
}
