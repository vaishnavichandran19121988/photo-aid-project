import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:photoaid/home.dart';
import 'package:photoaid/register.dart';

class LoginPhotoAid extends StatelessWidget {
  const LoginPhotoAid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // for form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

   String baseUrl = 'http://localhost:8080';


   Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      //String email = _emailController.text;
      //String password = _passwordController.text;
      final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];

     

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePhotoAid(userName: user['name']),
        ),
      );
    } else {
      final error = jsonDecode(response.body)['error'];
     
    }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // attaches the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email
              Image(image: AssetImage('images/my_image.jpeg')),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
              ),

              SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
            onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            );
            },
            child: const Text("Don't have an account? Register"),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
