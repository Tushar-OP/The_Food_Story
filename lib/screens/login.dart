import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/components/form_fields.dart';
import 'package:thefoodstory/models/user.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/screens/signup.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    login(_user, authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(38, 96, 38, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hello\nThere.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  buildEmailField(user: _user),
                  buildPasswordField(
                      user: _user, controller: _passwordController),
                  SizedBox(height: 10),
                  buildForgotPassword(user: _user),
                  SizedBox(height: 32),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.all(10.0),
                      onPressed: () => _submitForm(),
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      onPressed: () => _submitForm(),
                      child: Text(
                        'Login With Guugle',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: buildSignUpLink(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          ),
        ),
      ),
    );
  }
}
