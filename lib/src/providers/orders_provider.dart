import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';

class OrdersProvider extends GetConnect {

  String url = Enviroment.API_URL + 'api/orders';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get(
        '$url/findByStatus/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    return Order.fromJsonList(response.body);
  }

  Future<List<Order>> findByDeliveryAndStatus(String idDelivery, String status) async {
    Response response = await get(
        '$url/findByDeliveryAndStatus/$idDelivery/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    return Order.fromJsonList(response.body);
  }

  Future<List<Order>> findByClientAndStatus(String idClient, String status) async {
    Response response = await get(
        '$url/findByClientAndStatus/$idClient/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    return Order.fromJsonList(response.body);
  }

  Future<ResponseApi> create(Order order) async {
    Response response = await post(
        '$url/create',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToDispatched(Order order) async {
    Response response = await put(
        '$url/updateToDispatched',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response response = await put(
        '$url/updateToOnTheWay',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    Response response = await put(
        '$url/updateToDelivered',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response response = await put(
        '$url/updateLatLng',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<Map<String, int>> countRequestsByDay() async {
    Map<String, int> requestsByDay = {};

    Response response = await get(
        '$url/countRequestsByDay',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.body;
      for (var entry in data) {
        requestsByDay[entry['request_date']] = entry['request_count'];
      }
    }

    return requestsByDay;
  }

  Future<List<Order>> findByDateRange(String startDate, String endDate) async {
    Response response = await get(
        '$url/findByDateRange/$startDate/$endDate',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    } else if (response.statusCode != 200) {
      Get.snackbar('Error', 'No se pudo obtener las ordenes para el rango de fechas');
      return [];
    }

    return Order.fromJsonList(response.body);
  }

  Future<Map<int, int>> getDestinationReachedCounts() async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Response response = await get(
        '$url/destinationreachedcounts?date=$currentDate',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.body['data'];
      Map<int, int> counts = {};
      for (var entry in data) {
        counts[entry['destinationReached']] = entry['total'];
      }
      return counts;
    } else {
      throw Exception('Failed to load destination counts');
    }
  }
}
