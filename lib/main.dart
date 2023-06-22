import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/services/authService.dart';
import 'pages/homePage.dart';
import 'package:postspot_mobile_app/pages/postPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:postspot_mobile_app/pages/followeesPage.dart';
import 'package:postspot_mobile_app/pages/readPosts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => HomePage(),
      '/createPost': (context) => PostPage(),
      '/login': (context) => AuthService().handleAuthState(),
      '/follower': (context) => FolloweesPage(),
      '/readPosts': (context) => readPostsPage()
    },
    initialRoute: '/login',
  ));
}
