import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/providers/categories_galery_provider.dart';
import 'package:serpomar_client/src/providers/galery_provider.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:serpomar_client/src/models/galeries.dart';

import 'package:serpomar_client/src/models/response_api.dart';


class ConductorOrdersImgencargoController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  File? imageFile4;
  File? imageFile5;
  File? imageFile6;

  var id_category_galery = ''.obs;

  List<CategoryGaleries> categories_galery = <CategoryGaleries>[].obs;
  GaleryProvider galeryProvider = GaleryProvider();

  ConductorOrdersImgencargoController() {
    getCategories_galery();
  }

  void getCategories_galery() async {
    var result = await Categories_galeryProvider().getAll();
    categories_galery.clear();
    categories_galery.addAll(result);
  }

  void createGaleries(BuildContext context) async {

    String name = nameController.text;
    String description = descriptionController.text;


    print('NAME: ${name}');
    print('DESCRIPTION: ${description}');
    print('ID CATEGORY: ${id_category_galery}');
    ProgressDialog progressDialog = ProgressDialog(context: context);

    if (isValidForm(name, description)) {
      Galeries galeries = Galeries(
          name: name,
          description: description,
          idCategoryGaleries: id_category_galery.value
      );

      progressDialog.show(max: 100, msg: 'Espere un momento...');

      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);
      images.add(imageFile4!);
      images.add(imageFile5!);
      images.add(imageFile6!);

      Stream stream = await galeryProvider.create(galeries, images);
      stream.listen((res) {
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
          // Después de subir las imágenes con éxito, regresa a la página anterior
          Navigator.pop(context);
        }
      });
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
    if (id_category_galery.value == '') {
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
    if (imageFile4 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 4 de la RUTA');
      return false;
    }
    if (imageFile5 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 5 de la RUTA');
      return false;
    }
    if (imageFile6 == null) {
      Get.snackbar('Fomulario no valido', 'Selecciona la imagen numero 6 de la RUTA');
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
      else if (numberFile == 4) {
        imageFile4 = File(image.path);
      }
      else if (numberFile == 5) {
        imageFile5 = File(image.path);
      }
      else if (numberFile == 6) {
        imageFile6 = File(image.path);
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
    imageFile4 = null;
    imageFile5 = null;
    imageFile6 = null;
    id_category_galery.value = '';
    update();
  }

}