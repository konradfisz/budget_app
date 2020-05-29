import 'package:budgetapp/root_page.dart';
import 'package:budgetapp/clients/auth_client.dart';
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
      home: new RootPage(
        auth: new FirebaseAuthClient(),
      ),
    );
  }
}
