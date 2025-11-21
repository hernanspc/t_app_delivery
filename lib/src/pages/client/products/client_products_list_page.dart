import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/controller/client_products_list_page_controller.dart';
import 'package:delivery_app/src/widgets/loader_widget.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({super.key});

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage>
    with SingleTickerProviderStateMixin {
  late ClientProductsListPageController con;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    con = ClientProductsListPageController();

    con.addListener(() {
      if (mounted) {
        setState(() {
          if (con.categorias.isNotEmpty) {
            tabController = TabController(
              length: con.categorias.length,
              vsync: this,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            child: Wrap(children: [_textFieldSearch(), _iconShoppingBag()]),
          ),
        ),
        bottom: tabController == null
            ? null
            : TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List.generate(
                  con.categorias.length,
                  (i) => Tab(child: Text(con.categorias[i].nombre ?? "")),
                ),
              ),
      ),
    );
  }

  Widget _buildBody() {
    if (tabController == null) {
      return LoaderWidget(text: "Cargando categorías...");
    }

    return TabBarView(
      controller: tabController,
      children: List.generate(con.categorias.length, (index) {
        final category = con.categorias[index];

        return ValueListenableBuilder(
          valueListenable: con.productName,
          builder: (_, __, ___) {
            return FutureBuilder<List<Product>>(
              future: con.getProducts(
                category.id.toString(),
                con.productName.value,
              ),
              builder: (_, snap) {
                print('snap $snap');
                // 👉 1. Cargando
                if (snap.connectionState == ConnectionState.waiting) {
                  return LoaderWidget(text: "Cargando productos...");
                }

                // 👉 2. Error
                if (snap.hasError) {
                  return NoDataWidget(text: "Ocurrió un error al cargar.");
                }

                // 👉 3. Respuesta nula o lista vacía
                if (!snap.hasData || snap.data!.isEmpty) {
                  return NoDataWidget(text: "No hay productos disponibles.");
                }

                // 👉 4. Hay productos
                final products = snap.data!;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) => _cardProduct(products[i]),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _iconShoppingBag() {
    return SafeArea(
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(EvaIcons.shoppingCartOutline, size: 30),
            onPressed: () => con.goToOrderCreate(context),
          ),
          if (con.items > 0)
            Positioned(
              top: 5,
              left: 25,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${con.items}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _textFieldSearch() {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: con.onChangeText,
          decoration: InputDecoration(
            hintText: "Buscar producto",
            suffixIcon: const Icon(Icons.search, color: Colors.grey),
            hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () => con.openBottomSheet(context, product),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ListTile(
              title: Text(product.name ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    product.description ?? "",
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "S/. ${product.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 70,
                  width: 60,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 50),
                    image: (product.image1 != null)
                        ? NetworkImage(product.image1!)
                        : const AssetImage('assets/img/no-image.png')
                              as ImageProvider,
                    placeholder: const AssetImage('assets/img/jar-loading.gif'),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[300],
            indent: 30,
            endIndent: 30,
          ),
        ],
      ),
    );
  }
}
