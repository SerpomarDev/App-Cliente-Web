import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/models/galeries.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery_detail/asignacion_orders_galery_detail_page.dart';
import 'package:serpomar_client/src/providers/categories_galery_provider.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:serpomar_client/src/providers/galery_provider.dart';

class AsignacionOrdersGaleryController extends GetxController {


  Categories_galeryProvider categories_galeryProvider = Categories_galeryProvider();
  GaleryProvider galeryProvider = GaleryProvider();

  List<CategoryGaleries> categories_GaleryView = <CategoryGaleries>[].obs;


  var galeryName = ''.obs;
  Timer? searchOnStoppedTyping;

  AsignacionOrdersGaleryController() {
    getCategories();
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      galeryName.value = text;
      print('TEXTO COMPLETO: ${text}');
    });
  }

  void getCategories() async {
    var result = await categories_galeryProvider.getAll();
    categories_GaleryView.clear();
    categories_GaleryView.addAll(result);
  }

  Future<List<Galeries>> getGaleries(String id_category_galeries, String galeryName) async {

    if (galeryName.isEmpty) {
      return await galeryProvider.findByCategory(id_category_galeries);
    }
    else {
      return await galeryProvider.findByNameAndCategory(id_category_galeries, galeryName);
    }
  }

}