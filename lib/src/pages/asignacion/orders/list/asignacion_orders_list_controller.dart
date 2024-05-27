import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';

class AsignacionOrdersListController extends GetxController {

  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['ENCARGOS', 'ASIGNADOS', 'EN RUTA', 'FINALIZADOS'].obs; // 'ENCARGOS' removido

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(status);
  }

  void goToOrderDetail (Order order) {
    Get.toNamed('/administrador/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}