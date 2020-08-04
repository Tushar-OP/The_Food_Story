import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/models/post.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/screens/upload_profile_picture.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Post _post = Post();

  File image;

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    _post.user = authNotifier.user.uid;
    _post.email = authNotifier.user.email;
    _post.likes = [];

    createPost(_post, image, authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          'Create A Post',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _submitForm();
                },
                child: Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(38, 70, 38, 0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final File imageFile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadProfilePicture(),
                        ),
                      );
                      setState(() {
                        image = imageFile;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      height: size.height / 2,
                      child: (image != null)
                          ? ClipRRect(
                              child: Image.file(
                                image,
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )
                          : Center(
                              child: Icon(
                                Icons.photo,
                                size: 40.0,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    style: TextStyle(fontSize: 20),
                    cursorColor: Colors.white,
                    onSaved: (String description) {
                      _post.description = description;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
