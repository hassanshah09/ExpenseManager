import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_store.dart';
import '../mock/mock_app_defaults.dart';
import '../mock/mock_users.dart';
import '../widgets/owl_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool accepted = false;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          OwlHeader(
            title: 'Create account',
            onBack: () => Navigator.pop(context),
          ),
          const Text('Start managing your money the smart way.'),
          const SizedBox(height: 22),
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: accepted,
            onChanged: (v) => setState(() => accepted = v ?? false),
            title: const Text(
              'I agree to the Terms and Privacy Policy',
              style: TextStyle(fontSize: 13),
            ),
          ),
          OwlButton(
            label: 'Create account',
            onPressed: () {
              if (name.text.trim().isEmpty ||
                  !email.text.contains('@') ||
                  password.text.length < 6 ||
                  !accepted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Enter valid details, a 6+ character password and accept the terms.',
                    ),
                  ),
                );
                return;
              }
              context.read<FinanceStore>().createDemoAccount(
                id: 'OWL-${DateTime.now().millisecondsSinceEpoch}',
                name: name.text.trim(),
                emailAddress: email.text.trim(),
                password: password.text,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/setup',
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 10),
          OwlButton(
            label: 'Sign up with Google · Demo',
            outlined: true,
            onPressed: () {
              context.read<FinanceStore>().createDemoAccount(
                id: MockUsers.demoUserId,
                name: MockAppDefaults.userName,
                emailAddress: MockAppDefaults.email,
                password: MockUsers.demoPassword,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/setup',
                (_) => false,
              );
            },
          ),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Log in'),
            ),
          ),
        ],
      ),
    ),
  );
}
