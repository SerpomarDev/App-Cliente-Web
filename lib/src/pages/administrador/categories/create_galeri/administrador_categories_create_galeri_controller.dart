import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/providers/categories_galery_provider.dart';


class AdministradorCategoriesCreate_galeriController extends GetxController {

  TextEditingController nameController = TextEditingController();

  Categories_galeryProvider categories_galeryProvider = Categories_galeryProvider();

  void createCategorygaleries() async {

    String name = nameController.text;
    print('NAME: ${name}');

    if (name.isNotEmpty ) {
     CategoryGaleries categoryGaleries = CategoryGaleries(
       id: '',
       name: name,
     );

      ResponseApi responseApi = await categories_galeryProvider.create(categoryGaleries);
      Get.snackbar('Proceso terminado', responseApi.message ?? '');

      if (responseApi.success == true) {
        clearForm();
      }

    }
    else {
      Get.snackbar('Formulario no valido', 'Ingresa todos los campos para crear la categoria');
    }

  }

  void clearForm() {
    nameController.text = '';
  }

}