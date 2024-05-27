import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/impo/modalidad_impo_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/traslado/modalidad_traslado_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/vacio/modalidad_vacio_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart';
import 'expo/modalidad_expo_page.dart';
import 'modalidades_controller.dart';

class ModalidadesPage extends StatelessWidget {
  final ModalidadesController con = Get.put(ModalidadesController());

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
        int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
        double childAspectRatio = constraints.maxWidth < 600 ? 2 : 1.5;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 800),
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
                    title: "IMPORTACIÓN",
                    onTap: () => Get.to(() => ModalidadImpoPage()),
                    imagePath: "assets/img/importacion.png",
                  ),
                  _buildGridTile(
                    context,
                    title: "EXPORTACIÓN",
                    onTap: () => Get.to(() => ModalidadExpoPage()),
                    imagePath: "assets/img/exportacion.png",
                  ),
                  _buildGridTile(
                    context,
                    title: "RET. VACIO",
                    onTap: () => Get.to(() => ModalidadVacioPage()),
                    imagePath: "assets/img/vacio.png",
                  ),
                  _buildGridTile(
                    context,
                    title: "TRASLADO",
                    onTap: () => Get.to(() => ModalidadTrasladoPage()),
                    imagePath: "assets/img/traslado.png",
                  ),
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
