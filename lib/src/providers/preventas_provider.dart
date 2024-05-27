import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/preventas.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';

class PreventasProvider extends GetConnect {
  String url = Enviroment.API_URL + 'api/preventas';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Preventas>> findByUser(String idUser) async {
    Response response = await get(
      '$url/findByUser/$idUser',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Preventas> preventas = (response.body as List).map((e) => Preventas.fromJson(e)).toList();
    return preventas;
  }

  Future<ResponseApi> create(Preventas preventa) async {
    Response response = await post(
      '$url/create',
      preventa.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Preventas>> getAllPreventas() async {
    Response response = await get(
      '$url/getAll',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      },
    );

    if (response.statusCode == 200) {
      List<Preventas> preventas = (response.body as List).map((e) => Preventas.fromJson(e)).toList();
      return preventas;
    } else {
      return [];
    }
  }

}
