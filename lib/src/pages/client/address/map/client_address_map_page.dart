import 'dart:async';

import 'package:delivery_app/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {
  ClientAddressMapController con = Get.put(ClientAddressMapController());

  void onMapCreate(GoogleMapController controller) {}

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubica tu direccion en el mapa",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            _googleMaps(),
            _iconMyLocation(),
            _cardAdress(),
            _buttonAccept(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => con.selectRefPoint(context),
        child: Text("Seleccionar este punto"),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _cardAdress() {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            con.addressName.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Center(
        child: Image.asset(
          'assets/img/my_location_yellow.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      onMapCreated: con.onMapCreate,
      myLocationButtonEnabled: true,
      myLocationEnabled: false,
      onCameraMove: (position) {
        con.initialPosition = position;
      },
      onCameraIdle: () async {
        await con.setLocationDraggableInfo(); //Obtiene la lat y long del mapa
      },
    );
  }
}
