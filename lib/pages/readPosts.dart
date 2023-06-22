import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/widgets/createPost.dart';
import 'package:postspot_mobile_app/data/user.dart' as us;

class readPostsPage extends StatefulWidget {
  const readPostsPage({super.key});

  @override
  State<readPostsPage> createState() => _readPostsPageState();
}

class _readPostsPageState extends State<readPostsPage> {
  List<us.User> users = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print(arguments.toString());

    List argfollowees = arguments['followees'];
    print("TESTTTTTTT");
    print(argfollowees.length);
    print(argfollowees[0].name);

    for (var i = 0; i < argfollowees.length; i++) {
      users.add(us.User(argfollowees[i].google_id, argfollowees[i].name));
    }


    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
              Icon(Icons.edit_location_alt_outlined),
              Text('Followees',
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )),
            ]),
            backgroundColor: Color.fromARGB(255, 64, 100, 133),
            actions: <Widget>[
              
            ]),
        body: //Column(children: [
          //Container(margin: EdgeInsets.all(30),
            //child: Row(mainAxisAlignment: MainAxisAlignment.center,
            //children: [Text("Followees", style: TextStyle(color: Color.fromARGB(255, 64, 100, 133), fontSize: 40, fontWeight: FontWeight.bold))])),
          ListView.builder(
          itemCount: argfollowees.length,
          
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(argfollowees[index].name,
              style: TextStyle(
                
                color: Color.fromARGB(255, 64, 100, 133), fontSize: 20


              )
              ),
              trailing: ElevatedButton(
              onPressed: () {
                // Obsługa naciśnięcia przycisku
                
              },
              child: Text('read posts'),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 64, 100, 133))),
              
            ));
          },
        ),);

        //],)
        
        //);
  }
}
