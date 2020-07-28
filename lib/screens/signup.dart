import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/components/form_fields.dart';
import 'package:thefoodstory/models/user.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/screens/upload_profile_picture.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  User _user = User();

  File image;

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    signup(_user, authNotifier);
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final File imageFile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadProfilePicture(),
            ),
          );
          setState(() {
            image = imageFile;
            _user.pictureFile = imageFile;
          });
        },
        child: CircleAvatar(
            radius: 51,
            backgroundColor: Colors.grey,
            child: (image != null)
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: FileImage(image),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.grey,
                    ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(height: size.height),
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
                    "Register.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildImagePicker(),
                  buildDisplayNameField(user: _user),
                  buildEmailField(user: _user),
                  buildPasswordField(
                      user: _user, controller: _passwordController),
                  buildConfirmPasswordField(controller: _passwordController),
                  SizedBox(height: 20),
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
                        'Register',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Go Back',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
