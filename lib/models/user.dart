import 'dart:io';

//import 'package:thefoodstory/models/post.dart';

class User {
  String id;
  String displayName;
  String email;
  String password;
  List<dynamic> savedPosts;
  List<dynamic> posts;
  String profilePicture;
  File pictureFile;
  List<dynamic> followers;
  List<dynamic> following;

  User();

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'followers': followers,
      'following': following,
      'posts': posts,
      'profilePicture': profilePicture,
      'savedPosts': savedPosts
    };
  }

  User.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    displayName = data['displayName'];
    profilePicture = data['ProfilePicture'];
    posts = data['posts'];
    savedPosts = data['savedPosts'];
    followers = data['followers'];
    following = data['following'];
  }
}
