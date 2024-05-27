import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/user.dart';

class Looker1Controller extends GetxController {

  var indexTab = 0.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  Looker1Controller() {
    saveToken();
  }

  void saveToken() {
    if (user.id != null) {
      // pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }



}
