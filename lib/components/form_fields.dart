import 'package:flutter/material.dart';
import 'package:thefoodstory/models/user.dart';

Widget buildDisplayNameField({@required User user}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: "Display Name",
    ),
    keyboardType: TextInputType.text,
    style: TextStyle(fontSize: 20),
    cursorColor: Colors.white,
    validator: (String value) {
      if (value.isEmpty) {
        return 'Display Name is required';
      }

      if (value.length < 5 || value.length > 12) {
        return 'Display Name must be betweem 5 and 12 characters';
      }

      return null;
    },
    onSaved: (String value) {
      user.displayName = value;
    },
  );
}

Widget buildEmailField({@required User user}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: "Email",
    ),
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(fontSize: 20),
    cursorColor: Colors.white,
    validator: (String value) {
      if (value.isEmpty) {
        return 'Email is required';
      }

      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Please enter a valid email address';
      }

      return null;
    },
    onSaved: (String value) {
      user.email = value;
    },
  );
}

Widget buildPasswordField(
    {@required User user, @required TextEditingController controller}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: "Password",
    ),
    style: TextStyle(fontSize: 20),
    cursorColor: Colors.white,
    obscureText: true,
    controller: controller,
    validator: (String value) {
      if (value.isEmpty) {
        return 'Password is required';
      }

      if (value.length < 5 || value.length > 20) {
        return 'Password must be between 5 and 20 characters';
      }

      return null;
    },
    onSaved: (String value) {
      user.password = value;
    },
  );
}

Widget buildConfirmPasswordField({@required TextEditingController controller}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: "Confirm Password",
    ),
    style: TextStyle(fontSize: 20),
    cursorColor: Colors.white,
    obscureText: true,
    validator: (String value) {
      if (controller.text != value) {
        return 'Passwords do not match';
      }

      return null;
    },
  );
}

Widget buildForgotPassword({@required User user}) {
  return GestureDetector(
    onTap: () {},
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Forgot Password',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.green,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget buildSignUpLink({@required Function onPressed}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        'New to Food Story?',
        style: TextStyle(),
      ),
      GestureDetector(
        onTap: onPressed,
        child: Text(
          'Register!',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.green,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}
