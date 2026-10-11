import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_store.dart';
import '../mock/mock_app_defaults.dart';
import '../mock/mock_users.dart';
import '../widgets/owl_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: MockAppDefaults.email);
  final password = TextEditingController(text: MockUsers.demoPassword);
  String selectedUserId = MockUsers.demoUserId;
  bool visible = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Text(
                MockUsers.accounts
                    .firstWhere((account) => account.id == selectedUserId)
                    .avatarEmoji,
                style: const TextStyle(fontSize: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
              ),
              const Text('Sign in to continue managing your money.'),
              const SizedBox(height: 10),
              const OwlCard(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Offline demo credentials are prefilled. Change the default ID, email, or password in lib/mock/mock_users.dart.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: selectedUserId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Demo user'),
                items: MockUsers.accounts
                    .map(
                      (account) => DropdownMenuItem(
                        value: account.id,
                        child: Row(
                          children: [
                            Text(account.avatarEmoji),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${account.name} · ${account.id}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                selectedItemBuilder: (context) => MockUsers.accounts
                    .map(
                      (account) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          '${account.avatarEmoji}  ${account.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  final account = MockUsers.accounts.firstWhere(
                    (item) => item.id == id,
                  );
                  setState(() {
                    selectedUserId = account.id;
                    email.text = account.email;
                    password.text = account.password;
                  });
                },
              ),
              const SizedBox(height: 26),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: !visible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => visible = !visible),
                    icon: Icon(
                      visible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Text('Forgot password?'),
                ),
              ),
              OwlButton(label: 'Log in', onPressed: () => _login(context)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(child: Text('or')),
              ),
              OwlButton(
                label: 'Continue with Google · Demo',
                outlined: true,
                onPressed: () => _openDemo(context),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('Don’t have an account?  Sign up'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text('Skip sign-in · Open demo'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  void _login(BuildContext context) {
    if (!email.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email address.')),
      );
      return;
    }
    if (!context.read<FinanceStore>().authenticate(email.text, password.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password is incorrect.')),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  void _openDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google sign-in is simulated in this demo.'),
      ),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }
}
