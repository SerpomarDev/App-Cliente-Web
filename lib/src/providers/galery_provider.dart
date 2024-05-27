import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/galeries.dart';
import 'package:path/path.dart';
import 'package:serpomar_client/src/models/user.dart';

class GaleryProvider extends GetConnect {
  final dio.Dio dioClient = dio.Dio();
  final String url = Enviroment.API_URL + 'api/galeries/';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Galeries>> findByCategory(String id_category_galeries) async {
    try {
      final response = await dioClient.get(
        '${url}findByCategory/$id_category_galeries',
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userSession.sessionToken ?? '',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Data received: ${response.data}");
        return Galeries.fromJsonList(response.data);
      } else {
        print("Failed to fetch data: ${response.statusCode}");
        return [];
      }
    } on dio.DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }


  Future<List<Galeries>> findByNameAndCategory(String id_category_galeries, String name) async {
    try {
      final response = await dioClient.get(
        '$url/findByNameAndCategory/$id_category_galeries/$name',
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userSession.sessionToken ?? '',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Galeries.fromJsonList(response.data);
      } else if (response.statusCode == 401) {
        Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      }
    } on dio.DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.response?.statusMessage}');
    } catch (e) {
      print('Unexpected error: $e');
    }
    return [];
  }

  Future<Stream> create(Galeries galeries, List<File> images) async {
    dio.FormData formData = dio.FormData();

    for (var image in images) {
      formData.files.add(MapEntry(
        'image',
        await dio.MultipartFile.fromFile(image.path, filename: basename(image.path)),
      ));
    }

    formData.fields.add(MapEntry('galeries', json.encode(galeries.toJson())));

    try {
      final response = await dioClient.post(
        '${Enviroment.API_URL}api/galeries/create',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': userSession.sessionToken ?? '',
          },
        ),
      );

      return Stream.value(utf8.encode(response.data.toString()));
    } catch (e) {
      print('Error during the upload: $e');
      return const Stream.empty();
    }
  }


}
