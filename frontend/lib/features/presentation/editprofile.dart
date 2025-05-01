
import 'package:flutter/material.dart';
import 'package:photoaid/profile.dart';


// Edit profile screen
class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late double rating;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    bioController = TextEditingController(text: widget.user.bio);
    rating = widget.user.rating;
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = User(
      name: nameController.text,
      bio: bioController.text,
      rating: rating,
    );
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Rating:', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: rating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: rating.toStringAsFixed(1),
                    onChanged: (value) => setState(() => rating = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
