//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/notifiers/post_notifier.dart';
import 'package:thefoodstory/screens/detail.dart';
import 'package:transparent_image/transparent_image.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);

    PostNotifier postNotifier =
        Provider.of<PostNotifier>(context, listen: false);
    getOwnPosts(postNotifier, authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    final int followersCount = (authNotifier.userDetails.followers == null)
        ? 0
        : authNotifier.userDetails.followers.length;

    final int followingCount = (authNotifier.userDetails.following == null)
        ? 0
        : authNotifier.userDetails.following.length;

    final int postsCount = (authNotifier.userDetails.posts == null)
        ? 0
        : authNotifier.userDetails.posts.length;

    PostNotifier postNotifier = Provider.of<PostNotifier>(context);

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            authNotifier.user.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.exit_to_app,
                size: 18,
              ),
              onPressed: () {
                signout(authNotifier);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35.0,
                    child: ClipOval(
                      child: (authNotifier.user.photoUrl != null)
                          ? FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: authNotifier.user.photoUrl,
                        width: size.width,
                        height: size.height * 0.5,
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  '$postsCount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text('Posts'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$followersCount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text('Followers'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$followingCount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text('Following'),
                              ],
                            ),
                          ],
                        ),
                        ButtonTheme(
                          buttonColor: Colors.grey[300],
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse semper, tortor vitae tincidunt laoreet, mauris risus dapibus turpis, ac bibendum diam arcu nec libero. Suspendisse non mauris'),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Center(
              child: Text(
                'Posts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 10),
            (postNotifier.ownEmpty == true)
                ? Expanded(
                    child: Center(
                      child: Text(
                        'There seems to be nothing here!',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                      ),
                      itemCount: postNotifier.ownPostList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Detail(
                                      post: postNotifier.ownPostList[index],
                                    ),
                              ),
                            );
                          },
                          child: Image.network(
                            postNotifier.ownPostList[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
