import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import '../data/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostRestService {
  Future<String>? futureToken;
  var client = http.Client();

  var hostName = "postspot-api-gateway-eu-dev-a5mqnrt6.nw.gateway.dev";
  var endpoint = "/v1/posts";
  Map<String, String> getQueryParameters = {};

  PostRestService() {
    futureToken = FirebaseAuth.instance.currentUser!.getIdToken();
  }

  Future<http.Response> createPost(Post post) async {
    print("REST create post");
    final jsonData = post.toJson();
    var token = await futureToken;
    try {
      return await client.post(Uri.https(hostName, endpoint),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(jsonData));
    } finally {
      client.close();
    }
  }

  Future<List<Post>> getPosts(lat, lang) async {
    print("START GET POSTS");
    List<Post> posts = List.empty(growable: true);
    getQueryParameters['lat'] = lat.toString();
    getQueryParameters['lang'] = lang.toString();
    var token = await futureToken;
    try {
      print("TRY GET POSTS");
      var response = await client.get(
          Uri.https(hostName,
              endpoint + "/" + lang.toString() + "/" + lat.toString()),
          headers: {'Authorization': 'Bearer $token'});
      print(hostName + endpoint + "/" + lang.toString() + "/" + lat.toString());
      print(response.body.toString());
      var decodedResponse = jsonDecode(response.body) as Map;
      print(decodedResponse);

      if (!decodedResponse.containsKey('post')) {
        return posts;
      }
      List plist = decodedResponse['post'];

      for (var i = 0; i < plist.length; i++) {
        Map p = plist[i];
        posts.add(Post(p['post_id'], p['author_google_id'], p['title'],
            p['content'], p['longitude'], p['latitude'], ""));
      }
    } finally {
      client.close();
    }
    print("END GET POSTS");
    return posts;
  }

  Future<Post> getPost(String id) async {
    Post post;
    var token = await futureToken;
    try {
      var response = await client.get(Uri.https(hostName, endpoint + "/" + id),
          headers: {'Authorization': 'Bearer $token'});
      print(hostName + endpoint + "/" + id);
      var p = jsonDecode(response.body) as Map;
      post = Post(p['post_id'], p['author_google_id'], p['title'], p['content'],
          p['longitude'], p['latitude'], "");
    } finally {
      client.close();
    }
    return post;
  }

  Future<List<Post>> getPostsByauthor(String id) async {
    print("START GET POSTS by "+id);
    List<Post> posts = List.empty(growable: true);
    var token = await futureToken;
    try {
      print("TRY GET POSTS");
      var response = await client.get(
          Uri.https(hostName,
              endpoint, {'author': id} ),
          headers: {'Authorization': 'Bearer $token'});
      print(hostName + endpoint);
      print(response.body.toString());
      List<dynamic> decodedResponse = jsonDecode(response.body);
      print(decodedResponse);

      if (decodedResponse.isEmpty) {
        return posts;
      }

      for (var i = 0; i < decodedResponse.length; i++) {
        var p = decodedResponse[i];
        posts.add(Post(p['post_id'], p['author_google_id'], p['title'],
            p['content'], p['longitude'], p['latitude'], ""));
      }
    } finally {
      client.close();
    }
    print("END GET POSTS by "+id);
    return posts;
  }
}


