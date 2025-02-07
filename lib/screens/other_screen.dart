import 'package:flutter/material.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Screen'),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Show a loading spinner
      ),
    );
  }
}