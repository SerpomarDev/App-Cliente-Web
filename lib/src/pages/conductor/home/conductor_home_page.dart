import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/administrador/categories/create/administrador_categories_create_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/administrador_products_create_page.dart';
import 'package:serpomar_client/src/pages/asignacion/profile/info/asignacion_profile_info_page.dart';
import 'package:serpomar_client/src/pages/conductor/home/conductor_home_controller.dart';
import 'package:serpomar_client/src/pages/conductor/orders/list/conductor_orders_list_page.dart';


import 'package:serpomar_client/src/utils/custom_animated_bottom_bar.dart';



class ConductorHomePage extends StatelessWidget{

  ConductorHomeController con = Get.put(ConductorHomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: con.indexTab.value,
          children: [
            ConductorOrdersListPage(),
            AsignacionProfileInfoPage(),
          ],
        ))
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Color(0xFF0073FF),
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,
      onItemSelected: (index) => con.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Ordenes'),
            activeColor: Colors.white,
            inactiveColor: Colors.grey
        ),

        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.grey
        ),
      ],
    ));
  }

}
