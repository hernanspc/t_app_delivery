import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateLocalJwt({required int userId, int durationMinutes = 60}) {
  final jwt = JWT({
    'userId': userId,
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp':
        DateTime.now()
            .add(Duration(minutes: durationMinutes))
            .millisecondsSinceEpoch ~/
        1000,
  });

  return jwt.sign(SecretKey('clave_secreta_local'));
}
