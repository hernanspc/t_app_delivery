import 'package:delivery_app/src/models/product/product.dart';
import 'package:delivery_app/src/pages/client/controller/client_products_list_page_controller.dart';
import 'package:delivery_app/src/services/auth_service.dart';
import 'package:delivery_app/src/widgets/loader_widget.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:delivery_app/src/widgets/search_bar_you.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final auth = Provider.of<AuthService>(context, listen: false);

    con = ClientProductsListPageController(auth);

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

    // Escucha cada vez que se cambia el tab
    tabController?.addListener(() {
      if (tabController!.indexIsChanging == false) {
        final currentIndex = tabController!.index;
        final category = con.categorias[currentIndex];

        print("👉 Cambiaste al TAB: ${category.nombre}");
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchBarYouTube(
                        onChanged: con.onChangeText,
                        onSearch: con.onChangeText,
                      ),
                    ),
                    _iconShoppingBag(),
                  ],
                ),
              ],
            ),
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

    return RefreshIndicator(
      onRefresh: () async {
        await con.reloadCategories();
        setState(() {});
        print('🔄 Categorías recargadas');
      },
      child: TabBarView(
        controller: tabController,
        children: con.categorias.map((category) {
          return ValueListenableBuilder(
            valueListenable: con.productName,
            builder: (_, __, ___) {
              return FutureBuilder<List<Product>>(
                future: con.getProducts(category.id),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoaderWidget(text: "Cargando productos...");
                  }

                  if (snapshot.hasError) {
                    return NoDataWidget(text: "Ocurrió un error al cargar.");
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return NoDataWidget(text: "No hay productos disponibles.");
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: products.length,
                    itemBuilder: (_, i) => _cardProduct(products[i]),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
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

  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () => con.openBottomSheet(context, product),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ListTile(
              title: Text(product.nombre ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    product.descripcion ?? "",
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "S/. ${product.precio}",
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
                    image: (product.rutaImagen != null)
                        ? NetworkImage(product.rutaImagen!)
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
