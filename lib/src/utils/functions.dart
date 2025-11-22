import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:geolocator/geolocator.dart';

Future<String> generateLocalJwt({
  required String usuario,
  required String clave,
  int durationMinutes = 60,
}) async {
  final jwt = JWT({
    'usuario': usuario,
    'clave': clave,

    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp':
        DateTime.now()
            .add(Duration(minutes: durationMinutes))
            .millisecondsSinceEpoch ~/
        1000,
  });
  const secretKey = 'YOUR_SECRET_KEY';
  return jwt.sign(SecretKey(secretKey));
}

Future<String> getAddress(double latitude, double longitude) async {
  try {
    List<Geocoding.Placemark> placemarks =
        await Geocoding.placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) return 'Ubicación desconocida';
    final p = placemarks.first;

    print("País:       ${p.country}");
    print("Departamento: ${p.administrativeArea}");
    print("Provincia:    ${p.subAdministrativeArea}");
    print("Ciudad:       ${p.locality}");
    print("Distrito:     ${p.subLocality}");
    print("Calle:        ${p.thoroughfare}");
    print("Número:       ${p.subThoroughfare}");
    print("Postal Code:  ${p.postalCode}");

    /// Construcción flexible de la dirección
    final calle = [
      p.thoroughfare,
      p.subThoroughfare,
    ].where((e) => e != null && e!.isNotEmpty).join(' ');

    final zona = [
      p.subLocality, // distrito o sector
      p.locality, // ciudad
    ].where((e) => e != null && e!.isNotEmpty).join(', ');

    final region = [
      p.administrativeArea, // Provincia de Lima
      // p.postalCode,
    ].where((e) => e != null && e!.isNotEmpty).join(' ');

    /// Uniendo todo
    final address = [
      calle.isNotEmpty ? calle : null,
      zona.isNotEmpty ? zona : null,
      region.isNotEmpty ? region : null,
    ].where((e) => e != null && e!.isNotEmpty).join(', ');

    return address.isEmpty ? "Ubicación desconocida" : address;
  } catch (e) {
    print("Error al obtener la dirección: $e");
    return "Error al obtener la dirección";
  }
}

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Verifica si el servicio de ubicación está habilitado
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('El servicio de ubicación está deshabilitado.');
    return null;
  }

  // Verifica el estado del permiso de ubicación
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Permiso de ubicación denegado.');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Los permisos de ubicación están permanentemente denegados.');
    return null;
  }

  // Obtén la posición actual
  return await Geolocator.getCurrentPosition();
}
