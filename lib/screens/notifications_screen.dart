import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../mock/mock_notifications.dart';
import '../widgets/owl_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final read = <String>{};
  String filter = 'All';
  final notices = MockNotifications.notices;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          OwlHeader(
            title: 'Notifications',
            onBack: () => Navigator.pop(context),
            trailing: TextButton(
              onPressed: () =>
                  setState(() => read.addAll(notices.map((n) => n.$1))),
              child: const Text('Read all'),
            ),
          ),
          Wrap(
            spacing: 8,
            children: ['All', 'Needs action', 'Budgets']
                .map(
                  (x) => ChoiceChip(
                    label: Text(x),
                    selected: filter == x,
                    onSelected: (_) => setState(() => filter = x),
                  ),
                )
                .toList(),
          ),
          const SectionTitle('Today'),
          ...notices
              .where(
                (n) =>
                    filter == 'All' ||
                    (filter == 'Needs action' && n.$1.contains('Payment')) ||
                    (filter == 'Budgets' && n.$1.contains('Budget')),
              )
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: OwlCard(
                    child: ListTile(
                      leading: Icon(
                        n.$4,
                        color: read.contains(n.$1)
                            ? OwlColors.muted
                            : OwlColors.gold,
                      ),
                      title: Text(n.$1),
                      subtitle: Text(n.$2),
                      trailing: read.contains(n.$1)
                          ? null
                          : const Icon(
                              Icons.circle,
                              size: 9,
                              color: OwlColors.gold,
                            ),
                      onTap: () {
                        setState(() => read.add(n.$1));
                        Navigator.pushNamed(context, n.$3);
                      },
                    ),
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
