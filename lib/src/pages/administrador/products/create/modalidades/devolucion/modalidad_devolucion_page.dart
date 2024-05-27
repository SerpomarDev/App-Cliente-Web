import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/administrador_products_create_controller.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_page.dart';
import 'package:serpomar_client/src/pages/home/home_page.dart';

import 'modalidad_devolucion_controller.dart';


class ModalidadDevolucionPage extends StatelessWidget {

  ModalidadDevolucionController con = Get.put(ModalidadDevolucionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.indigoAccent,
      ),
      drawer: _buildDrawer(context, isActive: true), // Modifica esta línea
      body: Obx(() => Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewCategory(context),
        ],
      )),
    );
  }


  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.indigoAccent,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 50, right: 50),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldName(),
            _textFieldDescription(),
            _dropDownCategories(con.categories),
            _buttonCreate(context)
          ],
        ),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.indigoAccent,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar categoria',
          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option) {
          print('Opcion seleccionada ${option}');
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name ?? ''),
        value: category.id,
      ));
    });

    return list;
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Tipo de Servicio',
            prefixIcon: Icon(Icons.category)
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Descripción del servicio',
            prefixIcon: Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Icon(Icons.description)
            )
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30, top: 18),
      child: ElevatedButton(
          onPressed: () {
            con.createProduct(context);
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'Generar Solicitud',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textNewCategory(BuildContext context) {

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.topCenter,
        child: Text(
          'Solicitar Devolución de Vacio',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30),
      child: Text(
        'INGRESA ESTA INFORMACION',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }


  Widget _buildDrawer(BuildContext context, {bool isActive = false}) {
    var screenHeight = MediaQuery.of(context).size.height;
    var drawerHeaderHeight = screenHeight * 0.25; // Increase to 30% of the screen height

    return Drawer(
      child: Container(
        color: Colors.white, // Set the background color of the Drawer to white
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: drawerHeaderHeight,
                child: DrawerHeader(
                  margin: EdgeInsets.zero, // Remove the default margin
                  padding: EdgeInsets.only(bottom: 0), // Add some padding to bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menú',
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold, // Make the text bold
                          letterSpacing: 1.2, // Add some letter spacing
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Add a white color to the header
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined, color: Colors.indigoAccent),
                title: Text('Inicio'),
                onTap: () => Get.to(() => HomePage()),
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: isActive ? Colors.red : Colors.indigoAccent),
                title: Text(
                  'Solicitud de servicio',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isActive ? Colors.red : null,
                  ),
                ),
                onTap: () => Get.to(() => ModalidadesPage()),
              ),
              ListTile(
                leading: Icon(Icons.list_alt_outlined, color: Colors.indigoAccent),
                title: Text('Mis Solicitudes'),
                onTap: () => Get.to(() => AsignacionHomePage()),
              ),
              ListTile(
                leading: Icon(Icons.query_stats_outlined, color: Colors.indigoAccent),
                title: Text('Estado de solicitudes'),
                onTap: () => Get.to(() => AdministradorHomePage()),
              ),
              ListTile(
                leading: Icon(Icons.directions_car, color: Colors.indigoAccent),
                title: Text('Mi Flota'),
                onTap: () => Get.to(() => ()),
              ),
              Spacer(), // This will push the logout button to the bottom
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

}