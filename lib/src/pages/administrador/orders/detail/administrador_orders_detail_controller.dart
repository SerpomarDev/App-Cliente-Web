import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';
import 'package:serpomar_client/src/providers/users_provider.dart';

class AdministradorOrdersDetailController extends GetxController {

  Order order = Order.fromJson(Get.arguments['order']);


  var total = 0.0.obs;
  var idDelivery = ''.obs;
  var isCitaFilled = false.obs; // Nueva variable para rastrear si la cita está llena
  var idPlaca = ''.obs; // Variable para almacenar la placa seleccionada



  // Método para actualizar el estado de isCitaFilled
  void checkCitaField() {
    isCitaFilled.value = citaController.text.isNotEmpty;
  }

  String getDuration() {
    if (order.timestamp != null && order.update_at != null) {
      final startTime = DateTime.fromMillisecondsSinceEpoch(order.timestamp!);
      final endTime = DateTime.fromMillisecondsSinceEpoch(order.update_at!.millisecondsSinceEpoch);
      final duration = endTime.difference(startTime);
      return '${duration.inHours} horas, ${duration.inMinutes % 60} minutos';
    } else {
      return 'No disponible';
    }
  }

  // void getPlacas() async {
  //   // var result = await placasProvider.getPlacas();
  //   placas.clear();
  //   placas.addAll(result);
  // }

  TextEditingController citaController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  AdministradorOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getDeliveryMen();
    getTotal();
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371; // Radio de la Tierra en kilómetros
    double dLat = _toRadians(lat2 - lat1);
    double dLng = _toRadians(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  String getTotalDistance() {
    if (order.lat != null && order.lng != null && order.lat2 != null && order.lng2 != null) {
      double totalDistance = 0.0;

      // Calcula la distancia entre el punto inicial y el segundo punto
      totalDistance += calculateDistance(order.lat!, order.lng!, order.lat2!, order.lng2!);

      // Si hay tercer punto, suma esa distancia
      if (order.lat3 != null && order.lng3 != null) {
        totalDistance += calculateDistance(order.lat2!, order.lng2!, order.lat3!, order.lng3!);
      }

      return '${totalDistance.toStringAsFixed(2)} km';
    } else {
      return 'No disponible';
    }
  }


  void assignAndUpdateOrder() async {
    String citaPuerto = citaController.text;
    order.citaPuerto = citaPuerto;

    if (idDelivery.value != '') {
      order.idDelivery = idDelivery.value;

      try {
        ResponseApi responseApi = await ordersProvider.updateToDispatched(order);
        Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
        print('Response: ${responseApi.toJson()}');

        if (responseApi.success == true) {
          Get.offNamedUntil('/administrador/home', (route) => false);
        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Get.snackbar('Peticion denegada', 'Debes asignar el CONDUCTOR y la CITA');
    }
  }

  void goToOrderMap() {
    Get.toNamed('/asignacion/orders/map', arguments: {
      'order': order.toJson()
    });
  }

  void goToOrderGalery() {
    Get.toNamed('/asignacion/orders/galery', arguments: {
      'order': order.toJson()
    });
  }

  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity!);
    });
  }
}
