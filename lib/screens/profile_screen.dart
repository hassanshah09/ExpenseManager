import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/finance_store.dart';
import '../widgets/owl_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<FinanceStore>(
    builder: (context, f, _) => Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            OwlHeader(
              title: 'Profile',
              trailing: IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: const Icon(Icons.settings_outlined),
              ),
            ),
            OwlCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: OwlColors.navy,
                    child: Text(
                      f.userAvatarEmoji,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'ID: ${f.userId} · ${f.email}',
                          style: const TextStyle(color: OwlColors.muted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => editName(context, f),
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
            const SectionTitle('Savings'),
            OwlCard(
              color: OwlColors.navy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Savings account',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    f.money(f.savings),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    'Separate from spendable balance',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SectionTitle('My money'),
            for (final item in [
              (Icons.account_balance_wallet_outlined, 'Budgets', '/budgets'),
              (Icons.payments_outlined, 'Income Sources', '/income'),
              (Icons.repeat, 'Recurring Payments', '/recurring'),
              (Icons.description_outlined, 'Statements', '/statements'),
              (Icons.auto_awesome, 'AI Coach', '/coach'),
              (Icons.settings_outlined, 'Settings', '/settings'),
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(item.$1, color: OwlColors.navy),
                title: Text(item.$2),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, item.$3),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline),
              title: const Text('Help and feedback'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Owlance',
                children: const [
                  Text('Offline demo. No support service is connected.'),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              ),
              icon: const Icon(Icons.logout, color: OwlColors.red),
              label: const Text(
                'Log out',
                style: TextStyle(color: OwlColors.red),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> editName(BuildContext context, FinanceStore f) async {
    final controller = TextEditingController(text: f.userName);
    final value = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      f.setProfile(name: value, emailAddress: f.email);
    }
  }
}
