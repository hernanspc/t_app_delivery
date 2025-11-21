class Product {
  final dynamic id;
  final dynamic nombre;
  final dynamic descripcion;
  final dynamic? rutaImagen;
  final dynamic precio;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.rutaImagen,
    required this.precio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["ID"] ?? 0,
      nombre: json["NOMBRE"] ?? "",
      descripcion: json["DESCRIPCION"] ?? "",
      rutaImagen: json["RUTA_IMAGEN"],
      precio: json["PRECIO"],
    );
  }

  static List<Product> fromJsonList(List<dynamic> list) {
    return list.map((item) => Product.fromJson(item)).toList();
  }
}
