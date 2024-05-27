import 'dart:convert';
import 'dart:io';

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
import 'package:dio/dio.dart' as dio;
import 'package:serpomar_client/src/providers/products_provider.dart';


class AdministradorProductsCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  AdministradorProductsCreateController() {
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

    if (isValidForm(name, description)) {
      Product product = Product(
          name: name,
          description: description,
          idCategory: idCategory.value
      );
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Espere un momento...');

      List<File> images = [];
      if (imageFile1 != null) images.add(imageFile1!);
      if (imageFile2 != null) images.add(imageFile2!);
      if (imageFile3 != null) images.add(imageFile3!);

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

    if (imageFile1 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 1 de la RUTA');
      return false;
    }
    if (imageFile2 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 2 de la RUTA');
      return false;
    }
    if (imageFile3 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 3 de la RUTA');
      return false;
    }

    return true;
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {

      if (numberFile == 1) {
        imageFile1 = File(image.path);
      }
      else if (numberFile == 2) {
        imageFile2 = File(image.path);
      }
      else if (numberFile == 3) {
        imageFile3 = File(image.path);
      }

      update();
    }
  }

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text(
          'GALERIA',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text(
          'CAMARA',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory.value = '';
    update();
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}