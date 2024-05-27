import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:dio/dio.dart' as dio;
import 'package:serpomar_client/src/models/user.dart';
import 'package:path/path.dart';
import '../models/order.dart';

class ProductsProvider extends GetConnect {
  String url = Enviroment.API_URL + 'api/products';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Product>> findByCategory(String idCategory) async {
    Response response = await get(
        '$url/findByCategory/$idCategory',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }

  Future<List<Product>> findByNameAndCategory(String idCategory, String name) async {
    Response response = await get(
        '$url/findByNameAndCategory/$idCategory/$name',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }

  Future<dio.Response> create(Product product, List<File> images) async {
    var dioClient = dio.Dio();
    dio.FormData formData = dio.FormData();

    // Add images as multipart files
    for (var image in images) {
      formData.files.add(MapEntry(
        'image',
        await dio.MultipartFile.fromFile(
            image.path, filename: basename(image.path)),
      ));
    }

    // Add the attachment URL and other product data as form fields
    if (product.attachmentUrl != null) {
      formData.fields.add(MapEntry('attachment_url', product.attachmentUrl!));
    }
    if (product.containerTypes != null) {
      formData.fields.add(MapEntry('container_types', product.containerTypes!));
    }
    product.idUserCreator = userSession.id;
    formData.fields.add(MapEntry('product', json.encode(product.toJson())));
    formData.fields.add(MapEntry('remision', product.remision ?? ''));
    formData.fields.add(
        MapEntry('expiration_date', product.expirationDate ?? ''));
    formData.fields.add(MapEntry('loading_date', product.loadingDate ?? ''));
    formData.fields.add(
        MapEntry('num_containers', product.numContainers.toString()));
    // Add the DO field to the formData
    formData.fields.add(MapEntry('do_number', product.doNumber ?? ''));

    dio.Response response = await dioClient.post(
      '$url/create',
      data: formData,
      options: dio.Options(headers: {
        'Authorization': userSession.sessionToken ?? '',
      }),
    );

    return response;
  }

  Future<Map<String, int>> countRequestsByCategory() async {
    Map<String, int> categoryCounts = {
      '1': 0, // Importación
      '2': 0, // Exportación
      '3': 0, // Retiro de Vacío
      '4': 0, // Traslado
    };

    for (String categoryId in categoryCounts.keys) {
      List<Product> products = await findByCategory(categoryId);
      categoryCounts[categoryId] = products.length;
    }

    return categoryCounts;
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

  Future<int> countTotalContainers() async {
    Response response = await get(
        '$url/countTotalContainers',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 200) {
      return response.body['total_containers'];
    } else {
      return 0;
    }
  }

  Future<dio.Response> updateProductAssignedStatus(String productId, bool isAssigned) async {
    var dioClient = dio.Dio();
    dio.Response response = await dioClient.patch(
      '$url/updateAssignedStatus/$productId', // Corrected URL
      data: {
        'is_assigned': isAssigned
      },
      options: dio.Options(headers: {
        'Authorization': userSession.sessionToken ?? '',
      }),
    );
    return response;
  }

  Future<List<Product>> findByDateRange(String startDate, String endDate) async {
    Response response = await get(
        '$url/findByDateRange/$startDate/$endDate',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> productList = response.body['data'] as List;  // Here we cast 'data' to List
      return Product.fromJsonList(productList);
    } else {
      if (response.statusCode == 401) {
        Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      } else {
        Get.snackbar('Error', 'No se pudo obtener los productos para el rango de fechas');
      }
      return [];
    }
  }

  Future<List<Product>> findByDateRangeAndCategory(String startDate, String endDate, String categoryId) async {
    Response response = await get(
        '$url/findByDateRangeAndCategory/$categoryId/$startDate/$endDate',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> productList = response.body['data'];  // Ajuste si los datos están envueltos en una clave 'data'
      return Product.fromJsonList(productList);
    } else {
      String message = 'No se pudo obtener los productos para el rango de fechas y categoría';
      if (response.statusCode == 401) {
        message = 'Tu usuario no tiene permitido leer esta información';
      } else if (response.statusCode == 500) {
        message = 'Error interno del servidor';
      }
      Get.snackbar('Error', message);
      return [];
    }
  }

  Future<Map<String, int>> fetchProductCountsByCategory() async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/countByCategory',
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data['data'];  // Access the nested 'data' map
        if (data is Map) {
          Map<String, int> categoryCounts = {};
          data.forEach((key, value) {
            if (value is int) {
              categoryCounts[key.toString()] = value;
            } else {
              print("Unexpected data format for count: $value");
            }
          });
          return categoryCounts;
        } else {
          print("Expected 'data' to be a Map, got: $data");
        }
      } else {
        print("Invalid response: ${response.data}");
        Get.snackbar('Error', 'Failed to fetch product counts by category');
      }
    } catch (e) {
      print('Exception caught fetching product counts by category: $e');
      Get.snackbar('Error', 'An error occurred while fetching product counts by category');
    }
    return {};
  }

  Future<Map<String, int>> fetchProductCountsByCategoryAndDate(String date) async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/countByCategoryAndDate/$date', // Asegúrate de que el backend maneje esta ruta
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data['data']; // Asume que la respuesta es un mapa con los conteos
        Map<String, int> categoryCounts = {};
        data.forEach((key, value) {
          if (value is int) {
            categoryCounts[key.toString()] = value;
          } else {
            print("Unexpected data format for count: $value");
          }
        });
        return categoryCounts;
      } else {
        print("Invalid response for fetchProductCountsByCategoryAndDate: ${response.data}");
        return {};
      }
    } catch (e) {
      print('Exception caught in fetchProductCountsByCategoryAndDate: $e');
      return {};
    }
  }

  Future<Map<String, int>> fetchProductCountsByCategoryAndDateRange(String startDate, String endDate) async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/countByCategoryAndDateRange/$startDate/$endDate', // Asegúrate de que el backend maneje esta ruta
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data as Map; // Asume que la respuesta es un mapa con los conteos
        Map<String, int> categoryCounts = {};
        data.forEach((key, value) {
          if (value is int) {
            categoryCounts[key.toString()] = value;
          } else {
            print("Unexpected data format for count: $value");
          }
        });
        return categoryCounts;
      } else {
        print("Invalid response for fetchProductCountsByCategoryAndDateRange: ${response.data}");
        return {};
      }
    } catch (e) {
      print('Exception caught in fetchProductCountsByCategoryAndDateRange: $e');
      Get.snackbar('Error', 'An error occurred while fetching product counts by category and date range');
      return {};
    }
  }

  Future<Map<String, int>> fetchVehiclesInPlantByDateRange(String startDate, String endDate) async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/fetchVehiclesInPlantByDateRange/$startDate/$endDate',
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data as Map;
        Map<String, int> counts = {};
        data.forEach((date, count) {
          if (date is String && count is int) {
            counts[date] = count;
          }
        });
        return counts;
      } else {
        print("Invalid response for fetchVehiclesInPlantByDateRange: ${response.data}");
      }
    } catch (e) {
      print('Exception caught in fetchVehiclesInPlantByDateRange: $e');
      Get.snackbar('Error', 'An error occurred while fetching vehicle counts');
    }
    return {};
  }


  Future<Map<String, int>> fetchContainerCountsByCategory() async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/countContainersByCategory',
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data['data'];
        if (data is Map) {
          Map<String, int> containerCounts = {};
          data.forEach((key, value) {
            if (value is int) {
              containerCounts[key.toString()] = value;
            } else {
              print("Unexpected data format for count: $value");
            }
          });
          return containerCounts;
        } else {
          print("Expected 'data' to be a Map, got: $data");
        }
      } else {
        print("Invalid response: ${response.data}");
        Get.snackbar('Error', 'Failed to fetch container counts by category');
      }
    } catch (e) {
      print('Exception caught fetching container counts by category: $e');
      Get.snackbar('Error', 'An error occurred while fetching container counts by category');
    }
    return {};
  }

  Future<Map<String, int>> fetchContainerCountsByCategoryToday() async {
    try {
      dio.Response response = await dio.Dio().get(
        '$url/countContainersByCategoryToday',
        options: dio.Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? '',
        }),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var data = response.data['data'];
        if (data is Map) {
          Map<String, int> containerCounts = {};
          data.forEach((key, value) {
            if (value is int) {
              containerCounts[key.toString()] = value;
            } else {
              print("Unexpected data format for count: $value");
            }
          });
          return containerCounts;
        } else {
          print("Expected 'data' to be a Map, got: $data");
        }
      } else {
        print("Invalid response: ${response.data}");
        Get.snackbar('Error', 'Failed to fetch container counts by category for today');
      }
    } catch (e) {
      print('Exception caught fetching container counts by category for today: $e');
      Get.snackbar('Error', 'An error occurred while fetching container counts by category for today');
    }
    return {};
  }
}



