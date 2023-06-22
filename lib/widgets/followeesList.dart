import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/services/postRestClient.dart';
import 'package:uuid/uuid.dart';
import 'package:postspot_mobile_app/data/post.dart';
import 'package:location/location.dart';
import 'package:postspot_mobile_app/data/user.dart' as us;
import 'package:postspot_mobile_app/services/userRestClient.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FolloweesList extends StatefulWidget {
  const FolloweesList({super.key});

  @override
  State<FolloweesList> createState() => _FolloweesListState();
}

class _FolloweesListState extends State<FolloweesList> {
  final List<us.User> followees = List.empty(growable: true);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{});
    //followees = List;

    return Text("hello");
  }
}
