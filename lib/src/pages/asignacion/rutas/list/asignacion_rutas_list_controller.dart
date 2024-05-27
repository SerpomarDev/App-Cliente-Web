import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/detail/asignacion_rutas_detail_page.dart';

import 'package:serpomar_client/src/providers/categories_provider.dart';
import 'package:serpomar_client/src/providers/products_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AsignacionRutasListController extends GetxController {


  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];


  List<Category> categories = <Category>[].obs;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;

  AsignacionRutasListController() {
    getCategories();
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      }
      else {
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      selectedProducts.forEach((p) {
        items.value = items.value + (p.quantity!);
      });

    }
  }

  // Función para marcar un producto como no visible
  void markProductAsAssigned(Product product) {
    product.isAssigned = true; // Suponiendo que `isAssigned` es un nuevo campo booleano en el modelo Product
    update(); // Esto es para actualizar la UI si usas GetX para manejo de estado
  }





  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      productName.value = text;
      print('TEXTO COMPLETO: ${text}');
    });
  }



  void updateProductAssignedStatus(String productId, bool isAssigned) {
    productsProvider.updateProductAssignedStatus(productId, isAssigned).then((response) {
      if (response.statusCode == 200) {
        // Remove the product from the list
        selectedProducts.removeWhere((product) => product.id == productId);
        update(); // Update the UI to reflect the removal
        Get.snackbar("Listo", "Asignacion fue alistada con exito.");
      } else {
        Get.snackbar("Error", "No se pudo alistar.");
      }
    }).catchError((error) {
      Get.snackbar("Error", ": $error");
    });
  }



  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  Future<List<Product>> getProducts(String idCategory, String productName) async {

    if (productName.isEmpty) {
      return await productsProvider.findByCategory(idCategory);
    }
    else {
      return await productsProvider.findByNameAndCategory(idCategory, productName);
    }

  }

  void goToOrderCreate() {
    Get.toNamed('/asignacion/orders/create');
  }

  void openBottomSheet(BuildContext context, Product product) async{

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => AsignacionRutasDetailPage(product: product),
    );
  }

}