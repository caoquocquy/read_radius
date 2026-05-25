import 'package:flutter/material.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  static const String routeName = 'guest-home';
  static const String routePath = '/guest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BookRadius')),
      body: const Center(
        child: Text('Guest Book Wall (Day 1 Placeholder)'),
      ),
    );
  }
}
