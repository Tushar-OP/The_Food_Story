import 'package:flutter/cupertino.dart';
import 'package:thefoodstory/models/post.dart';

class PostNotifier with ChangeNotifier {
  List<Post> _globalPostList = [];

  // Used to save the favourite posts of the user
  List<Post> _savedPostList = [];

  // Used to save the current user's own posts
  List<Post> _ownPostList = [];

  Post _currentPost;

  List<Post> get globalPostList => _globalPostList;

  set globalPostList(List<Post> postList) {
    _globalPostList = postList;
    notifyListeners();
  }

  List<Post> get savedPostList => _savedPostList;

  set savedPostList(List<Post> postList) {
    _savedPostList = postList;
    notifyListeners();
  }

  List<Post> get ownPostList => _ownPostList;

  set ownPostList(List<Post> postList) {
    _ownPostList = postList;
    notifyListeners();
  }

  Post get currentPost => _currentPost;

  set currentPost(Post post) {
    _currentPost = post;
    notifyListeners();
  }

  bool _savedEmpty = false;

  bool get savedEmpty => _savedEmpty;

  set savedEmpty(bool savedEmpty) {
    _savedEmpty = savedEmpty;
    notifyListeners();
  }

  bool _globalEmpty = false;

  bool get globalEmpty => _globalEmpty;

  set globalEmpty(bool globalEmpty) {
    _globalEmpty = globalEmpty;
    notifyListeners();
  }

  bool _ownEmpty = false;

  bool get ownEmpty => _ownEmpty;

  set ownEmpty(bool ownEmpty) {
    _ownEmpty = ownEmpty;
    notifyListeners();
  }
}
