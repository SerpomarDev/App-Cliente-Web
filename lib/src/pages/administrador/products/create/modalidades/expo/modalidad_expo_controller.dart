import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/providers/categories_provider.dart';
import 'package:serpomar_client/src/providers/products_provider.dart';

class ModalidadExpoController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController schedulingDateController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  TextEditingController portWarehouseDateController = TextEditingController();
  TextEditingController fechaDateController = TextEditingController();
  TextEditingController freeDaysDateController = TextEditingController();
  TextEditingController patioWithdrawalDateController = TextEditingController();
  TextEditingController numContainersController = TextEditingController();
  TextEditingController doController = TextEditingController();

  var selectedContainerTypes = <String>[].obs;
  var selectedFile = Rxn<File>();
  var selectedRoute = ''.obs;
  var idCategory = ''.obs;

  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  ModalidadExpoController() {
    getCategories();
  }

  String get containerTypesAsString => selectedContainerTypes.join(', ');

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance.ref().child('attachments/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    var importacionCategory = result.firstWhere((category) => category.id == '2', orElse: () => Category());
    if (importacionCategory != null && importacionCategory.id == '2') {
      categories.add(importacionCategory);
    }
  }

  bool isValidNumContainers(String value) {
    if (value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el número de contenedores');
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      Get.snackbar('Formulario no válido', 'Solo se permiten números en el campo de contenedores');
      return false;
    }
    return true;
  }

  void createProduct(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    String schedulingDate = schedulingDateController.text;  // Utiliza la nueva fecha de programación
    String selectedRoute = this.selectedRoute.value;
    String portWarehouseDate = portWarehouseDateController.text;
    String fechaDate = fechaDateController.text;
    String freeDaysDate = freeDaysDateController.text;
    String containerTypes = containerTypesAsString;
    String numContainers = numContainersController.text;
    String doNumber = doController.text;

    if (isValidForm(name, description)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Espere un momento...');

      String? attachmentUrl;
      if (selectedFile.value != null) {
        attachmentUrl = await uploadFile(selectedFile.value!);
      }

      Product product = Product(
          name: name,
          description: description,
          idCategory: idCategory.value,
          selectedRoute: selectedRoute,
          portWarehouseDate: portWarehouseDate,
          fechaDate: fechaDate,
          freeDaysDate: freeDaysDate,
          schedulingDate: schedulingDate,  // Incluye la fecha de programación en el producto
          containerTypes: containerTypes,
          attachmentUrl: attachmentUrl,
          numContainers: int.parse(numContainers),
          doNumber: doNumber,
      );

      try {
        dio.Response response = await productsProvider.create(product, []);
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(response.data);

        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
          String productId = responseApi.data['id'].toString();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Solicitud Generada",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ref: SpEX00$productId",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context). pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } catch (e) {
        progressDialog.close();
        Get.snackbar('Error', 'No se pudo crear el producto: ${e.toString()}');
      }
    }
  }

  bool isValidForm(String name, String description) {
    if (idCategory.value == '') {
      Get.snackbar('Formulario no válido', 'Debes seleccionar la categoría de la RUTA');
      return false;
    }
    if (selectedContainerTypes.isEmpty) {
      Get.snackbar('Formulario no válido', 'Debes seleccionar al menos un tipo de contenedor');
      return false;
    }

    if (!isValidNumContainers(numContainersController.text)) {
      return false;
    }

    return true;
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    idCategory.value = '';
    selectedRoute.value = '';
    portWarehouseDateController.text = '';
    fechaDateController.text = '';
    freeDaysDateController.text = '';
    patioWithdrawalDateController.text = '';
    schedulingDateController.text = '';  // Limpia también la fecha de programación
    selectedContainerTypes.clear();
    selectedFile.value = null;
    selectedRoute.value = '';
    update();
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}
