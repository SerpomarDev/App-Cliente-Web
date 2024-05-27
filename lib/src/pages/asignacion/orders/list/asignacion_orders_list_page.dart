import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/list/asignacion_orders_list_controller.dart';
import 'package:serpomar_client/src/utils/relative_time_util.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AsignacionOrdersListPage extends StatelessWidget {
  final AsignacionOrdersListController con = Get.put(AsignacionOrdersListController());

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
                indicatorColor: Colors.blue,
                labelColor: Colors.blueAccent,
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

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "Fecha no disponible";
    }
    final DateFormat formatter = DateFormat('dd-MM-yyyy - HH:mm:ss');
    return formatter.format(dateTime);
  }

  String getDestinationReachedMessage(int? destinationReached) {
    switch (destinationReached) {
      case 1:
        return 'Destino 1 - OK';
      case 2:
        return 'En planta y/o punto Dos - OK';
      case 3:
        return 'Punto Final - OK';
      default:
        return 'Por salir';
    }
  }


  Widget _cardOrder(Order order) {
    var now = DateTime.now();
    var orderTime = DateTime.fromMillisecondsSinceEpoch(order.timestamp ?? 0);
    var difference = now.difference(orderTime);
    Color backgroundColor = Colors.white;

    // Determinar el color de fondo basado en el estado de la orden
    switch (order.status) {
      case 'EN RUTA':
        backgroundColor = Colors.lightGreenAccent;
        break;
      case 'FINALIZADOS':
        backgroundColor = Colors.lightBlueAccent;
        break;
      case 'ASIGNADOS':
        break;
      default:
        if (difference.inMinutes >= 8) {
          backgroundColor = Colors.red;
        } else if (difference.inMinutes >= 4) {
          backgroundColor = Colors.orange;
        }
        break;
    }

    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 220,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Card(
          color: backgroundColor,
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajusta el contenido para distribuir espacio uniformemente
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
                    Text('Asignado el: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}'),
                    Text('Asignado por: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}'),
                    Text('Nro. Consigna: ${order.address?.address ?? ''}'),
                    Text('Cita en puerto: ${order.citaPuerto ?? 'No Necesita/No disponible'}'),
                    Text(order.status == 'FINALIZADOS' ? 'Finalizado el: ${formatDateTime(order.update_at)}' : 'Estado del pedido: En progreso'),
                  ],
                ),
              ),
              // Mensaje de destinationReached centrado en la parte inferior
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20), // Agrega un poco de espacio en la parte inferior
                  child: Text(
                    'Estado: ${getDestinationReachedMessage(order.destinationReached)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,  // Color más llamativo para resaltar
                      fontSize: 20,  // Tamaño de fuente más grande
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}


