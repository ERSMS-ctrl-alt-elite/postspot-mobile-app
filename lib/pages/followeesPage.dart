import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/widgets/createPost.dart';
import 'package:postspot_mobile_app/widgets/followeesList.dart';

class FolloweesPage extends StatefulWidget {
  const FolloweesPage({super.key});

  @override
  State<FolloweesPage> createState() => _FolloweesPageState();
}

class _FolloweesPageState extends State<FolloweesPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{});
    print(arguments.toString());

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
