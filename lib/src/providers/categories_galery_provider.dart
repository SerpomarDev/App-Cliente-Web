import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';


class Categories_galeryProvider extends GetConnect {

  String url = Enviroment.API_URL + 'api/categories_galery';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<CategoryGaleries>> getAll() async {
    Response response = await get(
        '$url/getAll',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<CategoryGaleries> categories_galery = CategoryGaleries.fromJsonList(response.body);

    return categories_galery;
  }

  Future<ResponseApi> create(CategoryGaleries categoryGaleries) async {
    Response response = await post(
        '$url/create',
        categoryGaleries.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}