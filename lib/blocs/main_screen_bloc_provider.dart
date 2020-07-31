import 'package:budgetapp/blocs/main_screen_bloc.dart';
import 'package:flutter/material.dart';

class MainScreenBlocProvider extends InheritedWidget {
  final bloc = MainScreenBloc();

  MainScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static MainScreenBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MainScreenBlocProvider)
            as MainScreenBlocProvider)
        .bloc;
  }
}
