class ProductAll {
  final int id;
  final int categoriaId;
  final String nombre;
  final String descripcion;
  final String? rutaImagen;
  final double precio;
  final String moneda;

  ProductAll({
    required this.id,
    required this.categoriaId,
    required this.nombre,
    required this.descripcion,
    this.rutaImagen,
    required this.precio,
    required this.moneda,
  });

  factory ProductAll.fromJson(Map<String, dynamic> json) {
    return ProductAll(
      id: json['ID'],
      categoriaId: json['CATEGORIA_ID'],
      nombre: json['NOMBRE'],
      descripcion: json['DESCRIPCION'],
      rutaImagen: json['RUTA_IMAGEN'],
      precio: (json['PRECIO'] as num).toDouble(),
      moneda: json['MONEDA'],
    );
  }
}

class CategoryAndProductsAll {
  final int id;
  final String nombre;
  final String descripcion;
  final String? rutaImagen;
  final List<ProductAll> productos;

  CategoryAndProductsAll({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.rutaImagen,
    required this.productos,
  });

  factory CategoryAndProductsAll.fromJson(Map<String, dynamic> json) {
    var productosJson = json['PRODUCTOS'] as List<dynamic>?;
    final productosList = productosJson != null
        ? productosJson.map((p) => ProductAll.fromJson(p)).toList()
        : <ProductAll>[];

    return CategoryAndProductsAll(
      id: json['ID'],
      nombre: json['NOMBRE'],
      descripcion: json['DESCRIPCION'],
      rutaImagen: json['RUTA_IMAGEN'],
      productos: productosList,
    );
  }
}
