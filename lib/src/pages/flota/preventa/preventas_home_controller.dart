import 'package:get/get.dart';
import 'package:serpomar_client/src/models/preventas.dart';
import 'package:serpomar_client/src/providers/preventas_provider.dart';

class PreventasHomeController extends GetxController {
  var preventasList = <Preventas>[].obs;
  final PreventasProvider _preventasProvider = PreventasProvider();

  @override
  void onInit() {
    super.onInit();
    fetchAllPreventas();
  }

  void fetchAllPreventas() async {
    var preventas = await _preventasProvider.getAllPreventas();
    if (preventas != null) {
      preventasList.value = preventas;
    }
  }
}
