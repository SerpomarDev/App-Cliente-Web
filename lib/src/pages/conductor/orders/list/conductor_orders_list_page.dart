import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/pages/conductor/orders/list/conductor_orders_list_controller.dart';
import 'package:serpomar_client/src/utils/relative_time_util.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';
import 'package:intl/intl.dart';

class ConductorOrdersListPage extends StatelessWidget {
  final ConductorOrdersListController con = Get.put(ConductorOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => DefaultTabController(
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
                tabs: con.status.map((status) => Tab(child: Text(status))).toList(),
              ),
            ),
          ),
          body: TabBarView(
            children: con.status.map(
                  (status) {
                return FutureBuilder(
                  future: con.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => _buildOrderCard(snapshot.data![index]),
                        );
                      } else {
                        return Center(child: NoDataWidget(text: 'No hay órdenes'));
                      }
                    } else {
                      return Center(child: NoDataWidget(text: 'Cargando órdenes...'));
                    }
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "Fecha no disponible";
    }
    final DateFormat formatter = DateFormat('dd-MM-yyyy - HH:mm:ss');
    return formatter.format(dateTime);
  }


  Widget _buildOrderCard(Order order) {
    // Obtener la marca de tiempo actual
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    // Calcular la diferencia en minutos
    final minutesDifference = (currentTime - (order.timestamp ?? 0)) ~/ 60000;

    // Determinar el color de fondo basado en el estado y el tiempo
    Color backgroundColor;
    if (order.status == 'FINALIZADOS') {
      backgroundColor = Colors.lightBlueAccent;
    } else if (order.status == 'EN RUTA') {
      backgroundColor = Colors.lightGreenAccent;
    } else if (minutesDifference >= 8) {
      backgroundColor = Colors.red;
    } else if (minutesDifference >= 4) {
      backgroundColor = Colors.orange;
    } else {
      backgroundColor = Colors.white;
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
                    'Encargo #${order.id}',
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
                    Text('Entregar en: ${order.address?.address ?? ''}'),
                    Text('Cita en puerto: ${order.citaPuerto}'),
                    Text(order.status == 'FINALIZADOS' ?
                    'Finalizado el: ${formatDateTime(order.update_at)}' :
                    'Finalizado el: En progreso'),
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
