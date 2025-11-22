import 'package:delivery_app/src/models/categories/categories_products_response.dart';
import 'package:flutter/material.dart';

class ClientProductDetailPage extends StatelessWidget {
  const ClientProductDetailPage({super.key, required ProductAll product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: const Center(
        child: Text('Aquí se mostrarán los detalles del producto.'),
      ),
    );
  }
}
