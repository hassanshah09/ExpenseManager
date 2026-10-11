import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/owl_widgets.dart';
import '../mock/mock_app_defaults.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();
  Timer? timer;
  int seconds = 0;
  bool sent = false;
  @override
  void dispose() {
    timer?.cancel();
    email.dispose();
    super.dispose();
  }

  void send() {
    if (!email.text.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid email.')));
      return;
    }
    setState(() {
      sent = true;
      seconds = MockAppDefaults.passwordResetCountdownSeconds;
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds <= 1) {
        t.cancel();
        setState(() => seconds = 0);
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(23),
        children: [
          OwlHeader(
            title: 'Forgot password?',
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 30),
          const Icon(Icons.key_rounded, size: 60, color: Color(0xFFE4B63F)),
          const SizedBox(height: 16),
          const Text(
            'Reset your password',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
          ),
          const Text(
            'Enter your email to see an offline demo confirmation. No email is sent.',
          ),
          const SizedBox(height: 22),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email address'),
          ),
          const SizedBox(height: 16),
          OwlButton(
            label: seconds > 0
                ? 'Resend link · ${seconds}s'
                : sent
                ? 'Resend link'
                : 'Send reset link',
            onPressed: seconds > 0 ? null : send,
          ),
          if (sent)
            const Padding(
              padding: EdgeInsets.only(top: 18),
              child: OwlCard(
                child: Text(
                  MockAppDefaults.passwordResetDisclosure,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to login'),
          ),
        ],
      ),
    ),
  );
}
