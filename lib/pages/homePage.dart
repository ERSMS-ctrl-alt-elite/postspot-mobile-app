import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map myMessages = {};
  static const _initialCameraPosition = CameraPosition(target: LatLng(37.77, -122.43), zoom: 11.5);
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: const [
            Icon(Icons.edit_location_alt_outlined),
            Text('PostSpot',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
          ]),
          backgroundColor: const Color.fromARGB(255, 64, 100, 133),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_sharp),
              color: Colors.white,
              iconSize: 40.0,
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            )
          ]),
      body: Column(
        children: [
          Flexible(
              flex: 9,
              child: GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
          _googleMapController.complete(controller);
        },)),
          Flexible(
              flex: 1,
              child: Container(
                  color: const Color.fromARGB(255, 64, 100, 133),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            dynamic result = await Navigator.pushNamed(
                                context, '/createPost');
                            setState(() {
                              myMessages[result['messageId']] = {
                                'title': result['title'],
                                'message': result['message']
                              };
                            });
                          },
                          icon: const Icon(Icons.add_comment),
                          color: Colors.white,
                          iconSize: 35.0,
                        )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                            child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.group_sharp),
                          color: Colors.white,
                          iconSize: 35.0,
                        )),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
