import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'package:postspot_mobile_app/pages/postPage.dart';

void main() => runApp(MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/createPost': (context) => PostPage()
      },
    ));
