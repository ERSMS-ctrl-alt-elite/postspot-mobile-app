import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:postspot_mobile_app/data/user.dart' as usser;

class UserRestService {
  Future<String>? futureToken;
  var client = http.Client();

  var hostName = "postspot-api-gateway-eu-dev-a5mqnrt6.nw.gateway.dev";
  var endpoint = "/v1/users";
  Map<String, String> getQueryParameters = {};

  PostRestService() {
    futureToken = FirebaseAuth.instance.currentUser!.getIdToken();
  }

  Future<usser.User> getName(String google_id) async {
    usser.User user;
    print("REST getName");
    var token = await futureToken;
    try {
      var rspn = await client.get(
          Uri.https(hostName, endpoint + "/" + google_id),
          headers: {'X-Forwarded-Authorization': 'Bearer $token'});
      print(hostName+ endpoint + "/" + google_id);
      print(rspn.body);
      var u = jsonDecode(rspn.body) as Map;
      user = usser.User(u['google_id'], u['name']);
    } finally {
      client.close();
    }
    return user;
  }

  Future<List<usser.User>> getFollowees(String google_id) async {
    List<usser.User> users = List.empty(growable: true);
    print("REST getFollowees");
    var token = await futureToken;
    try {
      var rspn = await client.get(
          Uri.https(hostName, endpoint + "/" + google_id + "/followees"),
          headers: {'X-Forwarded-Authorization': 'Bearer $token'});
      var u = jsonDecode(rspn.body) as Map;
      List userslist = u['user'];

      for (var i = 0; i < userslist.length; i++) {
        Map p = userslist[i];
        users.add(usser.User(p['google_id'], p['name']));
      }
    } finally {
      client.close();
    }
    return users;
  }


  Future<String> follow(String google_id) async {
    var rspn;
    List<usser.User> users = List.empty(growable: true);
    print("REST follow");
    var token = await futureToken;
    try {
      rspn = await client.post(
          Uri.https(hostName, endpoint + "/" + google_id + "/followers"),
          headers: {'X-Forwarded-Authorization': 'Bearer $token'});
      
    } finally {
      client.close();
    }
    return rspn.body;
  }
}
