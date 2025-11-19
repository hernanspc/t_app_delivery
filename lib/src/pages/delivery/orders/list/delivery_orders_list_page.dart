import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:delivery_app/src/utils/relative_time_util.dart';
import 'package:delivery_app/src/widgets/loader_widget.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOrdersListPage extends StatelessWidget {
  DeliveryOrderListController con = Get.put(DeliveryOrderListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: con.status.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(con.status.length, (index) {
                  return Tab(child: Text(con.status[index]));
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: con.status.map((String status) {
              return FutureBuilder(
                future: con.getOrders(status),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _cardOrder(snapshot.data![index]);
                        },
                      );
                    } else {
                      return NoDataWidget(
                        text: "No hay productos disponibles, por el momento..",
                      );
                    }
                  } else {
                    return LoaderWidget(text: "Cargando productos.");
                    ;
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 15, right: 20, top: 10),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Order #${order.id}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pedido:  ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cliente:  ${order.client?.name ?? ''}  ${order.client?.lastname ?? ''}',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Entregar en:  ${order.address?.address ?? ''} ',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
