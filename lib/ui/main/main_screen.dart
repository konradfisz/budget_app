import 'package:budgetapp/blocs/log_in_sign_up_bloc.dart';
import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/data/baby.dart';
import 'package:budgetapp/ui/log_in/log_in_sign_up.dart';
import 'package:budgetapp/ui/main/main_header.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  signOut() async {
    try {
      _bloc.signOut().then((_) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LoginSignupBlocProvider(child: LoginSignupPage()),
              ),
            )
          });
    } catch (e) {
      print(e);
    }
  }

  LoginSignupBloc _bloc;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _bloc.isEmailVerified.listen((event) async {
  //     if (!event) {
  //       _showVerifyEmailSentDialog();
  //     }
  //   });
  // }

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Verify your account"),
  //         content:
  //             new Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Send again"),
  //             onPressed: () {
  //               _bloc.sendEmailVerification();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text("Dismiss"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginSignupBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
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
          body: MyHeader(
            textTop: Strings.headerTopText,
            textBottom: Strings.headerBottomText,
            offset: -20,
          ),
        ),
      ],
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('baby').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Baby.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.name),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(record.name),
        trailing: Text(record.votes.toString()),
        onTap: () => print(record),
      ),
    ),
  );
}
