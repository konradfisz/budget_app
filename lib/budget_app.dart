import 'dart:core';
import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/clients/auth_client.dart';
import 'package:budgetapp/root_page.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:flutter/material.dart';

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginSignupBlocProvider(
        child: new RootPage(
          auth: new FirebaseAuthClient(),
        ),
      ),
    );
  }
}
