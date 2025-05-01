import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyAppMap extends StatefulWidget {
  const MyAppMap({super.key});

  @override
  State<MyAppMap> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sydney'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          markers: {
            const Marker(
              markerId: MarkerId('Sydney'),
              position: LatLng(-33.86, 151.20),
              infoWindow: InfoWindow(
                title: "Sydney",
                snippet: "Capital of New South Wales",
              ),
            ),
          },
        ),
      ),
    );
  }
}