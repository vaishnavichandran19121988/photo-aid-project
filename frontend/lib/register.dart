import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:photoaid/login.dart';



class Register extends StatefulWidget {
   const Register({super.key});
  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   String baseUrl = 'http://localhost:8080';

 

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // ✅ Frontend validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackbar('All fields are required');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showSnackbar('Enter a valid email');
      return;
    }

    if (password.length < 6) {
      _showSnackbar('Password must be at least 6 characters');
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      _showSnackbar('Registration successful! Please log in.');
      Navigator.pushNamed(context, '/login');
    } else {
      final error = jsonDecode(response.body)['error'];
      _showSnackbar('Error: $error');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image(image: AssetImage('images/my_image.jpeg')),
            TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            TextButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPhotoAid()),
              );
            },child: const Text("Already have an account? Login"),),
          ],
        ),
      ),
    );
  }
}
