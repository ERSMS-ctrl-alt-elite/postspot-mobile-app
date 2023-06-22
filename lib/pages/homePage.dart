import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:postspot_mobile_app/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postspot_mobile_app/services/postRestClient.dart';
import 'package:postspot_mobile_app/data/post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postspot_mobile_app/services/userRestClient.dart';
import 'package:postspot_mobile_app/data/user.dart' as us;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = List.empty(growable: true);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static var _initialCameraPosition;
  static var myLocation;
  static LocationData myRelativeLocation =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  var location = new Location();
  PermissionStatus? _permissionGranted;
  static const double ZOOM = 18.5;
  String _mapStyle = '';
  Set<Marker> _markers = Set<Marker>();
  var messageIcon;
  var messageOpenIcon;
  static const int timerPeriod = 5;

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  Timer? _timer;

  Future<LocationData> getInitLocation() async {
    checkLocationService();

    myLocation = await location.getLocation();
    print("TEST " + myLocation.toString());

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

    // POBIERANIE POSTÓW - DZIAŁA W PĘTLI UWAGA!!!
    //posts = await PostRestService().getPosts(myLocation.latitude, myLocation.longitude);
    //if (checkRelativeLocation()) {
      //await downloadClosePostsAndUpdateMarks();
    //}
  }

  Future<LocationData> getCurrentLocation() async {
    print("GET CURRENT LOCATION");
    Location location = Location();
    location.getLocation().then(
      (location) {
        myLocation = location;
      },
    );
    GoogleMapController googleMapController = await _googleMapController.future;
    location.onLocationChanged.listen(
      (newLoc) {
        myLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: ZOOM,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
    return myLocation;
  }

  bool checkRelativeLocation() {
    if ((myLocation.latitude - myRelativeLocation.latitude).abs() > 10.0 ||
        (myRelativeLocation.longitude! - myRelativeLocation.longitude!).abs() >
            10.0) {
      myRelativeLocation = myLocation;
      return true;
    } else {
      return false;
    }
  }

  Future<void> downloadClosePostsAndUpdateMarks() async {
    print("DOWNLOAD POSTS");
    var res = await PostRestService()
          .getPosts(myLocation.latitude, myLocation.longitude);
    setState(() {
      posts = res;
      createMarkers();
    });
  }

  void updatePinOnMap(GoogleMapController controller) async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: ZOOM,
      target: LatLng(myLocation.latitude, myLocation.longitude),
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(myLocation.latitude, myLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
    });
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object

    //setInitMarkersPostsTEST();
    // destination pin
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
  }

  void startPostsTimer() {
    int time = 0;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (time == 0) {
          downloadClosePostsAndUpdateMarks();
          setState(() {
            time = timerPeriod;
            //createMarkers();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  void setInitMarkersPostsTEST() async {
    var mess1 = LatLng(52.2606860, 20.9329840);
    var mess2 = LatLng(52.2610000, 20.9327200);
    var mess3 =
        LatLng(52.2606360, 20.9326040); // add the initial source location pin

    _markers.add(Marker(
        markerId: MarkerId('message1'),
        position: mess1,
        icon: BitmapDescriptor.fromBytes(messageIcon),
        consumeTapEvents: true,
        onTap: () {
          // Kod obsługi naciśnięcia przycisku dla tego markera
          var distance = calculateDistance(myLocation.latitude,
              myLocation.longitude, mess1.latitude, mess1.longitude);
          print("TEST DISTANCE: " + distance.toString());
          if (distance < 10) {
            print("OPEN MESSAGE");
          }
        }));
    _markers.add(Marker(
        markerId: MarkerId('message2'),
        position: mess2,
        icon: BitmapDescriptor.fromBytes(messageOpenIcon),
        consumeTapEvents: true,
        onTap: () {
          // Kod obsługi naciśnięcia przycisku dla tego markera
          var distance = calculateDistance(myLocation.latitude,
              myLocation.longitude, mess1.latitude, mess1.longitude);
          print("TEST DISTANCE: " + distance.toString());
          if (distance < 10) {
            print("OPEN MESSAGE");
          }
        }));
    _markers.add(Marker(
        markerId: MarkerId('message3'),
        position: mess3,
        icon: BitmapDescriptor.fromBytes(messageIcon),
        consumeTapEvents: true,
        onTap: () {
          // Kod obsługi naciśnięcia przycisku dla tego markera
          var distance = calculateDistance(myLocation.latitude,
              myLocation.longitude, mess1.latitude, mess1.longitude);
          print("TEST DISTANCE: " + distance.toString());
          if (distance < 10) {
            print("OPEN MESSAGE");
          }
        }));
  }

  void createMarkers() {
    if (_markers.isNotEmpty) _markers.clear();

    for (var i = 0; i < posts.length; i++) {
      var p = posts[i];
      var distance = calculateDistance(
          myLocation.latitude, myLocation.longitude, p.latitude, p.longitude);

      final marker = Marker(
          markerId: MarkerId(p.post_id),
          position: LatLng(p.latitude, p.longitude),
          icon: BitmapDescriptor.fromBytes(
              distance < 10 ? messageOpenIcon : messageIcon),
          consumeTapEvents: true,
          onTap: () async {
            // Kod obsługi naciśnięcia przycisku dla tego markera
            if (distance < 10) {
              print("TEST DISTANCE: " + distance.toString());
              print("OPEN MESSAGE");
              print(MarkerId(p.post_id).value);

              us.User user =
                  await UserRestService().getName(p.author_google_id);
              p.name = user.name!;

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(posts[i].title),
                      content: Stack(
                        //overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: 12,
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(child: Text(posts[i].content)),
                                  Flexible(child: SizedBox(height: 40)),
                                  Flexible(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                        Text(p.name),
                                        IconButton(
                                          onPressed: () async {
                                            var response =
                                                await UserRestService()
                                                    .follow(p.author_google_id);
                                            print(response);
                                            final messenger =
                                                ScaffoldMessenger.of(context);
                                            if (response == "User followed") {
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'User successfully followed!')),
                                              );
                                            } else {
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Failed to follow user :(')),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.add),
                                          color: const Color.fromARGB(
                                              255, 64, 100, 133),
                                          iconSize: 35.0,
                                        )
                                      ]))
                                ],
                              )),
                        ],
                      ),
                    );
                  });
            }
          });
      setState(() {
        markers[MarkerId(p.post_id)] = marker;
      });
    }
    print("CREATE MARKERS");
  }

  void initPostsTEST() {
    posts.add(
        Post('1', 'google1', 'Title1', 'message1', 20.9329840, 52.2606860, ""));
    posts.add(
        Post('2', 'google2', 'Title2', 'message2', 20.9327200, 52.2610000, ""));
    posts.add(
        Post('3', 'google3', 'Title3', 'message3', 20.9326040, 52.2606360, ""));
  }

  void setMarkersIcon() async {
    messageIcon = await getBytesFromAsset('assets/env1.png', 100);
    messageOpenIcon = await getBytesFromAsset('assets/env2.png', 100);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

// double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
//   const int earthRadius = 6371000; // Przybliżony promień Ziemi w metrach
//   double lat1Rad = startLatitude * (pi / 180);
//   double lon1Rad = startLongitude * (pi / 180);
//   double lat2Rad = endLatitude * (pi / 180);
//   double lon2Rad = endLongitude * (pi / 180);
//   double dlat = lat2Rad - lat1Rad;
//   double dlon = lon2Rad - lon1Rad;
//   double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dlon / 2) * sin(dlon / 2);
//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//   double distance = earthRadius * c;
//   return distance;
// }
// double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
//   double dx = endLongitude - startLongitude;
//   double dy = endLatitude - startLatitude;
//   double distance = sqrt(dx * dx + dy * dy);
//   return distance;
// }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return distanceInMeters;
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    setMarkersIcon();

    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      myLocation = cLoc;
    });
    //checkLocationService();
    getCurrentLocation();
    //initPostsTEST();

    print("INIT");
  }

  @override
  Widget build(BuildContext context) {
    //await getCurrentLocation();

    print("BUILD");
    if (posts.isNotEmpty) print(posts[0].toJson());

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
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
              child: FutureBuilder<void>(
                  future: getInitLocation(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                          scrollGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          tiltGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          liteModeEnabled: false,
                          myLocationButtonEnabled: true,
                          markers: markers.values.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            print("BUILD MAP");
                            _googleMapController.complete(controller);
                            controller.setMapStyle(_mapStyle);
                            updatePinOnMap(controller);
                            startPostsTimer();
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
                              //po[result['id']] = {
                              //  'title': result['title'],
                              //  'message': result['message']
                              //};
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
                          onPressed: () async {
                            final User? currentUser =
                                FirebaseAuth.instance.currentUser;
                            var googleId;
                            if (currentUser != null) {
                              currentUser
                                  .getIdTokenResult()
                                  .then((idTokenResult) async{
                                googleId = idTokenResult.claims!['firebase']
                                    ['identities']['google.com'][0];
                                print('Google ID: $googleId');
                                print('Google ID: $googleId');
                            var followeesRspn =
                                await UserRestService().getFollowees(googleId);
                            dynamic result = await Navigator.pushNamed(
                                context, '/follower',
                                arguments: {"followees": followeesRspn});
                              }).catchError((error) {
                                print(
                                    'Błąd podczas pobierania Google ID: $error');
                              });
                            }
                            
                          },
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
