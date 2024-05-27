import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/pages/conductor/orders/detail/conductor_orders_detail_controller.dart';


import 'package:serpomar_client/src/utils/relative_time_util.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class ConductorOrdersDetailPage extends StatelessWidget {

  ConductorOrdersDetailController con = Get.put(ConductorOrdersDetailController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height * 0.58,
        // padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            _citaDate(),
            _dataDate(),
            _dataClient(),
            _dataAddress(),
            _finallyDate(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'ASIGNACION #${con.order.id}',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: con.order.products!.isNotEmpty
      ? ListView(
        children: con.order.products!.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
      : Center(
          child: NoDataWidget(text: 'No hay ningun producto agregado aun')
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


  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Asignador y Telefono'),
        subtitle: Text('${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''} - ${con.order.client?.phone ?? ''}'),
        trailing: Icon(Icons.person),
      ),
    );
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
      child: ListTile(
        title: Text('Fecha del encargo'),
        subtitle: Text('${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _citaDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          'Cita en puerto',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Hora: ${con.order.citaPuerto}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.share_arrival_time_outlined),
      ),
    );
  }

  Widget _finallyDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          'Finalizo la asignación',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          con.order.status == 'FINALIZADOS'
              ? 'Finalizado el: ${formatDateTime(con.order.update_at)}'
              : 'Finalizado el: En progreso',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.timer_off_outlined),
      ),
    );
  }



  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Descripcion: ${product.description ?? 'No asignada'}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: con.order.status == 'ENCARGOS' ? 0 : 80, top: 40),
          child: Row(
            mainAxisAlignment: con.order.status == 'ENCARGOS'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                '\$${con.total.value}',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              con.order.status == 'ASIGNADOS'
                  ? _buttonUpdateOrder()
                  : con.order.status == 'EN RUTA'
                  ? _buttonGoToOrderMap()
                  : Container()
            ],
          ),
        )

      ],
    );
  }

  Widget _buttonUpdateOrder() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: ElevatedButton(
          onPressed: () => con.updateOrder(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.cyan
          ),
          child: Text(
            'INICIAR ENTREGA',
            style: TextStyle(
              fontSize: 18,
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(25),
              foregroundColor: Colors.lightGreenAccent
          ),
          child: Text(

            'VOLVER AL MAPA',
            style: TextStyle(
                color: Colors.black,
              fontSize: 18,
            ),
          )
      ),
    );
  }
}
