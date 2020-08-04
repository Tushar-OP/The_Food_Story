import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/api/api.dart';
import 'package:thefoodstory/components/post_tile.dart';
import 'package:thefoodstory/notifiers/post_notifier.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    PostNotifier postNotifier =
        Provider.of<PostNotifier>(context, listen: false);
    getSavedPosts(postNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostNotifier notifier = Provider.of<PostNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Saved Posts',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: (notifier.savedEmpty == true)
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
          : Column(
              children: <Widget>[
                Expanded(
                  child: (notifier.savedPostList.isEmpty)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PostTile(
                              post: notifier.savedPostList[index],
                            );
                          },
                          physics: ScrollPhysics(),
                          itemCount: notifier.savedPostList.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 40.0);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
