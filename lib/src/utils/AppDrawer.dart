import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/looker/looker_page.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker1/looker1_page.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker2/looker2_page.dart';
import '../pages/administrador/home/administrador_home_page.dart';
import '../pages/administrador/products/create/modalidades/modalidades_page.dart';
import '../pages/asignacion/home/asignacion_home_page.dart';
import '../pages/asignacion/orders/galery/asignacion_orders_galery_page.dart';
import '../pages/flota/flota_home_page.dart';
import '../pages/home/home_controller.dart';
import '../pages/home/home_page.dart';

class AppDrawer extends StatelessWidget {
  final HomeController con = Get.put(HomeController());
  final String currentPage;

  AppDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    double drawerHeaderHeight = MediaQuery.of(context).size.height * 0.25;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: drawerHeaderHeight,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Menú',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildDrawerItem(
                      icon: Icons.home_outlined,
                      text: 'Inicio',
                      onTap: () => _navigateTo(context, HomePage(), 'Inicio'),
                      isActive: currentPage == 'Inicio',
                    ),
                    // _buildDrawerItem(
                    //   icon: Icons.add_circle_outline,
                    //   text: 'Solicitud de servicio',
                    //   onTap: () => _navigateTo(context, ModalidadesPage(), 'Solicitud de servicio'),
                    //   isActive: currentPage == 'Solicitud de servicio',
                    // ),
                    _buildDrawerItem(
                      icon: Icons.dashboard_outlined,
                      text: 'Mis Tableros',
                      onTap: () => _navigateTo(context, LookerPage(), 'Mis Tableros'),
                      isActive: currentPage == 'Mis Tableros',
                    ),
                    _buildDrawerItem(
                      icon: Icons.list_alt_outlined,
                      text: 'Mis solicitudes',
                      onTap: () => _navigateTo(context, AsignacionHomePage(), 'Mis solicitudes'),
                      isActive: currentPage == 'Mis solicitudes',
                    ),
                    _buildDrawerItem(
                      icon: Icons.query_stats_outlined,
                      text: 'Estado de solicitudes',
                      onTap: () => _navigateTo(context, AdministradorHomePage(), 'Estado de solicitudes'),
                      isActive: currentPage == 'Estado de solicitudes',
                    ),
                    _buildDrawerItem(
                      icon: Icons.directions_car_outlined,
                      text: 'Mi Flota',
                      onTap: () => _navigateTo(context, FlotaHomePage(), 'Mi Flota'),
                      isActive: currentPage == 'Mi Flota',
                    ),
                    // _buildDrawerItem(
                    //   icon: Icons.photo_camera_back_outlined,
                    //   text: 'Mi Galeria',
                    //   onTap: () => _navigateTo(context, AsignacionOrdersGaleryPage(), 'Mi Galeria'),
                    //   isActive: currentPage == 'Mi Galeria',
                    // ),
                    // _buildDrawerItem(
                    //   icon: Icons.auto_graph_outlined,
                    //   text: 'Patio',
                    //   onTap: () => _navigateTo(context, Looker2Page(), 'Patio'),
                    //   isActive: currentPage == 'Patio',
                    // ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.indigoAccent),
                title: Text('Cerrar sesión', style: TextStyle(fontSize: 18.0)),
                onTap: () {
                  con.signOut();
                  Get.offAllNamed('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page, String pageName) {
    Navigator.pop(context); // Close the drawer before navigating
    Future.delayed(Duration(milliseconds: 300), () {
      Get.to(() => page);
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.red : Colors.indigoAccent),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: isActive ? Colors.red : Colors.indigoAccent,
        ),
      ),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right, color: Colors.indigoAccent),
      tileColor: isActive ? Colors.indigo[50] : Colors.transparent,
    );
  }
}
