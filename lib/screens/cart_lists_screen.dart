import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../mock/mock_cart.dart';
import '../widgets/owl_widgets.dart';

class CartListsScreen extends StatefulWidget {
  const CartListsScreen({super.key});
  @override
  State<CartListsScreen> createState() => _CartListsScreenState();
}

class _CartListsScreenState extends State<CartListsScreen> {
  final lists = List<String>.of(MockCart.categories);
  final completed = <String>{};
  Future<void> addList() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('New shopping list'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (value != null && value.isNotEmpty) {
      setState(() => lists.insert(0, value));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          OwlHeader(
            title: 'Cart',
            onBack: Navigator.of(context).canPop()
                ? () => Navigator.pop(context)
                : null,
            trailing: IconButton(
              onPressed: addList,
              icon: const Icon(Icons.add_circle, color: OwlColors.navy),
            ),
          ),
          const Text('Plan your shopping and keep spending in check.'),
          const SectionTitle('My categories'),
          ...lists
              .where((x) => !completed.contains(x))
              .map(
                (x) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OwlCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFF8F0D7),
                        child: Icon(
                          Icons.shopping_basket_outlined,
                          color: OwlColors.navy,
                        ),
                      ),
                      title: Text(
                        x,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text('2 items · Planned spending'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.pushNamed(context, '/cart-category'),
                    ),
                  ),
                ),
              ),
          const SectionTitle('Completed'),
          ...completed.map(
            (x) => ListTile(
              leading: const Icon(Icons.check_circle, color: OwlColors.green),
              title: Text(x),
            ),
          ),
          if (completed.isEmpty)
            const Text(
              'Your completed lists will appear here.',
              style: TextStyle(color: OwlColors.muted),
            ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: addList,
      icon: const Icon(Icons.add),
      label: const Text('Add category'),
    ),
  );
}
