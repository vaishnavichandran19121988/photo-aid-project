import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class MapPhotoAid extends StatelessWidget {
  const MapPhotoAid({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PopupExample(), debugShowCheckedModeBanner: false);
  }
}

class PopupExample extends StatefulWidget {
  const PopupExample({super.key});
  @override
  State<PopupExample> createState() => _PopupExampleState();
}

class _PopupExampleState extends State<PopupExample> {
  final PopupController _popupController = PopupController();
  bool infoWindowVisible = false;
  LatLng markerCoords = LatLng(-27.4698, 153.0251);
  double infoWindowOffset = 0.002;
  LatLng? infoWindowCoords;

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

  Widget _navButton({required String label, required IconData icon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFCBFFA9), // light green
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 24, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPopup(BuildContext context) {
    return  Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      );
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map", style: TextStyle(fontSize: 22))),
      body: content(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(label: 'Home', icon: Icons.home),
            _navButton(label: 'Map', icon: Icons.map),
            _navButton(label: 'Profile', icon: Icons.person),
            _navButton(label: 'Setting', icon: Icons.settings),
          ],
        ),
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
        child: Icon(
            Icons.location_pin,
            color:
                index == 0
                    ? Colors.blue
                    : Colors.red, // 🎨 Different color for index 0
            size: 40,
          ),
      );
    });
    return FlutterMap(
      options: MapOptions(
        initialCenter: markerCoords,
        initialZoom: 11,
        onTap: (_, __) => _popupController.hideAllPopups(),
        interactionOptions: const InteractionOptions(
          flags: ~InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [openStreetMapTileLayer,
      PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: markerList,
              popupController: _popupController,
              selectedMarkerBuilder: (context, marker) => _buildPopup(context),
            ),
          ),],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'com.example.app',
);

