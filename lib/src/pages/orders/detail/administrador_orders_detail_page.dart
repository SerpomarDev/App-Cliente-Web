import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/pages/orders/detail/administrador_orders_detail_controller.dart';
// import 'package:serpomar_client/src/utils/relative_time_util.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AdministradorOrdersDetailPage extends StatelessWidget {

  AdministradorOrdersDetailController con = Get.put(AdministradorOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: con.order.status == 'ENCARGOS'
            ? MediaQuery.of(context).size.height * 0.63
            : MediaQuery.of(context).size.height * 0.60,
        child: Column(
          children: [
            _citaDate(),
            _textFieldCita(),
        _totalToPay(context),
            // _dataDate(),
            _dataClient(),
            _dataAddress(),
            _dataDelivery(),
            // _finallyDate(),
            _assignOrderButton(), // Botón modificado
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'ENCARGO #${con.order.id}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: con.order.products!.isNotEmpty
          ? ListView(
        children: con.order.products!.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
          : Center(
          child: NoDataWidget(text: 'No hay ninguna asignacion solicitada aun')
      ),
    );
  }

  // String formatDateTime(DateTime? dateTime) {
  //   if (dateTime == null) {
  //     return "Fecha no disponible";
  //   }
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy - HH:mm:ss');
  //   return formatter.format(dateTime);
  // }

  Widget _textFieldCita() {
    final controller = Get.find<AdministradorOrdersDetailController>();
    controller.citaController.addListener(() {
    });

    return controller.order.status == 'ENCARGOS'
        ? Container(
      margin: EdgeInsets.fromLTRB(30, 20, 40, 0),
      child: TextField(
        controller: controller.citaController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Cita puerto',
          hintText: 'Ingresa la hora de la cita',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(Icons.watch_later),
          errorText: '', // Idealmente, este texto debería ser dinámico según la validación
        ),
      ),
    )
        : Container();
  }

  // Widget _finallyDate() {
  //   final controller = Get.find<AdministradorOrdersDetailController>();
  //
  //   // Asumiendo que quieres escuchar algún cambio específico, pero no se define aquí.
  //   controller.citaController.addListener(() {
  //     // Define la lógica que quieres ejecutar cuando el listener se activa
  //   });
  //
  //   const validStatuses = ['ASIGNADOS', 'EN RUTA', 'FINALIZADOS'];
  //
  //   return validStatuses.contains(controller.order.status)
  //       ? Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     child: ListTile(
  //       title: Text(
  //         'Terminación del encargo',
  //         style: TextStyle(
  //           fontSize: 18,
  //         ),
  //       ),
  //       subtitle: Text(
  //         // Corrección: Cambiar 'con' por 'controller'
  //         // controller.order.status == 'FINALIZADOS'
  //             // ? 'Finalizado el: ${formatDateTime(controller.order.update_at)}'
  //             : 'Finalizado el: En progreso',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       trailing: Icon(Icons.timer_off_outlined),
  //     ),
  //   )
  //       : SizedBox.shrink(); // Añadir un widget por defecto en caso de que la condición no se cumpla
  // }


  Widget _citaDate() {
    final controller = Get.find<AdministradorOrdersDetailController>();
    controller.citaController.addListener(() {
      // Aquí podrías añadir lógica si es necesario cuando el listener es activado
    });

    return controller.order.status == 'ASIGNADOS'
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



  Widget _assignOrderButton() {
    final controller = Get.find<AdministradorOrdersDetailController>();

    return controller.order.status == 'ENCARGOS'
        ? Container(
      margin: EdgeInsets.only(left: 30, top: 40, right: 30, bottom: 15),
      child: ElevatedButton(
        onPressed: () => controller.assignAndUpdateOrder(),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
        child: Text(
          'ASIGNAR ENCARGO',
          style: TextStyle(color: Colors.black),
        ),
      ),
    )
        : Container();
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

  Widget _dataDelivery() {
    return con.order.status != 'ENCARGOS'
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Conductor asignado'),
        subtitle: Text('${con.order.delivery?.name ?? ''} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? ''}'),
        trailing: Icon(Icons.drive_eta_rounded),
      ),
    )
        : Container();
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

  // Widget _dataDate() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     child: ListTile(
  //       title: Text('Fecha del encargo'),
  //       subtitle: Text('${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
  //       trailing: Icon(Icons.timer),
  //     ),
  //   );
  // }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
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
        Divider(height: 0, color: Colors.grey[300]),
        // Condición para mostrar el texto 'ASIGNAR CONDUCTOR'
        con.order.status == 'ENCARGOS'
            ? Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 30, top: 10),
          child: Text(
            'ASIGNAR CONDUCTOR',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.redAccent
            ),
          ),
        )
            : Container(),
        // Condición para mostrar el dropdown de conductores
        con.order.status == 'ENCARGOS' ? _dropDownDeliveryMen(con.users) : Container(),
      ],
    );
  }


  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 45),
      margin: EdgeInsets.only(top: 10),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.indigoAccent,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar conductor',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option) {
          print('Opcion seleccionada ${option}');
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }


  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 15),
            Text('${user.name} ${user.lastname} - ${user.placa ?? ''}'),
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }


}
