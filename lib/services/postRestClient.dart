import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/post.dart';
import 'package:http/http.dart' as http;

class PostRestService {
  Post? post;
  var lat;
  var lang;

  var accessToken;
  var client = http.Client();
  
  var hostName = "https://postspot-api-gateway-eu-dev-v1-0-8-a5mqnrt6.nw.gateway.dev";
  var endpoint = "/v1/posts";
  Map<String,String> getQueryParameters = {};

  PostRestService(post, lat, lang){
    this.post = post;
    this.lat = lat;
    this.lang = lang;
    this.accessToken = FirebaseAuth.instance.currentUser!.refreshToken;
    getQueryParameters['lat'] = lat;
    getQueryParameters['lang'] = lang;
  }

  Future<void> createPost() async {
    final jsonData = post!.toJson();
    try {
      var response = await client.post(
        Uri.https(hostName,endpoint),
        headers:{
          'token' : accessToken
        }, 
         body: jsonData);
    } finally {
      client.close();
    }
  }

  Future<void> getPosts() async {
    try {
      var response = await client.get(
        Uri.https(hostName,endpoint,getQueryParameters),
        headers:{
          'token' : accessToken
        });
    } finally {
      client.close();
    }
  }

}


