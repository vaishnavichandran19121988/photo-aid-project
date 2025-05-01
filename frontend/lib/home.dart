import 'package:flutter/material.dart';
import 'package:photoaid/activity.dart';
import 'package:photoaid/profile.dart';
import 'package:photoaid/maps.dart';


class HomePhotoAid extends StatelessWidget {
  final String userName;
  const HomePhotoAid({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BottomNavigationBarMaster());
  }
}

class BottomNavigationBarMaster extends StatefulWidget {
  const BottomNavigationBarMaster({super.key});

  @override
  State<BottomNavigationBarMaster> createState() => _BottomNavigationBarMasterState();
}

class _BottomNavigationBarMasterState extends State<BottomNavigationBarMaster> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MapPhotoAid(),
    ActivityPhotoAid(),
    ProfilePhotoAid(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Photo Aid')),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


