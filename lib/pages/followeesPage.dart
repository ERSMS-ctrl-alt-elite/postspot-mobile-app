import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/widgets/createPost.dart';
import 'package:postspot_mobile_app/widgets/followeesList.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
              Icon(Icons.edit_location_alt_outlined),
              Text('PostSpot',
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )),
            ]),
            backgroundColor: Color.fromARGB(255, 64, 100, 133),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.account_circle_sharp),
                color: Colors.white,
                iconSize: 40.0,
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              )
            ]),
        body: const FolloweesList());
  }
}
