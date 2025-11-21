import 'package:flutter/material.dart';

class ClientOrdersListPage extends StatelessWidget {
  const ClientOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Orders List Page'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Client Orders List Page Body')),
    );
  }
}
