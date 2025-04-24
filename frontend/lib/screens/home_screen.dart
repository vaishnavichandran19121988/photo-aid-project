import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool locationSharingEnabled = false;
  int _selectedIndex = 0;

  void _toggleLocationSharing() {
    setState(() {
      locationSharingEnabled = !locationSharingEnabled;
    });
    print(
      locationSharingEnabled
          ? '📍 Location sharing ON'
          : '📍 Location sharing OFF',
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userName}'),
        leading: IconButton(
          icon: Icon(
            locationSharingEnabled ? Icons.location_on : Icons.location_off,
            color: Colors.white,
          ),
          onPressed: _toggleLocationSharing,
        ),
      ),
      body:
          _selectedIndex == 0
              ? _buildHomeContent()
              : Center(
                child: Text(
                  _selectedIndex == 1
                      ? '👤 Profile tab selected'
                      : '📜 Activity Log tab selected',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity Log',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                '🗺️ Google Map Placeholder\n(Users nearby will show here)',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nearby Users',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(String name) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Text(name),
      ),
    );
  }
}
