import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/administrador_products_create_controller.dart';

import 'conductor_orders_imgencargo_controller.dart';


class ConductorOrdersImgencargoPage extends StatelessWidget {

  ConductorOrdersImgencargoController con = Get.put(ConductorOrdersImgencargoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: Column(
        children: [
          _buttonBack(),
        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18, left: 50, right: 50),
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
            _dropDownCategories(con.categories_galery),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile1, 1)
                  ),
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile2, 2)
                  ),
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile3, 3)
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile4, 4)
                  ),
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile5, 5)
                  ),
                  GetBuilder<ConductorOrdersImgencargoController>(
                      builder: (value) =>_cardImage(context, con.imageFile6, 6)
                  ),
                ],
              ),
            ),
            _buttonCreate(context)
          ],
        ),
      ),
    );


  }

  Widget _buttonBack() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20, top: 65),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _dropDownCategories(List<CategoryGaleries> categories_galery) {
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
        items: _dropDownItems(categories_galery),
        value: con.id_category_galery.value == '' ? null : con.id_category_galery.value,
        onChanged: (option) {
          print('Opcion seleccionada ${option}');
          con.id_category_galery.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<CategoryGaleries> categories_galery) {
    List<DropdownMenuItem<String>> list = [];
    categories_galery.forEach((categorygaleries) {
      list.add(DropdownMenuItem(
        child: Text(categorygaleries.name ?? ''),
        value: categorygaleries.id,
      ));
    });

    return list;
  }

  Widget _cardImage(BuildContext context, File? imageFile, int numberFile) {
    return GestureDetector(
        onTap: () => con.showAlertDialog(context, numberFile),
        child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.18,
              child:  imageFile != null
                  ? Image.file(
                imageFile,
                fit: BoxFit.cover,
              )
                  : Image(
                image: AssetImage('assets/img/cover_image.png'),
              )
          ),
        )
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre de la ruta',
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
            hintText: 'Descripción de la ruta',
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
            con.createGaleries(context);
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(

            'SUBIR IMAGENES',
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
        margin: EdgeInsets.only(top: 40),
        alignment: Alignment.topCenter,
        child: Text(
          'SUBIR IMAGENES',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23
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

}

