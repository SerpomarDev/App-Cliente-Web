import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/Rol.dart';
import 'package:serpomar_client/src/pages/roles/roles_controller.dart';

class RolesPage extends StatelessWidget {
  RolesController con = Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TU ROL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0073FF),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.12),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: con.user.roles_app?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return _cardRol(con.user.roles_app![index]);
          },
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () => con.goToPageRol(rol),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 18),
              height: 90,
              child: Image.network(
                rol.image!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/img/no-image.png');
                },
              ),
            ),
            Text(
              rol.name ?? '',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
