import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import '../data/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostRestService {
  var token;
  var client = http.Client();

  var hostName = "postspot-api-gateway-eu-dev-a5mqnrt6.nw.gateway.dev";
  var endpoint = "/v1/posts";
  Map<String, String> getQueryParameters = {};

  PostRestService() {
    token = FirebaseAuth.instance.currentUser!.refreshToken;
  }

  Future<http.Response> createPost(Post post) async {
    final jsonData = post.toJson();
    try {
      return await client.post(Uri.https(hostName, endpoint),
          headers: {'X-Forwarded-Authorization': 'Bearer $token'},
          body: jsonData);
    } finally {
      client.close();
    }
  }

  Future<List<Post>> getPosts(lat, lang) async {
    print("START GET POSTS");
    List<Post> posts = List.empty(growable: true);
    getQueryParameters['lat'] = lat.toString();
    getQueryParameters['lang'] = lang.toString();
    try {
      print("TRY GET POSTS");
      var response = await client.get(
          Uri.https(hostName,
              endpoint + "/" + lang.toString() + "/" + lat.toString()),
          headers: {'Authorization': 'Bearer $token'});
      print(hostName + endpoint + "/" + lat.toString() + "/" + lang.toString());
      print(response.body.toString());
      var decodedResponse = jsonDecode(response.body) as Map;
      print(decodedResponse);
      List plist = decodedResponse['post'];

      for (var i = 0; i < plist.length; i++) {
        Map p = plist[i];
        posts.add(Post(p['post_id'], p['author_google_id'], p['title'],
            p['content'], p['longitude'], p['latitude']));
      }
    } finally {
      client.close();
    }
    print("END GET POSTS");
    return posts;
  }

  Future<Post> getPost(String id) async {
    Post post;
    try {
      var response = await client.get(Uri.https(hostName, endpoint + "/"+id),
          headers: {'X-Forwarded-Authorization': 'Bearer $token'});
      print(hostName+ endpoint + "/"+id);
      var p = jsonDecode(response.body) as Map;
      post = Post(p['post_id'], p['author_google_id'], p['title'], p['content'],
          p['longitude'], p['latitude']);
    } finally {
      client.close();
    }
    return post;
  }
}
