import 'package:budgetapp/blocs/user_bloc.dart';
import 'package:flutter/material.dart';

class UserBlocProvider extends InheritedWidget {
  final bloc = UserBloc();

  UserBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UserBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UserBlocProvider)
            as UserBlocProvider)
        .bloc;
  }
}
