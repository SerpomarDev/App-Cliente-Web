import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_controller.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery/asignacion_orders_galery_page.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/list/asignacion_orders_list_page.dart';
import 'package:serpomar_client/src/pages/asignacion/profile/info/asignacion_profile_info_page.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/list/asignacion_rutas_list_page.dart';
import 'package:serpomar_client/src/pages/conductor/orders/list/conductor_orders_list_page.dart';
import 'package:serpomar_client/src/pages/flota/flota_home_page.dart';
import 'package:serpomar_client/src/pages/home/home_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart'; // Asegúrate que la ruta de importación sea correcta
import 'package:serpomar_client/src/utils/custom_animated_bottom_bar.dart';

class AsignacionHomePage extends StatelessWidget {
  final AsignacionHomeController con = Get.put(AsignacionHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis solicitudes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      // drawer: AppDrawer(currentPage: 'Mis solicitudes'),  // Usando AppDrawer
      bottomNavigationBar: _bottomBar(),
      body: Obx(
            () => IndexedStack(
          index: con.indexTab.value,
          children: [
            AsignacionRutasListPage(),
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
              icon: Icon(Icons.list, color: Colors.white),
              title: Text('Mis solicitudes'),
              activeColor: Colors.white,
              inactiveColor: Colors.grey
          ),
        ],
      ),
    );
  }
}
