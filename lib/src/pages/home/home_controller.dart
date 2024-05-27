import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/user.dart';

class HomeController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  var indexTab = 0.obs;
  // PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();


  void changeTab(int index) {
    indexTab.value = index;
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }



}

