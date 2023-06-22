import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/services/authService.dart';
import 'pages/homePage.dart';
import 'package:postspot_mobile_app/pages/postPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => HomePage(),
      '/createPost': (context) => PostPage(),
      '/login': (context) => AuthService().handleAuthState(),
    },
    initialRoute: '/login',
  ));
}
