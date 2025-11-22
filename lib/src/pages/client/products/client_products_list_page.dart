import 'package:delivery_app/components/common/color_extension.dart';
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
    final auth = Provider.of<AuthService>(context, listen: false);

    String saludo = "👋 Hola! ${auth.user?.usuario}";

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
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      _iconShoppingBag(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Entregando en",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "ubicación actual",
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              print("Cambiar ubicación");
                            },
                            child: Image.asset(
                              "assets/example/img/dropdown.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  (i) => Tab(child: Text(con.categorias[i].nombre)),
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
                        ? NetworkImage(product.rutaImagen)
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

class DeliveryTypeSelector extends StatefulWidget {
  const DeliveryTypeSelector({super.key});

  @override
  State<DeliveryTypeSelector> createState() => _DeliveryTypeSelectorState();
}

class _DeliveryTypeSelectorState extends State<DeliveryTypeSelector> {
  String selected = "delivery"; // "delivery" o "pickup"

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Método de entrega",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _optionCard(
              title: "Entrega a domicilio",
              subtitle: "Recibe tu pedido en tu ubicación",
              icon: Icons.delivery_dining,
              value: "delivery",
            ),
            _optionCard(
              title: "Recojo en tienda",
              subtitle: "Pasa a recoger tu pedido",
              icon: Icons.storefront,
              value: "pickup",
            ),
          ],
        ),
      ],
    );
  }

  /// 🔹 Componente reutilizable
  Widget _optionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selected == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selected = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.amber : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.amber.shade800 : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
