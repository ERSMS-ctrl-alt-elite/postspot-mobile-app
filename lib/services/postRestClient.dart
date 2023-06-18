import '../data/post.dart';
import 'package:http/http.dart' as http;

class PostRestService {
  Post post;
  var url = Uri.https('/post');
  var client = http.Client();

  PostRestService(this.post);

  Future<void> sendRequest() async {
    final jsonData = post.toJson();
    try {
      var response = await client.post(url, body: jsonData);
    } finally {
      client.close();
    }
  }
}
