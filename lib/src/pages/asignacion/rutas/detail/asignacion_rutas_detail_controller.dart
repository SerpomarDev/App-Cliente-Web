import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/list/asignacion_rutas_list_controller.dart';


class AsignacionRutasDetailController extends GetxController {
  List<Product> selectedProducts = [];
  AsignacionRutasListController productsListController = Get.find();
  var counter = 1.obs; // Inicializa counter en 1


  void checkIfProductsWasAdded(Product product, var counter) {

    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index != -1) { // EL PRDOCUTO YA FUE AGREGADO
        counter.value = selectedProducts[index].quantity!;
      }
    }
  }

  void addToBag(Product product, var counter) {
    if (counter.value > 0) {
      // VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index == -1) { // NO HA SIDO AGREGADO
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          } else {
            product.quantity = 1;
          }
          selectedProducts.add(product);
          GetStorage().write('shopping_bag', selectedProducts);
          Fluttertoast.showToast(msg: 'Ruta agregado');
        } else {
          // Si el producto ya estaba en la bolsa, no lo agregamos nuevamente
          Fluttertoast.showToast(msg: 'La ruta ya fue agregada');
        }

        productsListController.items.value = 0;
        selectedProducts.forEach((p) {
          productsListController.items.value = productsListController.items.value + p.quantity!;
        });
      }
      else {
        // YA HA SIDO AGREGADO EN STORAGE, actualiza la cantidad
        selectedProducts[index].quantity = counter.value;
        GetStorage().write('shopping_bag', selectedProducts);
        Fluttertoast.showToast(msg: 'La ruta ya fue agregada');
      }
    } else {
      Fluttertoast.showToast(msg: 'Debes seleccionar al menos un item para agregar');
    }
  }


  void addItem(Product product, var counter) {
    counter.value = counter.value + 1;
  }

  void removeItem(Product product, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
    }
  }
}
