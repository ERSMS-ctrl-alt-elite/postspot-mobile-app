import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postspot_mobile_app/pages/homePage.dart';
import 'package:postspot_mobile_app/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  var token;
  var client = http.Client();

  var hostName = r"postspot-api-gateway-eu-dev-v1-0-8-a5mqnrt6.nw.gateway.dev";
  var endpoint = r"/v1/users";

  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            token = snapshot.data!.refreshToken;
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> postUserToken() async {
    await AuthService().signInWithGoogle();
    try {
      var response = await client.post(Uri.https(hostName, endpoint),
          headers: {'Authorization': 'Bearer $token'}, body: '');
      print("LOGIN - send token ");
    } finally {
      client.close();
    }
  }
}
