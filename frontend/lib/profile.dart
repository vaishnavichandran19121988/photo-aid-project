import 'package:flutter/material.dart';
import 'package:photoaid/features/presentation/editprofile.dart';


// A simple user model
class User {
  String name;
  String bio;
  double rating;

  User({required this.name, required this.bio, required this.rating});
}

User currentUser = User(
  name: 'Jane Doe',
  bio: 'Parttime Photographer',
  rating: 4.8,
);

// Profile screen
class ProfilePhotoAid extends StatefulWidget {
  const ProfilePhotoAid({super.key});

  @override
  State<ProfilePhotoAid> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePhotoAid> {
  void _navigateToEditProfile() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: currentUser),
      ),
    );

    if (updatedUser != null && updatedUser is User) {
      setState(() {
        currentUser = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            Text('Profile', style: TextStyle(color: Colors.black)),
        ],
      )
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            Text('Name: ${currentUser.name}', style: const TextStyle(fontSize: 18)),
            Text('Bio: ${currentUser.bio}', style: const TextStyle(fontSize: 18)),
            Text('Rating: ${currentUser.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _navigateToEditProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
