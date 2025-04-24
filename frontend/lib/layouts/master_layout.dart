import 'package:flutter/material.dart';

class MasterLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MasterLayout({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(padding: const EdgeInsets.all(16.0), child: child),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          '© 2025 PhotoAid Team',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
