import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:thefoodstory/models/post.dart';
import 'package:thefoodstory/models/user.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/notifiers/post_notifier.dart';

//AUTHENTICATION RELATED FUNCTIONS

login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((e) => print(e));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      authNotifier.setFirebaseUser(firebaseUser);

      getUserDetails(firebaseUser.uid, authNotifier);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((e) => print(e));

  String userImage;

  //Upload the Profile Picture to firebase storage
  userImage = await uploadToStorage(user.pictureFile);

  //Continue with the user creation
  if (authResult != null) {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = user.displayName;
    userUpdateInfo.photoUrl = userImage;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(userUpdateInfo);

      await firebaseUser.reload();

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setFirebaseUser(currentUser);

      //Upload the user to collection
      user.profilePicture = userImage;
      _createUser(user, currentUser, authNotifier);
    }
  }
}

Future<String> uploadToStorage(File file) async {
  String url;

  if (file != null) {
    final FirebaseStorage firebaseStorage =
    FirebaseStorage(storageBucket: 'gs://thefoodstory-558bb.appspot.com');

    String filePath = 'images/${randomAlphaNumeric(10)}.png';

    StorageReference ref = firebaseStorage.ref().child(filePath);

    try {
      StorageUploadTask uploadTask = ref.putFile(file);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      url = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    return url;
  } else {
    print('PictureFile not found');
  }
  return null;
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((e) => print(e));
  authNotifier.setFirebaseUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser =
  await FirebaseAuth.instance.currentUser().catchError((e) => print(e));

  if (firebaseUser != null) {
    authNotifier.setFirebaseUser(firebaseUser);

    getUserDetails(firebaseUser.uid, authNotifier);
  }
}

//DATABASE RELATED FUNCTIONS

//To upload the user info to the collection on firebase
_createUser(User user, FirebaseUser firebaseUser, AuthNotifier authNotifier) async {
  var userRef = await Firestore.instance
      .collection('Users')
      .document(firebaseUser.uid)
      .setData(user.toMap());

  user.id = firebaseUser.uid;

  authNotifier.setUser(user);

  print('user uploaded ${user.toString()}');
}

createPost(Post post, File file, AuthNotifier authNotifier) async {
  String image = await uploadToStorage(file);

  post.imageUrl = image;

  post.createdAt = Timestamp.now();

  DocumentReference ref = Firestore.instance.collection('Posts').document();

  ref.setData(post.toMap()).catchError((e) => print(e)).whenComplete(() async =>
  await Firestore.instance
      .collection('Users')
      .document(authNotifier.user.uid)
      .updateData({
    'posts': FieldValue.arrayUnion([ref.documentID])
  }));
}

// Use this to get the details of the user from the database
getUserDetails(String userID, AuthNotifier authNotifier) async {
//  print(userID);
  DocumentSnapshot snapshot =
  await Firestore.instance.collection('Users').document(userID).get();

  if (snapshot != null) {
    User user = User.fromMap(snapshot.data);

    authNotifier.setUser(user);
  }
}

// To get the global Posts
getGlobalPosts(PostNotifier postNotifier) async {
  FirebaseUser firebaseUser =
  await FirebaseAuth.instance.currentUser().catchError((e) => print(e));

  QuerySnapshot snapshot =
  await Firestore.instance.collection('Posts').getDocuments();

  List<Post> _postList = [];

  await Future.forEach(snapshot.documents, (document) async {
    if (firebaseUser.email != document.data["email"]) {
      // Get the Basic Details about the post
      Post post = Post.fromMap(document.data);

      // Get the post id for future reference
      post.id = document.documentID;

      // Check if the current user has liked this post, if so update the isLiked argument
      if (document.data['likes'] != null &&
          document.data['likes'].contains(firebaseUser.uid)) {
        post.isLiked = true;
      } else {
        post.isLiked = false;
      }

      // Use this to get post author i.e user details
      await Firestore.instance
          .collection('Users')
          .document(document.data['user'])
          .get()
          .then((value) {
        // Use this to get basic details of the user
        post.userName = value.data['displayName'];
        post.userDp = value.data['profilePicture'];

        // Use this to check if the current logged in user has followed this post's author/user
        if (value.data['followers'] != null &&
            value.data['followers'].contains(firebaseUser.uid)) {
          post.isFollowed = true;
        } else {
          post.isFollowed = false;
        }
      }).whenComplete(() => _postList.add(post));
    }
  });

  if (_postList.isEmpty) {
    postNotifier.globalEmpty = true;
  } else {
    postNotifier.globalEmpty = false;
    postNotifier.globalPostList = _postList;
  }
}

//Used to get user's posts
getOwnPosts(PostNotifier postNotifier, AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser =
  await FirebaseAuth.instance.currentUser().catchError((e) => print(e));

  QuerySnapshot snapshot = await Firestore.instance
      .collection('Posts')
      .where('user', isEqualTo: firebaseUser.uid)
      .getDocuments();

  List<Post> _postList = [];

  await Future.forEach(snapshot.documents, (document) async {
//    if (firebaseUser.email != document.data["email"]) {
//      Post post = Post.fromMap(document.data);
////       Use this to get user
//      await Firestore.instance
//          .collection('Users')
//          .document(document.data['user'])
//          .get()
//          .then((value) {
//        post.userName = value.data['displayName'];
//        post.userDp = value.data['profilePicture'];
//        print(value.data['displayName']);
//      }).whenComplete(() => _postList.add(post));
//    }
    Post post = Post.fromMap(document.data);
    post.userName = authNotifier.userDetails.displayName;
    post.userDp = authNotifier.userDetails.profilePicture;

    _postList.add(post);
  });

  if (_postList.isEmpty) {
    postNotifier.ownEmpty = true;
  } else {
    postNotifier.ownEmpty = false;
    postNotifier.ownPostList = _postList;
  }
}

//Used to get the Saved Posts of the user.
getSavedPosts(PostNotifier postNotifier) async {
  FirebaseUser firebaseUser =
  await FirebaseAuth.instance.currentUser().catchError((e) => print(e));

  DocumentSnapshot snapshot = await Firestore.instance
      .collection('Users')
      .document(firebaseUser.uid)
      .get();

  postNotifier.globalPostList = [];
  List<Post> _postList = [];

  await Future.forEach(snapshot.data['savedPosts'], (document) async {
    Post post;
    //Use this to get user
    await Firestore.instance
        .collection('Posts')
        .document(document)
        .get()
        .then((value) async {
      post = Post.fromMap(value.data);
      await Firestore.instance
          .collection('Users')
          .document(value.data['user'])
          .get()
          .then((value) {
        post.userName = value.data['displayName'];
        post.userDp = value.data['profilePicture'];
      }).whenComplete(() => _postList.add(post));
    });
  });

  if (_postList.isEmpty) {
    postNotifier.savedEmpty = true;
  } else {
    postNotifier.savedEmpty = false;
    postNotifier.savedPostList = _postList;
  }
}
