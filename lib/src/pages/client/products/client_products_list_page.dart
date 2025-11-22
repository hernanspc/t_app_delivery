import 'package:delivery_app/components/common/color_extension.dart';
import 'package:delivery_app/src/models/categories/categories_products_response.dart';
import 'package:delivery_app/src/pages/client/controller/client_products_list_page_controller.dart';
import 'package:delivery_app/src/pages/client/location/change_location_page.dart';
import 'package:delivery_app/src/services/auth_service.dart';
import 'package:delivery_app/src/utils/functions.dart';
import 'package:delivery_app/src/widgets/loader_widget.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:delivery_app/src/widgets/search_bar_you.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

  Position? currentPosition;
  bool isLoadingLocation = true;
  String? addressLocation;

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
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    currentPosition = await getCurrentLocation();
    print(' 📍 Ubicación actual: $currentPosition');

    final address = await getAddress(
      currentPosition?.latitude ?? 0,
      currentPosition?.longitude ?? 0,
    );

    setState(() {
      addressLocation = address;
      isLoadingLocation = false;
    });
  }

  void openLocationBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ChangeLocationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    final auth = Provider.of<AuthService>(context, listen: false);
    String saludo = "👋 Hola! ${auth.userSession?.usuario}";

    return PreferredSize(
      preferredSize: const Size.fromHeight(240),
      child: AppBar(
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        saludo,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      _iconShoppingBag(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => openLocationBottomSheet(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ícono de ubicación
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Dirección multilínea
                            Expanded(
                              child: Text(
                                addressLocation ?? "Cargando dirección...",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),

                            // Dropdown (cambiar ubicación)
                            const SizedBox(width: 10),
                            Image.asset(
                              "assets/example/img/dropdown.png",
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SearchBarYouTube(
                        onChanged: con.onChangeText,
                        onSearch: con.onChangeText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<CategoryAndProductsAll>>(
      future: con.getAllCategoriesAndProductsController(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoaderWidget(text: "Cargando categorías...");
        }

        if (snapshot.hasError) {
          return NoDataWidget(text: "Ocurrió un error al cargar.");
        }

        final categorias = snapshot.data ?? [];

        if (categorias.isEmpty) {
          return NoDataWidget(text: "No hay categorías disponibles.");
        }

        // Configuramos el TabController dinámicamente
        tabController ??= TabController(length: categorias.length, vsync: this);

        return Column(
          children: [
            TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: Colors.amber,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              tabs: categorias.map((c) => Tab(text: c.nombre)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: categorias.map((categoria) {
                  final productos = categoria.productos;

                  if (productos.isEmpty) {
                    return NoDataWidget(
                      text: "No hay productos en esta categoría.",
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: productos.length,
                    itemBuilder: (_, i) => _cardProduct(productos[i]),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
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

  Widget _cardProduct(ProductAll product) {
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
