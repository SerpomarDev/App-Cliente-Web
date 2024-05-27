import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';
import 'package:serpomar_client/src/providers/users_provider.dart';

class AsignacionOrdersDetailController extends GetxController {

  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

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

  TextEditingController citaController = TextEditingController();

  AsignacionOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getTotal();
  }

  void goToOrderGalery() {
    Get.toNamed('/asignacion/orders/galery', arguments: {
      'order': order.toJson()
    });
  }

  void goToOrderMap() {
    Get.toNamed('/asignacion/orders/map', arguments: {
      'order': order.toJson()
    });
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity!);
    });
  }

}