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

  late Future<List<CategoryAndProductsAll>> categoriasFuture;
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    con = ClientProductsListPageController(auth);

    // 🔹 solo se llama 1 vez al API
    categoriasFuture = con.getAllCategoriesAndProductsController();

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
      preferredSize: const Size.fromHeight(200),
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
      future: categoriasFuture, // 🔹 usamos el future cacheado
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

        final selectedCategory = categorias[selectedCategoryIndex];
        final productos = selectedCategory.productos;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Chips horizontales
            SizedBox(
              height: 100, // altura máxima del chip
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categorias.length,
                itemBuilder: (_, index) {
                  final category = categorias[index];
                  final isSelected = index == selectedCategoryIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index; // solo cambia el índice
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.amber : Colors.grey[400]!,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: category.rutaImagen != null
                                ? Image.network(
                                    category.rutaImagen!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              'assets/img/no-image.png',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                  )
                                : Image.asset(
                                    'assets/img/no-image.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              category.nombre,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 🔹 Lista de productos
            Expanded(
              child: productos.isEmpty
                  ? NoDataWidget(text: "No hay productos en esta categoría.")
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: productos.length,
                      itemBuilder: (_, i) => _cardProduct(productos[i]),
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

  Widget _buildCategoryChips(List<CategoryAndProductsAll> categorias) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: categorias.length,
        itemBuilder: (_, index) {
          final category = categorias[index];
          final isSelected = index == selectedCategoryIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.grey[400]!,
                ),
              ),
              child: Row(
                children: [
                  if (category.rutaImagen != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        category.rutaImagen!,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (category.rutaImagen != null) const SizedBox(width: 8),
                  Text(
                    category.nombre,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
