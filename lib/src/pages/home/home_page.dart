import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/expo/modalidad_expo_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/impo/modalidad_impo_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/traslado/modalidad_traslado_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/vacio/modalidad_vacio_page.dart';
import 'package:serpomar_client/src/pages/home/home_controller.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker1/looker1_page.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker2/looker2_page.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker3/looker3_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart';

class HomePage extends StatelessWidget {
  final HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modalidades',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: AppDrawer(currentPage: 'Inicio'),
      body: Obx(
            () => IndexedStack(
          index: con.indexTab.value,
          children: [
            _buildResponsiveGridView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGridView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 2; // Para dispositivos móviles
          childAspectRatio = 1; // Ajusta la relación de aspecto para que quepan dos por fila
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 2; // Para tablets y pantallas medianas
          childAspectRatio = 1.5;
        } else {
          crossAxisCount = 3; // Para pantallas grandes
          childAspectRatio = 1.5;
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildGridTile(
                    context,
                    title: "EXPORTACIÓN",
                    onTap: () => Get.to(() => Looker1Page()),
                    imagePath: "assets/img/export.png",
                  ),
                  _buildGridTile(
                    context,
                    title: "VACIOS",
                    onTap: () => Get.to(() => Looker2Page()),
                    imagePath: "assets/img/vacio.png",
                  ),
                  _buildGridTile(
                    context,
                    title: "LLENOS",
                    onTap: () => Get.to(() => Looker3Page()),
                    imagePath: "assets/img/llenos.png",
                  ),
                  // _buildGridTile(
                  //   context,
                  //   title: "TRASLADO",
                  //   onTap: () => Get.to(() => ModalidadTrasladoPage()),
                  //   imagePath: "assets/img/traslado.png",
                  // ),
                  // _buildGridTile(
                  //   context,
                  //   title: "OTRA MODALIDAD",
                  //   onTap: () => Get.to(() => ModalidadVacioPage()),
                  //   imagePath: "assets/img/vacio.png",
                  // ),
                  // _buildGridTile(
                  //   context,
                  //   title: "OTRO TRASLADO",
                  //   onTap: () => Get.to(() => ModalidadTrasladoPage()),
                  //   imagePath: "assets/img/traslado.png",
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridTile(BuildContext context, {required String title, required Function onTap, required String imagePath}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white70,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
