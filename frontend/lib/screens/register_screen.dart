import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../layouts/master_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String baseUrl = 'http://localhost:8080'; // ✅ correct for Flutter Web

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
    return MasterLayout(
      title: 'Register',
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: const Text('Register')),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}
