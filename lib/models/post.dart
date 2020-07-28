import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:thefoodstory/models/user.dart';

class Post {
  String id;
  String imageUrl;
  String description;
  String email;
  String user;
  List<dynamic> likes;
  bool isLiked;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool isFollowed;

  //only locally used
  String userDp;
  String userName;

  Post.fromMap(Map<String, dynamic> data) {
    imageUrl = data['image'];
    description = data['description'];
    user = data['user'];
    likes = data['likes'];
    email = data['email'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
}
