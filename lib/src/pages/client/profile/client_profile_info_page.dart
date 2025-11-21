import 'package:flutter/material.dart';

class ClientProfileInfoPage extends StatelessWidget {
  const ClientProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile Info Page'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Client Profile Info Page Body')),
    );
  }
}
