import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/finance_store.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => FinanceStore(),
    child: const OwlanceApp(),
  ),
);
