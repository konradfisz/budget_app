import 'package:budgetapp/blocs/babies_bloc.dart';
import 'package:flutter/material.dart';

class BabiesBlocProvider extends InheritedWidget {
  final bloc = BabiesBloc();

  BabiesBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BabiesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BabiesBlocProvider)
            as BabiesBlocProvider)
        .bloc;
  }
}
