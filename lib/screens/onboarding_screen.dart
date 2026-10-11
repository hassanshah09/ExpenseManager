import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/owl_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  final pages = const [
    (
      'Add expenses in seconds',
      'Track every rupee with quick, simple expense entry.',
      Icons.edit_note_rounded,
    ),
    (
      'Stay on top of budgets',
      'See your category limits and spending at a glance.',
      Icons.pie_chart_outline_rounded,
    ),
    (
      'Make confident choices',
      'Helpful offline insights make your money clearer.',
      Icons.auto_awesome_rounded,
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${step + 1}/3'),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Skip'),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OwlColors.navy,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(pages[step].$3, size: 76, color: OwlColors.gold),
                        const SizedBox(height: 18),
                        const Text('🦉', style: TextStyle(fontSize: 52)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    pages[step].$1,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pages[step].$2,
                    style: const TextStyle(color: OwlColors.muted),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    height: 6,
                    width: i == step ? 26 : 8,
                    decoration: BoxDecoration(
                      color: i == step ? OwlColors.navy : OwlColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: 130,
                  child: OwlButton(
                    label: step == 2 ? 'Start' : 'Next',
                    onPressed: () {
                      if (step == 2) {
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        setState(() => step++);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
