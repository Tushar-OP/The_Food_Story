import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefoodstory/notifiers/auth_notifier.dart';
import 'package:thefoodstory/notifiers/post_notifier.dart';
import 'package:thefoodstory/screens/home.dart';
import 'package:thefoodstory/screens/login.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => PostNotifier(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Home() : Login();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

