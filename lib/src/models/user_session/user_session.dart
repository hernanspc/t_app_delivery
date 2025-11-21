import 'package:delivery_app/src/models/login/user_company_info.dart';

class UserSession {
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

  UserSession({
    required this.empresaId,
    required this.empresaNombre,
    required this.empresaDireccion,
    this.empresaLogo,
    this.empresaRuc,
    this.empresaTelefono,
    required this.usuarioId,
    required this.usuario,
    required this.usuarioTipoUsuario,
    required this.tiendaId,
    required this.tiendaNombre,
    required this.tiendaTelefono,
  });

  factory UserSession.fromCompanyInfo(UserCompanyInfo info) {
    return UserSession(
      empresaId: info.empresaId,
      empresaNombre: info.empresaNombre,
      empresaDireccion: info.empresaDireccion,
      empresaLogo: info.empresaLogo,
      empresaRuc: info.empresaRuc,
      empresaTelefono: info.empresaTelefono,
      usuarioId: info.usuarioId,
      usuario: info.usuario,
      usuarioTipoUsuario: info.usuarioTipoUsuario,
      tiendaId: info.tiendaId,
      tiendaNombre: info.tiendaNombre,
      tiendaTelefono: info.tiendaTelefono,
    );
  }

  Map<String, dynamic> toJson() => {
    "empresaId": empresaId,
    "empresaNombre": empresaNombre,
    "empresaDireccion": empresaDireccion,
    "empresaLogo": empresaLogo,
    "empresaRuc": empresaRuc,
    "empresaTelefono": empresaTelefono,
    "usuarioId": usuarioId,
    "usuario": usuario,
    "usuarioTipoUsuario": usuarioTipoUsuario,
    "tiendaId": tiendaId,
    "tiendaNombre": tiendaNombre,
    "tiendaTelefono": tiendaTelefono,
  };

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    empresaId: json["empresaId"],
    empresaNombre: json["empresaNombre"],
    empresaDireccion: json["empresaDireccion"],
    empresaLogo: json["empresaLogo"],
    empresaRuc: json["empresaRuc"],
    empresaTelefono: json["empresaTelefono"],
    usuarioId: json["usuarioId"],
    usuario: json["usuario"],
    usuarioTipoUsuario: json["usuarioTipoUsuario"],
    tiendaId: json["tiendaId"],
    tiendaNombre: json["tiendaNombre"],
    tiendaTelefono: json["tiendaTelefono"],
  );
}
