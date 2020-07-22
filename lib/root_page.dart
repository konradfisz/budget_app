import 'package:budgetapp/blocs/user_bloc_provider.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/ui/log_in/log_in_sign_up.dart';
import 'package:budgetapp/ui/main/main_screen.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  LoginSignupBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginSignupBlocProvider.of(context);
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.isSignedIn,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data) {
            return LoginSignupBlocProvider(
              child: UserBlocProvider(
                child: new MainScreen(),
              ),
            );
          } else {
            return LoginSignupBlocProvider(
              child: UserBlocProvider(
                child: LoginSignupPage(),
              ),
            );
          }
        } else
          return buildWaitingScreen();
      },
    );
  }
}
