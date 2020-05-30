import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/ui/log_in/widget_flipper.dart';
import 'package:budgetapp/clients/auth_client.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();
  LoginSignupBloc _bloc;

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

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  // void validateAndSubmit() async {
  //   setState(() {
  //     _errorMessage = "";
  //     _isLoading = true;
  //   });
  //   if (validateAndSave()) {
  //     String userId = "";
  //     try {
  //       if (_isLoginForm) {
  //         userId = await widget.auth.signIn(_email, _password);
  //         print('Signed in: $userId');
  //       } else {
  //         userId = await widget.auth.signUp(_email, _password);
  //         //widget.auth.sendEmailVerification();
  //         //_showVerifyEmailSentDialog();
  //         print('Signed up user: $userId');
  //       }
  //       setState(() {
  //         _isLoading = false;
  //       });

  //       if (userId.length > 0 && userId != null && _isLoginForm) {
  //         widget.loginCallback();
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = e.message;
  //         _formKey.currentState.reset();
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.welcomeMessage),
      ),
      body: StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return _showForm();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              emailField(),
              passwordField(),
              showPrimaryButton(),
              showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget showLogo() {
    return Container(
      height: 100,
      width: 100,
      child: new WidgetFlipper(
        frontWidget:
            CircleAvatar(child: Image.asset("assets/launcher/icon.png")),
        backWidget: CircleAvatar(),
      ),
    );
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              onChanged: _bloc.changeEmail,
              decoration: new InputDecoration(
                hintText: Strings.emailHint,
                icon: new Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                errorText: snapshot.error,
              ),
              onSaved: (value) => _email = value.trim(),
            ),
          );
        });
  }

  Widget passwordField() {
    return StreamBuilder(
      stream: _bloc.password,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            onChanged: _bloc.changePassword,
            decoration: InputDecoration(
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              hintText: Strings.passwordHint,
              errorText: snapshot.error,
            ),
            onSaved: (value) => _password = value.trim(),
          ),
        );
      },
    );
  }

  //   Widget submitButton() {
  //   return
  // }

  // Widget button() {
  //   return RaisedButton(
  //       child: Text(StringConstant.submit),
  //       textColor: Colors.white,
  //       color: Colors.black,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: new BorderRadius.circular(30.0)),
  //       onPressed: () {
  //         if (_bloc.validateFields()) {
  //           authenticateUser();
  //         } else {
  //           showErrorMessage();
  //         }
  //       });
  // }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              if (_bloc.validateFields()) {
                authenticateUser();
              } else {
                showErrorMessage();
              }
            },
          ),
        ));
  }

  void showErrorMessage() {
    final snackbar = SnackBar(
        content: Text(Strings.errorMessage),
        duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    if (_isLoginForm) {
      _bloc.singIn().then((userId) => print('Signed in: $userId'));
    } else {
      _bloc.signUp().then((userId) => print('Signed up: $userId'));
      //widget.auth.sendEmailVerification();
      //_showVerifyEmailSentDialog();
    }
  }
}
