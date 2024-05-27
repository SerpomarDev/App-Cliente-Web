import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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

  // Método para actualizar el estado de isCitaFilled
  void checkCitaField() {
    isCitaFilled.value = citaController.text.isNotEmpty;
  }

  TextEditingController citaController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  AdministradorOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getDeliveryMen();
    getTotal();
  }

  void assignAndUpdateOrder() async {
    String citaPuerto = citaController.text;
    order.citaPuerto = citaPuerto;

    if (idDelivery.value != '') {
      order.idDelivery = idDelivery.value;

      try {
        ResponseApi responseApi = await ordersProvider.updateToDispatched(order);
        // Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
        print('Response: ${responseApi.toJson()}');

        if (responseApi.success == true) {
          Get.offNamedUntil('/administrador/home', (route) => false);
        }
      } catch (e) {
        print('Error: $e');
        // Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Get.snackbar('Peticion denegada', 'Debes asignar el CONDUCTOR y la CITA');
    }
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
