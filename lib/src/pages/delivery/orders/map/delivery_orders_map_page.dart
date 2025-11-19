import 'package:delivery_app/src/pages/delivery/orders/map/delivery_orders_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryOrdersMapPage extends StatelessWidget {
  DeliveryOrdersMapController con = Get.put(DeliveryOrdersMapController());

  void onMapCreate(GoogleMapController controller) {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryOrdersMapController>(
      builder: (value) => Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _googleMaps(),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buttonBack(), _iconCenterMyLocation()],
                  ),
                  Spacer(),
                  _cardOrderInfo(context),
                ],
              ),
            ),
            _buttonAccept(context),
          ],
        ),
      ),
    );
  }

  Widget _cardOrderInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3),
        //   )
        // ],
      ),
      child: Column(
        children: [
          _listTileAddress(
            '${con.order.address?.neighborhood}',
            'Barrio',
            Icons.location_history,
          ),
          _listTileAddress(
            '${con.order.address?.address}',
            'Direccion',
            Icons.location_on,
          ),
          Divider(color: Colors.white, endIndent: 30, indent: 30),
          _clientInfo(),
        ],
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageClient(),
          SizedBox(width: 15),
          Text(
            '${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: IconButton(
              onPressed: () => con.callNumber(),
              icon: Icon(Icons.phone, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageClient() {
    return Container(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          image: con.order.client!.image != null
              ? NetworkImage(con.order.client!.image!)
              : const AssetImage('assets/img/no-image.png') as ImageProvider,
          // placeholder: AssetImage('assets/img/no-image.png'),
          placeholder: const AssetImage('assets/img/jar-loading.gif'),
        ),
      ),
    );
  }

  Widget _listTileAddress(String title, String subTitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 13, color: Colors.white)),
        subtitle: Text(
          subTitle,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
        trailing: Icon(iconData, color: Colors.white),
      ),
    );
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => con.isClose == true ? con.updateToDelivered() : null,
        child: Text("ENTREGAR PEDIDO"),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _iconCenterMyLocation() {
    return (GestureDetector(
      onTap: () => con.centerPosition(),
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buttonBack() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 13),
      child: Stack(
        children: [
          Container(
            width: 50, // Ancho del círculo
            height: 50, // Alto del círculo
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[900]!.withOpacity(0.5),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      onMapCreated: con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(con.markers.values),
      polylines: con.polylines,
    );
  }
}
