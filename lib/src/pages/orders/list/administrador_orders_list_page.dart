import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/pages/orders/list/administrador_orders_list_controller.dart';
import 'package:serpomar_client/src/utils/relative_time_util.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';
// import 'package:intl/intl.dart';


class AdministradorOrdersListPage extends StatelessWidget {

  AdministradorOrdersListController con = Get.put(AdministradorOrdersListController());

  @override
  Widget build(BuildContext context) {

    return Obx(() => DefaultTabController(
      length: con.status.length,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(con.status.length, (index) {
                  return Tab(
                    child: Text(con.status[index]),
                  );
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
                            }
                        );
                      }
                      else {
                        return Center(child: NoDataWidget(text: 'No hay ordenes'));
                      }
                    }
                    else {
                      return Center(child: NoDataWidget(text: 'No hay ordenes'));
                    }
                  }
              );
            }).toList(),
          )
      ),
    ));
  }

  // String formatDateTime(DateTime? dateTime) {
  //   if (dateTime == null) {
  //     return "Fecha no disponible";
  //   }
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy - HH:mm:ss');
  //   return formatter.format(dateTime);
  // }

  Widget _cardOrder(Order order) {
    // Calculando el tiempo transcurrido
    var now = DateTime.now();
    var orderTime = DateTime.fromMillisecondsSinceEpoch(order.timestamp ?? 0);
    var difference = now.difference(orderTime);

    // Determinando el color de fondo basado en el estado de la orden
    Color backgroundColor = Colors.white; // Color por defecto: blanco

    switch (order.status) {
      case 'EN RUTA':
        backgroundColor = Colors.lightGreenAccent; // Verde para órdenes 'EN RUTA'
        break;
      case 'FINALIZADOS':
        backgroundColor = Colors.lightBlueAccent; // Azul para órdenes 'FINALIZADOS'
        break;
      case 'ASIGNADOS':
      // Mantener blanco para órdenes 'ASIGNADOS'
        break;
      default:
      // Cambiar el color por tiempo transcurrido si no es ninguno de los estados anteriores
        if (difference.inMinutes >= 8) {
          backgroundColor = Colors.red; // Rojo si han pasado 8 minutos o más
        } else if (difference.inMinutes >= 4) {
          backgroundColor = Colors.orange; // Naranja si han pasado 4 minutos o más
        }
        break;
    }

    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 170,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Card(
          color: backgroundColor, // Usar el color de fondo
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'ORDEN #${order.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Asignado el: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}'),
                    Text('Asignado por: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}'),
                    Text('Entregar en: ${order.address?.address ?? ''}'),
                    Text('Cita en puerto: ${order.citaPuerto ?? 'Sin asignar'}'),
                    // Text(order.status == 'FINALIZADOS' ?
                    // 'Finalizado el: ${formatDateTime(order.update_at)}' :
                    // 'Finalizado el: En progreso'),
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

