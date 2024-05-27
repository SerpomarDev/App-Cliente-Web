import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'preventas_home_controller.dart';

class PreventasHomePage extends StatelessWidget {
  final PreventasHomeController _controller = Get.put(PreventasHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado de mi flota'),
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _controller.fetchAllPreventas,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount;
            double childAspectRatio;

            if (constraints.maxWidth < 600) {
              crossAxisCount = 2; // Para dispositivos móviles
              childAspectRatio = 1; // Ajusta la relación de aspecto para que quepan dos por fila
            } else {
              crossAxisCount = 2; // Para pantallas grandes
              childAspectRatio = 2.5; // Relación de aspecto más alta para tarjetas más pequeñas
            }

            return Obx(() {
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                children: [
                  _buildStatusCard(
                    'En Servicio',
                    'OK',
                    _controller.preventasList.where((p) => p.estado == 'OK').length,
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                  _buildStatusCard(
                    'Fuera de Servicio',
                    'F/S',
                    _controller.preventasList.where((p) => p.estado == 'F/S').length,
                    Icons.cancel_outlined,
                    Colors.red,
                  ),
                  _buildStatusCard(
                    'Fuera de Operacion',
                    'F/O',
                    _controller.preventasList.where((p) => p.estado == 'F/O').length,
                    Icons.error_outline,
                    Colors.orange,
                  ),
                  _buildStatusCard(
                    'Sin Conductor',
                    'S/C',
                    _controller.preventasList.where((p) => p.estado == 'S/C').length,
                    Icons.help_outline,
                    Colors.blue,
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String code, int count, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color), // Icono más pequeño
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Fuente más pequeña
              textAlign: TextAlign.center,
            ),
            Text('($code)', textAlign: TextAlign.center),
            SizedBox(height: 1),
            Text(
              '$count',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color), // Fuente más pequeña
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
