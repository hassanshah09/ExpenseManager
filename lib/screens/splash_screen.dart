import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: OwlColors.navy,
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 114,
              height: 114,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Center(
                child: Text('🦉', style: TextStyle(fontSize: 72)),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'OWLANCE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            const Text(
              'SMART EXPENSE TRACKER',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Wise with every rupee',
              style: TextStyle(
                color: OwlColors.gold,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),
            FilledButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/onboarding'),
              style: FilledButton.styleFrom(
                backgroundColor: OwlColors.gold,
                foregroundColor: OwlColors.navy,
              ),
              child: const Text('Get started'),
            ),
          ],
        ),
      ),
    ),
  );
}
