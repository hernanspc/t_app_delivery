import 'package:flutter/material.dart';

class RolScreen extends StatelessWidget {
  const RolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Rol')),
      body: const Center(child: Text('Aquí va la selección de rol')),
    );
  }
}
