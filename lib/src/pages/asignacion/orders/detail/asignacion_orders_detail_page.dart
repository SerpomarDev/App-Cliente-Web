import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/detail/asignacion_orders_detail_controller.dart';
import 'package:serpomar_client/src/utils/relative_time_util.dart';

class AsignacionOrdersDetailPage extends StatelessWidget {
  AsignacionOrdersDetailController con = Get.put(AsignacionOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: _bottomBar(context),
      appBar: _customAppBar(),
      body: con.order.products!.isNotEmpty ? _productList() : _noDataWidget(),
    ));
  }

  AppBar _customAppBar() {
    return AppBar(
      backgroundColor: Colors.deepOrange,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Orden #${con.order.id}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _productList() {
    return ListView.builder(
      itemCount: con.order.products!.length,
      itemBuilder: (context, index) {
        return _cardProduct(con.order.products![index]);
      },
    );
  }

  Widget _noDataWidget() {
    return Center(
      child: Text('No hay ningún producto agregado aún', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _citaDate(),
          _dataDate(),
          _dataDelivery(),
          _dataAddress(),
          _finallyDate(),
          _totalDuration(),
          _totalToPay(context),
        ],
      ),
    );
  }

  Widget _dataDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Conductor y Telefono'),
        subtitle: Text('${con.order.delivery?.name ?? 'No Asignado'} ${con.order.delivery?.lastname ?? ''} / ${con.order.delivery?.phone ?? 'xxx xxxx xxx'}'),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _citaDate() {
    final controller = Get.find<AsignacionOrdersDetailController>();
    controller.citaController.addListener(() {
      // Aquí podrías añadir lógica si es necesario cuando el listener es activado
    });

    const validStatuses = ['ASIGNADOS', 'EN RUTA', 'FINALIZADOS'];

    return validStatuses.contains(controller.order.status)
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          'Cita en puerto',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Hora: ${controller.order.citaPuerto}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.share_arrival_time_outlined),
      ),
    )
        : Container(); // Considera manejar el caso cuando el status no es 'ENCARGOS'
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega'),
        subtitle: Text(con.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _dataUpdateTime(),
          ListTile(
            title: Text('Fecha del encargo'),
            subtitle: Text('${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
            trailing: Icon(Icons.timer),
          ),
        ],
      ),
    );
  }

  Widget _dataUpdateTime() {
    return ListTile(
      title: Text('Última actualización'),
      subtitle: Text(_formatUpdateTime(con.order.update_at)),
      trailing: Icon(Icons.access_time),
    );
  }

  String _formatUpdateTime(DateTime? updateAt) {
    if (updateAt != null) {
      return '${updateAt.hour.toString().padLeft(2, '0')}:${updateAt.minute.toString().padLeft(2, '0')}';
    } else {
      return 'Hora por confirmar'; // O cualquier otro texto que quieras mostrar si update_at es nulo
    }
  }

  Widget _cardProduct(Product product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[200], // Color de fondo gris
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10), // Espacio horizontal entre la imagen y el texto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ruta: ${product.selectedRoute ?? ''}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Descripción: ${product.description ?? 'No asignada'}'),
                    Text('Cantidad de contenedores: ${product.quantity?.toString() ?? 'No asignada'}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio vertical entre los grupos de texto
          ],
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 20, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: con.order.status == 'EN RUTA' ? 0 : 0, top: 10),
          child: Row(
            mainAxisAlignment: con.order.status == 'EN camino'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                '\$${con.total.value}',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              con.order.status == 'EN RUTA'
                  ? _buttonGoToOrderMap()
                  : con.order.status == 'FINALIZADOS'
                  ? _buttonGoToGalery()
                  : Container()
            ],
          ),
        )

      ],
    );
  }

  Widget _buttonGoToGalery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.goToOrderGalery(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.lightGreenAccent
          ),
          child: Text(

            'VER IMAGENES',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          )
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


  Widget _finallyDate() {
    final controller = Get.find<AsignacionOrdersDetailController>();

    // Asumiendo que quieres escuchar algún cambio específico, pero no se define aquí.
    controller.citaController.addListener(() {
      // Define la lógica que quieres ejecutar cuando el listener se activa
    });

    const validStatuses = ['ASIGNADOS', 'EN RUTA', 'FINALIZADOS'];

    return validStatuses.contains(controller.order.status)
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          'Terminación del encargo',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          // Corrección: Cambiar 'con' por 'controller'
          controller.order.status == 'FINALIZADOS'
              ? 'Finalizado el: ${formatDateTime(controller.order.update_at)}'
              : 'Finalizado el: En progreso',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.timer_off_outlined),
      ),
    )
        : SizedBox.shrink(); // Añadir un widget por defecto en caso de que la condición no se cumpla
  }

  Widget _totalDuration() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Duración total de la ruta'),
        subtitle: Text(con.getDuration()),
        trailing: Icon(Icons.hourglass_full),
      ),
    );
  }


  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 55, vertical: 50),
      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.redAccent
          ),
          child: Text(
            'RASTREAR PEDIDO',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          )
      ),
    );
  }
}