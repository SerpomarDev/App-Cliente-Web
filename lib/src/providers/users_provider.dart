import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:dio/dio.dart';

class UsersProvider {
  String url = Enviroment.API_URL + 'api/users';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<Response> create(User user) async {
    var dioClient = Dio();
    Response response = await dioClient.post(
      '$url/create',
      data: user.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json'
        },
      ),
    );
    return response;
  }

  Future<List<User>> findDeliveryMen() async {
    var dioClient = Dio();
    Response response = await dioClient.get(
      '$url/findDeliveryMen',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        },
      ),
    );

    if (response.statusCode == 401) {
      print('Petición denegada: Tu usuario no tiene permitido leer esta información');
      return [];
    }

    List<User> users = User.fromJsonList(response.data);
    return users;
  }

  Future<ResponseApi> update(User user) async {
    var dioClient = Dio();
    Response response = await dioClient.put(
      '$url/updateWithoutImage',
      data: user.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        },
      ),
    );

    if (response.data == null) {
      print('Error: No se pudo actualizar la información');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      print('Error: No estás autorizado para realizar esta petición');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.data);
    return responseApi;
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    var dioClient = Dio();
    Response response = await dioClient.put(
      '$url/updateNotificationToken',
      data: {
        'id': id,
        'token': token
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        },
      ),
    );

    if (response.data == null) {
      print('Error: No se pudo actualizar la información');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      print('Error: No estás autorizado para realizar esta petición');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.data);
    return responseApi;
  }

  Future<Response> createWithImage(User user, File image) async {
    var dioClient = Dio();
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: basename(image.path)),
      'user': json.encode(user.toJson())
    });
    Response response = await dioClient.post(
      '$url/createWithImage',
      data: formData,
    );
    return response;
  }

  Future<Stream> updateWithImage(User user, File image) async {
    var dioClient = Dio();
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: basename(image.path)),
      'user': json.encode(user.toJson())
    });
    Response response = await dioClient.put(
      '$url/update',
      data: formData,
      options: Options(
        headers: {
          'Authorization': userSession.sessionToken ?? ''
        },
      ),
    );
    return response.data.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> login(String email, String password) async {
    var dioClient = Dio();
    Response response = await dioClient.post(
      '$url/login',
      data: {
        'email': email,
        'password': password
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json'
        },
      ),
    );

    if (response.data == null) {
      print('Error: No se pudo ejecutar la petición');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      print('Error: Credenciales incorrectas');
      return ResponseApi(success: false, message: 'Credenciales incorrectas');
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.data);
    return responseApi;
  }
}
