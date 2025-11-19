import 'dart:async';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/providers/orders_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DeliveryOrdersMapController extends GetxController {
  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-11.976272, -76.9169402),
    zoom: 17,
  );

  LatLng? addressLatLng;
  var addressName = ''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscribe;

  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];

  double distanceBetween = 0.0;
  bool isClose = false;

  DeliveryOrdersMapController() {
    print('DeliveryOrdersMapController: order ${order.toJson()}');
    checkGPS();
    connectAndListen();
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
      configuration,
      path,
    );

    return descriptor;
  }

  void addMarker(
    String markerId,
    double lat,
    double lng,
    String title,
    String content,
    BitmapDescriptor iconMarker,
  ) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
    update();
  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print(' 🤡🐽 ESTE DISPOSITIVO SE CONECTO A SOCKET IO');
    });
  }

  void emitPosition() {
    if (position != null) {
      socket.emit('position', {
        'id_order': order.id,
        'lat': position!.latitude,
        'lng': position!.longitude,
      });
    }
  }

  void emitToDelivered() {
    socket.emit('delivered', {'id_order': order.id});
  }

  Future setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if (address.isNotEmpty) {
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
      String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      String country = address[0].country ?? '';

      print('>>ubicacion datos: ${address[0].toJson()} ');
      print('>>street $street');

      addressName.value = '$direction #$street, $city, $department ';
      addressLatLng = LatLng(lat, lng);
    }
  }

  void onMapCreate(GoogleMapController controller) {
    //Night
    // controller.setMapStyle(
    //     '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');

    //Aubergine
    // controller.setMapStyle(
    //     '[{"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},{"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#64779e"}]},{"featureType":"administrative.province","elementType":"geometry.stroke","stylers":[{"color":"#4b6878"}]},{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"color":"#334e87"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#023e58"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#283d6a"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f9ba5"}]},{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#023e58"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#3C7680"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"road","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2c6675"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#b0d5ce"}]},{"featureType":"road.highway","elementType":"labels.text.stroke","stylers":[{"color":"#023e58"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},{"featureType":"transit","elementType":"labels.text.stroke","stylers":[{"color":"#1d2c4d"}]},{"featureType":"transit.line","elementType":"geometry.fill","stylers":[{"color":"#283d6a"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#3a4762"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#4e6d70"}]}]');

    controller.setMapStyle("[]");
    mapController.complete(controller);
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    deliveryMarker = await createMarkerFromAssets(
      'assets/img/delivery_little.png',
    );
    homeMarker = await createMarkerFromAssets('assets/img/home.png');

    if (isLocationEnabled == true) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    points.clear();
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);

    // PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
    //   Environment.API_KEY_MAP,
    //   pointFrom,
    //   pointTo,
    // );
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pointFrom.latitude, pointFrom.longitude),
        destination: PointLatLng(pointTo.latitude, pointTo.longitude),
        mode: TravelMode.driving, // opcional
      ),
      googleApiKey: Environment.API_KEY_MAP,
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.amber,
      points: points,
      width: 4,
    );

    polylines.add(polyline);
    update();
  }

  void isCoseToDeliveryPosition() {
    if (position != null) {
      distanceBetween = Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        order.address!.lat!,
        order.address!.lng!,
      );
    }

    if (distanceBetween <= 200 && isClose == false) {
      isClose = true;
      update();
    }
  }

  void updateToDelivered() async {
    if (distanceBetween <= 200) {
      ResponseApi responseApi = await ordersProvider.updateToDelivered(order);

      Fluttertoast.showToast(
        msg: responseApi.message ?? '',
        toastLength: Toast.LENGTH_LONG,
      );
      if (responseApi.success == true) {
        emitToDelivered();
        Get.offNamedUntil('/delivery/home', (route) => false);
      }
    } else {
      Get.snackbar(
        'Operación no permitida',
        'Debes estar mas cerca a la posicion de entrega del pedido',
      );
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getCurrentPosition();
      saveLocation();
      animateCameraPosition(
        position?.latitude ?? -11.976272,
        position?.longitude ?? -76.9169402,
      );

      addMarker(
        'delivery',
        position?.latitude ?? -11.976272,
        position?.longitude ?? -76.9169402,
        'Tu posicion',
        '',
        deliveryMarker!,
      );

      addMarker(
        'home',
        order.address?.lat ?? -11.976272,
        order.address?.lng ?? -76.9169402,
        'Lugar de entrega',
        '',
        homeMarker!,
      );

      // LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to = LatLng(
        order.address?.lat ?? -11.976272,
        order.address?.lng ?? -76.9169402,
      );
      // setPolylines(from, to);

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );

      positionSubscribe =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen((Position pos) {
            //Posicion en tiempo real.
            position = pos;

            print('🦄 2CALAMARDO ${pos.toJson()}');
            addMarker(
              'delivery',
              position?.latitude ?? -11.976272,
              position?.longitude ?? -76.9169402,
              'Tu posicion',
              '',
              deliveryMarker!,
            );
            animateCameraPosition(
              position?.latitude ?? -11.976272,
              position?.longitude ?? -76.9169402,
            );
            emitPosition();
            isCoseToDeliveryPosition();

            LatLng fromPositionSubscribe = LatLng(pos.latitude, pos.longitude);
            setPolylines(fromPositionSubscribe, to);
          });
    } catch (e) {
      print('error en $e');
    }
  }

  void callNumber() async {
    String number = order.client?.phone ?? '';
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }

  void saveLocation() async {
    if (position != null) {
      order.lat = position!.latitude;
      order.lng = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await (mapController.future);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17, bearing: 0),
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }
}
