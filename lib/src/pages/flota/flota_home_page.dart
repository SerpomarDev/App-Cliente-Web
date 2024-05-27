import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery/asignacion_orders_galery_page.dart';
import 'package:serpomar_client/src/pages/home/home_page.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_page.dart';
import 'package:serpomar_client/src/pages/flota/flota_home_controller.dart';
import 'package:serpomar_client/src/pages/flota/preventa/preventas_home_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart'; // Asegúrate de que la ruta de importación sea correcta
import 'package:serpomar_client/src/utils/custom_animated_bottom_bar.dart';

class FlotaHomePage extends StatelessWidget {
  FlotaHomeController con = Get.put(FlotaHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MI FLOTA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      // drawer: AppDrawer(currentPage: 'Mi Flota'),  // Utilizando AppDrawer
      bottomNavigationBar: _bottomBar(),
      body: Obx(
            () => IndexedStack(
          index: con.indexTab.value,
          children: [
            PreventasHomePage(),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(
          () => CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: Color(0xFF0073FF),
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        selectedIndex: con.indexTab.value,
        onItemSelected: (index) => con.changeTab(index),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.car_repair, color: Colors.white),
            title: Text('Mi Flota'),
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
