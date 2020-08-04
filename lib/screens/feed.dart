//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/components/post_tile.dart';
import 'package:thefoodstory/notifiers/post_notifier.dart';
import 'package:thefoodstory/screens/create_post.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    PostNotifier postNotifier =
        Provider.of<PostNotifier>(context, listen: false);
    getGlobalPosts(postNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostNotifier notifier = Provider.of<PostNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'The Food Story',
          style: GoogleFonts.notable(
            textStyle: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: (notifier.globalEmpty == true)
          ? Center(
              child: Text(
                'There seems to be nothing here!',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : (notifier.globalPostList.isEmpty)
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: (notifier.globalPostList.isEmpty)
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return PostTile(
                                  post: notifier.globalPostList[index],
                                );
                              },
                              physics: ScrollPhysics(),
                              itemCount: notifier.globalPostList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 40.0);
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePost(),
            ),
          );
        },
      ),
    );
  }
}
