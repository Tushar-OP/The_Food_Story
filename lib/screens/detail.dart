import 'package:flutter/material.dart';
import 'package:thefoodstory/components/post_tile.dart';
import 'package:thefoodstory/models/post.dart';

class Detail extends StatefulWidget {
  final Post post;

  Detail({@required this.post});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        body: PostTile(
          post: widget.post,
        ),
      ),
    );
  }
}
