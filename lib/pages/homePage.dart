import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map myMessages = {};

  static var _initialCameraPosition;
  static var myLocation;
  Location location = new Location();
  PermissionStatus? _permissionGranted;
  static const double ZOOM = 18.5;
  String _mapStyle = '';

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  Future<LocationData> getCurrentLocation() async {
    checkLocationService();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    myLocation = await location.getLocation();
    print("TEST" + myLocation.toString());

    _initialCameraPosition =
        LatLng(myLocation.latitude!, myLocation.longitude!);

    if (myLocation == null) {
      myLocation =
          LocationData.fromMap({"latitude": 52.13, "longitude": 21.00});
    }
    return myLocation;
  }

  void checkLocationService() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("TEST - permissiona & service OK");
  }

  @override
  void initState() {
    super.initState();
    //checkLocationService();
    //await getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    //await getCurrentLocation();

    print("BUILD");

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
              child: FutureBuilder<LocationData>(
                  future: getCurrentLocation(),
                  builder: (BuildContext context,
                      AsyncSnapshot<LocationData> snapshot) {
                    if (!snapshot.hasData) {
                      // while data is loading:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // data loaded:

                      return GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(_initialCameraPosition.latitude,
                                  _initialCameraPosition.longitude),
                              zoom: ZOOM),
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _googleMapController.complete(controller);
                            controller.setMapStyle(_mapStyle);
                          });
                    }
                  })),
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
