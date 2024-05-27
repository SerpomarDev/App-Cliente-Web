import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';

class ConductorOrdersListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['ASIGNADOS', 'EN RUTA', 'FINALIZADOS'].obs;
  Map<String, RxList<Order>> ordersData = {};

  User user = User.fromJson(GetStorage().read('user') ?? {});

  @override
  void onInit() {
    super.onInit();
    // Inicializar el mapa con listas vacías para cada estado
    for (var state in status) {
      ordersData[state] = <Order>[].obs;
    }
  }

  bool isDataLoadedForStatus(String status) {
    return ordersData[status]?.isNotEmpty ?? false;
  }

  void loadOrdersForStatus(String status) async {
    if (!isDataLoadedForStatus(status)) {
      var orders = await getOrders(status);
      ordersData[status]?.value = orders;
    }
  }

  List<Order> ordersForStatus(String status) {
    return ordersData[status]?.value ?? [];
  }

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByDeliveryAndStatus(user.id ?? '0', status);
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/conductor/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}
