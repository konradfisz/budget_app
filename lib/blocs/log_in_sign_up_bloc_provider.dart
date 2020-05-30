import 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';
import 'package:flutter/material.dart';
export 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';

class LoginSignupBlocProvider extends InheritedWidget {
  final bloc = LoginSignupBloc();

  LoginSignupBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginSignupBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginSignupBlocProvider)
            as LoginSignupBlocProvider)
        .bloc;
  }
}
