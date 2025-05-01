import 'package:flutter/material.dart';

class MyApp1 extends StatelessWidget
{
  const MyApp1({super.key});
  
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Home Page"),
        ),
      )
    );
  }
  
}