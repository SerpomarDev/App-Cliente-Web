import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/preventas.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';
import 'package:serpomar_client/src/providers/preventas_provider.dart';
import 'package:serpomar_client/src/providers/users_provider.dart';

class FlotaHomeController extends GetxController {
  var indexTab = 0.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  var preventas = <Preventas>[].obs;
  PreventasProvider preventasProvider = PreventasProvider();

  void changeTab(int index) {
    indexTab.value = index;
  }

  void saveToken() {
    if (user.id != null) {
      // pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }
}
