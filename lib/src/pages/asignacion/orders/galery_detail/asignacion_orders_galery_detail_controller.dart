import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/galeries.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/list/asignacion_rutas_list_controller.dart';


class AsignacionOrdersGalery_detailController extends GetxController {
  List<Galeries> selectedGalery = [];
  AsignacionRutasListController Galery_detailController = Get.find();
}
