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

class ModalidadVacioController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  TextEditingController portWarehouseDateController = TextEditingController();
  TextEditingController freeDaysDateController = TextEditingController();
  TextEditingController fechaDateController = TextEditingController();
  TextEditingController remisionController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController loadingDateController = TextEditingController();
  TextEditingController numContainersController = TextEditingController();
  TextEditingController doController = TextEditingController();

  var isFreePoolSelected = false.obs;
  var selectedContainerTypes = <String>[].obs;
  var selectedFile = Rxn<File>();
  var selectedRoute = ''.obs;
  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  ModalidadVacioController() {
    getCategories();
  }

  String get containerTypesAsString => selectedContainerTypes.join(', '); // Convert selected types to string

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
    var importacionCategory = result.firstWhere((category) => category.id == '3', orElse: () => Category());
    if (importacionCategory != null && importacionCategory.id == '3') {
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
    String remision = remisionController.text;
    String observaciones = observacionesController.text;
    String selectedRoute = this.selectedRoute.value;
    String fechaDate = fechaDateController.text;
    String portWarehouseDate = portWarehouseDateController.text;
    String freeDaysDate = freeDaysDateController.text;
    String containerTypes = containerTypesAsString;
    String expirationDate = expirationDateController.text;
    String loadingDate = loadingDateController.text;
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
        remision: remision,
        observaciones: observaciones,
        idCategory: idCategory.value,
        selectedRoute: selectedRoute,
        portWarehouseDate: portWarehouseDate,
          fechaDate: fechaDate,
        containerTypes: containerTypes,
        attachmentUrl: attachmentUrl,
        expirationDate: expirationDate,
        loadingDate: loadingDate,
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
          // Suponiendo que el ID del producto está en responseApi.data['id']
          String productId = responseApi.data['id'].toString();

          // Mostrar la ventana modal con el ID del producto
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
                        "Ref: SpRTV00$productId",
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
                          Navigator.of(context).pop();
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
        Get.snackbar('Error', 'No se pudo crear el producto');
      }
    }
  }


  bool isValidForm(String name, String description) {
    if (idCategory.value == '') {
      Get.snackbar('Formulario no valido', 'Debes seleccionar la categoria de la RUTA');
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
    fechaDateController.text = '';
    portWarehouseDateController.text = '';
    freeDaysDateController.text = '';
    remisionController.text = '';
    observacionesController.text = '';
    selectedContainerTypes.clear();
    selectedFile.value = null;
    expirationDateController.text = '';
    loadingDateController.text = '';
    update();
  }


  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}
