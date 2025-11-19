import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/products/detail/client_product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

class ClientProductDetailPage extends StatelessWidget {
  late ClientProductDetailController con;

  var counter = 0.obs;
  var price = 0.0.obs;

  Product? product;
  ClientProductDetailPage({@required this.product}) {
    con = Get.put(ClientProductDetailController());
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductWasAdded(product!, price, counter);
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(height: 100, child: _buttonsAddToBag()),
        body: Column(
          children: [
            _imageSlideshow(context),
            _textNameProduct(),
            _textDescriptionProduct(),
            _textPriceProduct(),
          ],
        ),
      ),
    );
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 30, right: 30, left: 30),
      child: Text(
        product!.name ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 30, right: 30, left: 30),
      child: Text(product!.description ?? '', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 15, right: 30, left: 30),
      child: Text(
        'S/. ${product!.price.toString() ?? ''}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buttonsAddToBag() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300], indent: 30, endIndent: 30),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ), // Agrega margen a ambos lados del contenedor

          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => con.removeItem(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(40, 37),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                ),
                child: const Text(
                  '-',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(40, 37),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
                child: Text(
                  '${counter.value}',
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              ElevatedButton(
                onPressed: () => con.addItem(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(40, 37),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => con.addToBag(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Agregar ${price.value}',
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageSlideshow(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: ImageSlideshow(
        initialPage: 0,
        indicatorColor: Colors.amber,
        indicatorBackgroundColor: Colors.grey[200],
        children: [
          FadeInImage(
            fit: BoxFit.cover, // Ajuste para cubrir todo el contenedor
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/jar-loading.gif'),
            image: product!.image1 != null
                ? NetworkImage(product!.image1!)
                : AssetImage('assets/img/jar-loading.gif') as ImageProvider,
          ),
          FadeInImage(
            fit: BoxFit.cover, // Ajuste para cubrir todo el contenedor
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/jar-loading.gif'),
            image: product!.image2 != null
                ? NetworkImage(product!.image2!)
                : AssetImage('assets/img/jar-loading.gif') as ImageProvider,
          ),
          FadeInImage(
            fit: BoxFit.cover, // Ajuste para cubrir todo el contenedor
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/jar-loading.gif'),
            image: product!.image3 != null
                ? NetworkImage(product!.image3!)
                : AssetImage('assets/img/jar-loading.gif') as ImageProvider,
          ),
        ],
      ),
    );
  }
}
