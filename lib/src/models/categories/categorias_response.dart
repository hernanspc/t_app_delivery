class CategoriasResponse {
  final bool success;
  final Mensaje mensaje;
  final List<Categoria> categorias;

  CategoriasResponse({
    required this.success,
    required this.mensaje,
    required this.categorias,
  });

  factory CategoriasResponse.fromJson(Map<String, dynamic> json) {
    return CategoriasResponse(
      success: json['success'] ?? false,
      mensaje: Mensaje.fromJson(json['mensaje'] ?? {}),
      categorias: (json['categorias'] is List)
          ? (json['categorias'] as List)
                .map((e) => Categoria.fromJson(e))
                .toList()
          : [],
    );
  }
}

class Mensaje {
  final int exito;
  final String mensaje;

  Mensaje({required this.exito, required this.mensaje});

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(exito: json['EXITO'] ?? 0, mensaje: json['MENSAJE'] ?? '');
  }
}

class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final String rutaImagen;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.rutaImagen,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['ID'] ?? 0,
      nombre: json['NOMBRE'] ?? '',
      descripcion: json['DESCRIPCION'] ?? '',
      rutaImagen: json['RUTA_IMAGEN'] ?? '',
    );
  }
}
