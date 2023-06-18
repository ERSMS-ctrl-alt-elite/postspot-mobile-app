// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() =>  MapScreenState();
// }

// class  MapScreenState extends State<MapScreen> {

//   static const _initialCameraPosition = CameraPosition(target: LatLng(37.77, -122.43), zoom: 11.5);
//   GoogleMapController _googleMapController = GoogleMapController();

//   @override
//   void dispose(){
//     _googleMapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: _initialCameraPosition,
//       myLocationButtonEnabled: false,
//       zoomControlsEnabled: false,
//       onMapCreated: (controller) => _googleMapController = controller,
//       );
//   }
// }