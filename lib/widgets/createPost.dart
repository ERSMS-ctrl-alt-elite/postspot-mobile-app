import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/services/postRestClient.dart';
import 'package:uuid/uuid.dart';
import 'package:postspot_mobile_app/data/post.dart';
import 'package:location/location.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  var uuid = Uuid();

  Future<bool> createPost() async {
    print("START createPost");
    Location location = Location();
    var myLocation = await location.getLocation();
    print("CREATE POST - my locations: " + myLocation.latitude.toString());
    if (myLocation.longitude == null && myLocation.latitude == null) {
      return false;
    }
    Post post = Post('', '', titleController.text, messageController.text, myLocation.longitude!, myLocation.latitude!);
    var res = await PostRestService().createPost(post);
    print(res.statusCode);
    print(res.reasonPhrase);
    print(res.body);
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
              child: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: titleController,
                    autocorrect: true,
                    autofocus: true,
                    maxLength: 20,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ))),
          Center(
              child: SizedBox(
                  width: 250,
                  height: 100,
                  child: TextField(
                    controller: messageController,
                    autocorrect: true,
                    autofocus: true,
                    maxLength: 200,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 64, 100, 133))),
                      labelText: 'Message',
                    ),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Sending post ...')),
                  );

                  String messageId = uuid.v4();

                  print("PRE-START createPost");
                  var created = await createPost();
                  if (created) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Successfully added post')),
                    );
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Failed to create post')),
                    );
                  }

                  Navigator.pop(context, {
                    'messageId': messageId,
                    'title': titleController.text,
                    'message': messageController.text
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 64, 100, 133)),
              ),
              child: const Text('Leave Post'),
            )),
          ),
        ],
      ),
    );
  }
}
