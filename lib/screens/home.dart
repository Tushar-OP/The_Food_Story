import 'package:flutter/material.dart';
import 'package:thefoodstory/screens/account_info.dart';
import 'package:thefoodstory/screens/favourites.dart';
import 'package:thefoodstory/screens/feed.dart';
import 'package:thefoodstory/screens/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = [
    Feed(),
    Search(),
    Favourites(),
    AccountInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(children: pages),
        bottomNavigationBar: Container(
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.favorite_border)),
              Tab(icon: Icon(Icons.account_circle)),
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.blue,
            indicatorColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
