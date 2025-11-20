class UserCompanyInfo {
  final dynamic empresaId;
  final dynamic empresaNombre;
  final dynamic empresaDireccion;
  final dynamic? empresaLogo;
  final dynamic? empresaRuc;
  final dynamic? empresaTelefono;
  final dynamic usuarioId;
  final dynamic usuario;
  final dynamic usuarioTipoUsuario;
  final dynamic tiendaId;
  final dynamic tiendaNombre;
  final dynamic tiendaTelefono;

  UserCompanyInfo({
    required this.empresaId,
    required this.empresaNombre,
    required this.empresaDireccion,
    required this.empresaLogo,
    required this.empresaRuc,
    required this.empresaTelefono,
    required this.usuarioId,
    required this.usuario,
    required this.usuarioTipoUsuario,
    required this.tiendaId,
    required this.tiendaNombre,
    required this.tiendaTelefono,
  });

  factory UserCompanyInfo.fromJson(Map<dynamic, dynamic> json) {
    return UserCompanyInfo(
      empresaId: json["EMPRESA_ID"],
      empresaNombre: json["EMPRESA_NOMBRE"],
      empresaDireccion: json["EMPRESA_DIRECCION"],
      empresaLogo: json["EMPRESA_LOGO"],
      empresaRuc: json["EMPRESA_RUC"],
      empresaTelefono: json["EMPRESA_TELEFONO"],
      usuarioId: json["USUARIO_ID"],
      usuario: json["USUARIO"],
      usuarioTipoUsuario: json["USUARIO_TIPO_USUARIO"],
      tiendaId: json["TIENDA_ID"],
      tiendaNombre: json["TIENDA_NOMBRE"],
      tiendaTelefono: json["TIENDA_TELEFONO"],
    );
  }

  Map<String, dynamic> toJson() => {
    "EMPRESA_ID": empresaId,
    "EMPRESA_NOMBRE": empresaNombre,
    "EMPRESA_DIRECCION": empresaDireccion,
    "EMPRESA_LOGO": empresaLogo,
    "EMPRESA_RUC": empresaRuc,
    "EMPRESA_TELEFONO": empresaTelefono,
    "USUARIO_ID": usuarioId,
    "USUARIO": usuario,
    "USUARIO_TIPO_USUARIO": usuarioTipoUsuario,
    "TIENDA_ID": tiendaId,
    "TIENDA_NOMBRE": tiendaNombre,
    "TIENDA_TELEFONO": tiendaTelefono,
  };
}
