import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPhotoAid extends StatefulWidget {
  const MapPhotoAid({super.key});
  @override
  State<MapPhotoAid> createState() => _PopupExampleState();
}

class _PopupExampleState extends State<MapPhotoAid> {
  bool infoWindowVisible = false;
  LatLng markerCoords = LatLng(-27.4698, 153.0251);
  double infoWindowOffset = 0.002;
  LatLng? infoWindowCoords;

  bool switchValue = false;

  void showNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification triggered!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    infoWindowCoords = LatLng(
      markerCoords.latitude + infoWindowOffset,
      markerCoords.longitude,
    );
  }

  final List<LatLng> locations = [
    LatLng(-27.4698, 153.0251),
    LatLng(-27.4597, 153.0351), // Sydney
    LatLng(-27.4975, 153.0137), // Melbourne
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Leading widget (top-left corner)
        elevation: 1,
        title: Row(
          children: [
            
            SizedBox(width: 10),
            Text('Online:', style: TextStyle(fontSize: 14, color: Colors.black)),
            Switch(
              value: switchValue,
              onChanged: (val) => setState(() => switchValue = val),
            ),
          ],
        ),

        // Action widget (top-right corner)
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: showNotification,
          ),
        ],
      ),
      body: Stack(
        children: [
          content(context),
         
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    List<Marker> markerList = List.generate(locations.length, (index) {
      final location = locations[index];
      return Marker(
        width: 60.0,
        height: 60.0,
        point: location,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('User Profile'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: AssetImage('images/user1.png'),
                            height: 100,
                          ),
                          SizedBox(height: 16),
                          Text('Do you want to choose this user?'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Perform action here
                            Navigator.of(context).pop();
                          },
                          child: Text('Send request'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(
                Icons.location_pin,
                color:
                    index == 0
                        ? Colors.blue
                        : Colors.red, // 🎨 Different color for index 0
                size: 40,
              ),
            ),
          ],
        ),
      );
    });
    return FlutterMap(
      options: MapOptions(
        initialCenter: markerCoords,
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
          flags: ~InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [openStreetMapTileLayer, MarkerLayer(markers: markerList)],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'com.example.app',
);
