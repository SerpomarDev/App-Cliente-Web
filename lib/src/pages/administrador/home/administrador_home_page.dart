import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/administrador/categories/create/administrador_categories_create_page.dart';
import 'package:serpomar_client/src/pages/administrador/categories/create_galeri/administrador_categories_create_galeri_page.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_controller.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/administrador_products_create_page.dart';
import 'package:serpomar_client/src/pages/administrador/orders/list/administrador_orders_list_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_page.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery/asignacion_orders_galery_page.dart';
import 'package:serpomar_client/src/pages/flota/flota_home_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart';
import 'package:serpomar_client/src/utils/custom_animated_bottom_bar.dart';

import '../../asignacion/profile/info/asignacion_profile_info_page.dart';
import '../../home/home_page.dart';

class AdministradorHomePage extends StatelessWidget {
  final AdministradorHomeController con = Get.put(
      AdministradorHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estado de tus Solicitudes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      // drawer: AppDrawer(currentPage: 'Estado de solicitudes'),
      // Utilizando AppDrawer con la página actual
      bottomNavigationBar: _bottomBar(),
      body: Obx(
            () =>
            IndexedStack(
              index: con.indexTab.value,
              children: [
                AdministradorOrdersListPage(),
              ],
            ),
      ),
    );
  }


  Widget _bottomBar() {
    return Obx(
          () =>
          CustomAnimatedBottomBar(
            containerHeight: 70,
            backgroundColor: Color(0xFF0073FF),
            showElevation: true,
            itemCornerRadius: 30,
            curve: Curves.easeIn,
            selectedIndex: con.indexTab.value,
            onItemSelected: (index) => con.changeTab(index),
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.list, color: Colors.white),
                  title: Text('Mis solicitudes'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey),
            ],
          ),
    );
  }
}