import 'package:budgetapp/blocs/babies_bloc.dart';
import 'package:budgetapp/blocs/babies_bloc_provider.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/data/baby.dart';
import 'package:budgetapp/data/result.dart';
import 'package:budgetapp/ui/log_in/log_in_sign_up.dart';
import 'package:budgetapp/ui/main/main_header.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseUser _user;
  LoginSignupBloc _loginSignUpBloc;
  BabiesBloc _babiesBloc;

  signOut() async {
    try {
      _loginSignUpBloc.signOut().then((_) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginSignupBlocProvider(
                    child: BabiesBlocProvider(child: LoginSignupPage())),
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

  // @override
  // void @override
  // void initState() {
  //   super.initState();

  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _babiesBloc = BabiesBlocProvider.of(context);
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
    _babiesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.transparent,
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
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
                offset: -20,
              ),
              StreamBuilder<String>(
                  stream: _loginSignUpBloc.getCurrentUserId(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildBody(context, _babiesBloc, snapshot.data);
                  }),
              FlatButton(
                onPressed: () {
                  _babiesBloc.addResult(_user.uid);
                },
                child: Text("Dodaj wynik"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildBody(BuildContext context, BabiesBloc babiesBloc, String userId) {
  return StreamBuilder<QuerySnapshot>(
    stream: babiesBloc.userResults(userId),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return Expanded(
    child: ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    ),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Result.fromSnapshot(data);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(record.id.toString()),
        trailing: Text(record.score.toString()),
        onTap: () => print(record),
      ),
    ),
  );
}
