import 'package:get/get.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';

class AdministradorOrdersListController extends GetxController {

  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['ENCARGOS', 'ASIGNADOS', 'EN RUTA', 'FINALIZADOS'].obs;


  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(status);
  }

  void goToOrderDetail (Order order) {
    Get.toNamed('/administrador/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}
