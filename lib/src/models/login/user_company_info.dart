class UserCompanyInfo {
  final int empresaId;
  final String empresaNombre;
  final String empresaDireccion;
  final String? empresaLogo;
  final String? empresaRuc;
  final String? empresaTelefono;
  final int usuarioId;
  final String usuario;
  final String usuarioTipoUsuario;
  final int tiendaId;
  final String tiendaNombre;
  final String tiendaTelefono;

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

  // -------------------------------
  // COPYWITH
  // -------------------------------
  UserCompanyInfo copyWith({
    int? empresaId,
    String? empresaNombre,
    String? empresaDireccion,
    String? empresaLogo,
    String? empresaRuc,
    String? empresaTelefono,
    int? usuarioId,
    String? usuario,
    String? usuarioTipoUsuario,
    int? tiendaId,
    String? tiendaNombre,
    String? tiendaTelefono,
  }) {
    return UserCompanyInfo(
      empresaId: empresaId ?? this.empresaId,
      empresaNombre: empresaNombre ?? this.empresaNombre,
      empresaDireccion: empresaDireccion ?? this.empresaDireccion,
      empresaLogo: empresaLogo ?? this.empresaLogo,
      empresaRuc: empresaRuc ?? this.empresaRuc,
      empresaTelefono: empresaTelefono ?? this.empresaTelefono,
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      usuarioTipoUsuario: usuarioTipoUsuario ?? this.usuarioTipoUsuario,
      tiendaId: tiendaId ?? this.tiendaId,
      tiendaNombre: tiendaNombre ?? this.tiendaNombre,
      tiendaTelefono: tiendaTelefono ?? this.tiendaTelefono,
    );
  }

  // -------------------------------
  // FROM JSON
  // -------------------------------
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

  // -------------------------------
  // TO JSON
  // -------------------------------
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

  // -------------------------------
  // EQUALITY & HASHCODE
  // -------------------------------
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserCompanyInfo &&
        other.empresaId == empresaId &&
        other.empresaNombre == empresaNombre &&
        other.empresaDireccion == empresaDireccion &&
        other.empresaLogo == empresaLogo &&
        other.empresaRuc == empresaRuc &&
        other.empresaTelefono == empresaTelefono &&
        other.usuarioId == usuarioId &&
        other.usuario == usuario &&
        other.usuarioTipoUsuario == usuarioTipoUsuario &&
        other.tiendaId == tiendaId &&
        other.tiendaNombre == tiendaNombre &&
        other.tiendaTelefono == tiendaTelefono;
  }

  @override
  int get hashCode {
    return empresaId.hashCode ^
        empresaNombre.hashCode ^
        empresaDireccion.hashCode ^
        empresaLogo.hashCode ^
        empresaRuc.hashCode ^
        empresaTelefono.hashCode ^
        usuarioId.hashCode ^
        usuario.hashCode ^
        usuarioTipoUsuario.hashCode ^
        tiendaId.hashCode ^
        tiendaNombre.hashCode ^
        tiendaTelefono.hashCode;
  }

  // -------------------------------
  // TOSTRING
  // -------------------------------
  @override
  String toString() {
    return '''
UserCompanyInfo(
  empresaId: $empresaId,
  empresaNombre: $empresaNombre,
  empresaDireccion: $empresaDireccion,
  empresaLogo: $empresaLogo,
  empresaRuc: $empresaRuc,
  empresaTelefono: $empresaTelefono,
  usuarioId: $usuarioId,
  usuario: $usuario,
  usuarioTipoUsuario: $usuarioTipoUsuario,
  tiendaId: $tiendaId,
  tiendaNombre: $tiendaNombre,
  tiendaTelefono: $tiendaTelefono,
)
''';
  }
}
