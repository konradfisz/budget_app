import 'package:budgetapp/log_in_screen.dart';
import 'package:budgetapp/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BudgetApp());
}

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LogInScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
