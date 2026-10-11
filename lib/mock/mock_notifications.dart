import 'package:flutter/material.dart';

abstract final class MockNotifications {
  static const notices = <(String, String, String, IconData)>[
    ('Budget alert', 'Shopping budget is almost used.', '/budgets', Icons.warning_amber_rounded),
    ('Payment reminder', 'Your electricity bill is coming up.', '/recurring', Icons.receipt_long),
    ('Weekly summary', 'Review your weekly spending with Coach.', '/coach', Icons.auto_awesome),
  ];
}
