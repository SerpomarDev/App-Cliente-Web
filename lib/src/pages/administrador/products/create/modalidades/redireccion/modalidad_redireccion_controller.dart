import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/providers/categories_provider.dart';
import 'package:serpomar_client/src/providers/products_provider.dart';


class ModalidadRedireccionController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  ModalidadRedireccionController() {
    getCategories();
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  void createProduct(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;

    ProgressDialog progressDialog = ProgressDialog(context: context);

    if (isValidForm(name, description)) {
      Product product = Product(
          name: name,
          description: description,
          idCategory: idCategory.value
      );

      progressDialog.show(max: 100, msg: 'Espere un momento...');

      List<File> images = [];

      try {
        dio.Response response = await productsProvider.create(product, images);
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(response.data);
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
        }
      } catch (e) {
        progressDialog.close();
        Get.snackbar('Error', 'No se pudo crear el producto');
      }
    }
  }



  bool isValidForm(String name, String description) {
    if (name.isEmpty) {
      Get.snackbar('Fomulario no valido', 'Ingresa el nombre de la RUTA');
      return false;
    }
    if (description.isEmpty) {
      Get.snackbar('Fomulario no valido', 'Ingresa la descripcion de la RUTA');
      return false;
    }
    if (idCategory.value == '') {
      Get.snackbar('Fomulario no valido', 'Debes seleccionar la categoria de la RUTA');
      return false;
    }

    return true;
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    idCategory.value = '';
    update();
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

  }