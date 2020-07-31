import 'package:budgetapp/blocs/main_screen_bloc.dart';
import 'package:budgetapp/blocs/main_screen_bloc_provider.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/data/result.dart';
import 'package:budgetapp/ui/log_in/log_in_sign_up.dart';
import 'package:budgetapp/ui/main/main_header.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseUser _user;
  LoginSignupBloc _loginSignUpBloc;
  MainScreenBloc _mainScreenBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainScreenBloc = MainScreenBlocProvider.of(context);
    _loginSignUpBloc = LoginSignupBlocProvider.of(context);
    _loginSignUpBloc.getCurrentUser().then((value) => _user = value);
    _loginSignUpBloc.isEmailVerified.listen((event) async {
      if (!event) {
        _showVerifyEmailSentDialog(_user);
      }
    });
  }

  @override
  void dispose() {
    _loginSignUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          extendBodyBehindAppBar: true,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(title: Text(Strings.logout), onTap: signOut),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              MyHeader(
                textTop: Strings.headerTopText,
                textBottom: Strings.headerBottomText,
                offset: 10,
              ),
              StreamBuilder<String>(
                  stream: _loginSignUpBloc.getCurrentUserId(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildBody(
                      context,
                      snapshot.data,
                      _mainScreenBloc,
                    );
                  }),
              FlatButton(
                onPressed: () {
                  _mainScreenBloc.addResult(_user.uid);
                },
                child: Text("Dodaj wynik"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, String userId, MainScreenBloc userBloc) {
    return StreamBuilder<QuerySnapshot>(
      stream: userBloc.userResults(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents, userId, userBloc);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      String userId, MainScreenBloc userBloc) {
    List<Result> sortedList =
        snapshot.map((e) => Result.fromSnapshot(e)).toList();
    sortedList.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return Expanded(
      child: ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: sortedList
              .map(
                  (result) => _buildListItem(context, result, userId, userBloc))
              .toList()),
    );
  }

  Widget _buildListItem(BuildContext context, Result result, String userId,
      MainScreenBloc userBloc) {
    print(result.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(result.category.documentID),
            trailing: Text(DateFormat().format(result.expenseDate.toDate())),
            onTap: () => userBloc.deleteResult(userId, result.id)),
      ),
    );
  }

  signOut() async {
    try {
      _loginSignUpBloc.signOut().then((_) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginSignupBlocProvider(
                    child: MainScreenBlocProvider(child: LoginSignupPage())),
              ),
            )
          });
    } catch (e) {
      print(e);
    }
  }

  void _showVerifyEmailSentDialog(FirebaseUser user) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Send again"),
              onPressed: () {
                user.sendEmailVerification();
              },
            ),
            new FlatButton(
              child: new Text("Log again"),
              onPressed: () {
                signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
