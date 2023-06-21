import 'package:flutter/material.dart';
import 'package:postspot_mobile_app/services/authService.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return  Material(child: SafeArea( child: Container(
      color: Color.fromRGBO(224, 241, 255, 0.973),
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            left: 20, right: 20, top: size.height * 0.2, bottom: size.height * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: const [
            Icon(Icons.edit_location_alt_outlined, color: const Color.fromARGB(255, 64, 100, 133), size: 40,),
            Text('PostSpot',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w900,
                  fontSize: 50,
                  color: const Color.fromARGB(255, 64, 100, 133)
                )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 60,),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 253, 253, 253))
                ),
                onPressed: () async {
                  AuthService().signInWithGoogle();
                  await AuthService().postUserToken();
                },
                child: Container(child: Row(children: const [
                  Image(width: 40, image: AssetImage('assets/google.png')),
                  SizedBox(width: 20),
                  Text("Sign in with Google",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 64, 100, 133),
                    fontSize: 15
                  ),
                  )
                ]),
                padding:  EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 70,
                ),
                
                ),
          ],
        ),
      )));
    
  }
}