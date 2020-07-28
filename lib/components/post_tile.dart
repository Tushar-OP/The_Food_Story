import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/models/post.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:transparent_image/transparent_image.dart';

class PostTile extends StatefulWidget {
  final String imgSrc;
  final String userName;
  final String userDp;
  final Post post;

  PostTile(
      {@required this.userName,
      @required this.userDp,
      @required this.imgSrc,
      @required this.post});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  Future<bool> addToFav(bool isLiked) async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await Firestore.instance
        .collection('Users')
        .document(authNotifier.user.uid)
        .updateData({
      'savedPosts': FieldValue.arrayUnion([widget.post.id])
    }).whenComplete(() => isLiked = !isLiked);

    return isLiked;
  }

  Future<bool> addToLikes(bool isLiked) async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await Firestore.instance
        .collection('Posts')
        .document(widget.post.id)
        .updateData({
      'likes': FieldValue.arrayUnion([authNotifier.user.uid])
    }).whenComplete(() => isLiked = !isLiked);

    return isLiked;
  }

  addToFollowers() async {
    bool liked = false;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await Firestore.instance
        .collection('Users')
        .document(widget.post.user)
        .updateData({
          'followers': FieldValue.arrayUnion([authNotifier.user.uid])
        })
        .catchError((e) => print(e))
        .whenComplete(
            () => getUserDetails(authNotifier.user.uid, authNotifier));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    bool isFollowed = false;
    bool liked = false;

    return Container(
      height: size.height * 0.7,
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: (widget.userDp != null)
                      ? NetworkImage(widget.userDp)
                      : NetworkImage(
                          "https://cdn0.iconfinder.com/data/icons/users-android-l-lollipop-icon-pack/24/user-128.png"),
                  radius: 16.0,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(widget.userName),
                ),
                Expanded(
                  child: Container(),
                ),
                (widget.post.isFollowed == true)
                    ? Container()
                    : RaisedButton(
                        child: Text(
                          'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          addToFollowers();
                        },
                      )
              ],
            ),
          ),
          Container(
            height: size.height * 0.5,
            child: Stack(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
                FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  image: widget.imgSrc,
                  width: size.width,
                  height: size.height * 0.5,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                (widget.post.isLiked == true)
                    ? LikeButton(
                        isLiked: true,
                      )
                    : LikeButton(
                        onTap: addToLikes,
                      ),
                SizedBox(width: 10),
                (widget.post.likes.length > 0)
                    ? Text(
                        '${widget.post.likes.length}',
                      )
                    : Container(),
                Expanded(child: Container()),
                (authNotifier.userDetails.savedPosts != null &&
                        authNotifier.userDetails.savedPosts
                                .contains(widget.post.id) ==
                            true)
                    ? LikeButton(likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.bookmark,
                          color:
                              isLiked ? Colors.grey : Colors.deepPurpleAccent,
                          size: 30,
                        );
                      })
                    : LikeButton(
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.bookmark,
                            color:
                                isLiked ? Colors.deepPurpleAccent : Colors.grey,
                            size: 30,
                          );
                        },
                        onTap: addToFav,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//
//await Firestore.instance
//    .collection('Users')
//.document(authNotifier.user.uid)
//.updateData({'savedPosts': FieldValue.arrayUnion([widget.postID])})
//.whenComplete(() => result = true);
