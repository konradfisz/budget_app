import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:budgetapp/clients/auth_helpers/auth-exception-handler.dart';
import 'package:budgetapp/clients/auth_helpers/auth-result-status.dart';
import 'package:budgetapp/ui/log_in/widget_flipper.dart';
import 'package:budgetapp/ui/main/main_screen.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage();

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  void initState() {
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
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
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(Strings.welcomeMessage),
        ),
        body: _showForm());
  }

  void _showVerifyEmailSentDialog() {
    if (!_isLoginForm) {
      toggleFormMode();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
          ),
        );
      },
    );
  }

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
                showErrorMessage(Strings.errorMessage);
              }
            },
          ),
        ));
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Enter again',
        onPressed: () {
          resetForm();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void authenticateUser() {
    if (_isLoginForm) {
      _bloc.signIn().then(
            (status) => status == AuthResultStatus.successful
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginSignupBlocProvider(
                        child: MainScreen(),
                      ),
                    ),
                  )
                : showErrorMessage(
                    AuthExceptionHandler.generateExceptionMessage(status)),
          );
    } else {
      _bloc.signUp().then(
            (status) => status == AuthResultStatus.successful
                ? _showVerifyEmailSentDialog()
                : showErrorMessage(
                    AuthExceptionHandler.generateExceptionMessage(status)),
          );
    }
  }

  Future navigateToMain() async {
    _bloc.isEmailVerified.listen((event) async {
      if (event) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginSignupBlocProvider(
              child: MainScreen(),
            ),
          ),
        );
      } else {
        _showVerifyEmailSentDialog();
        signOut();
      }
    });
  }

  signOut() async {
    try {
      _bloc.signOut();
      resetForm();
    } catch (e) {
      print(e);
    }
  }
}
