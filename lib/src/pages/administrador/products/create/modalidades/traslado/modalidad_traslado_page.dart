import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/administrador_products_create_controller.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_page.dart';
import 'package:serpomar_client/src/pages/home/home_page.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart';

import 'modalidad_traslado_controller.dart';

class ModalidadTrasladoPage extends StatelessWidget {
  ModalidadTrasladoController con = Get.put(ModalidadTrasladoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.indigoAccent,
      ),
      // drawer: AppDrawer(currentPage: 'Solicitud de servicio'),  // Agregar el AppDrawer aquí
      body: Obx(() => Stack(
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
      height: MediaQuery.of(context).size.height * 0.38,
      color: Colors.indigoAccent,
    );
  }

  Widget _textFieldDO() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: con.doController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'DO Pedido',
          prefixIcon: Icon(Icons.document_scanner, color: Colors.indigoAccent),
        ),
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.06, left: 40, right: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75))
          ]),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _dateTimeField(context, 'Fecha de programación',
                con.fechaDateController),
            _dropDownCategories(con.categories),
            _dropDownRoute(), // Agrega la sección "Ruta"
            _textFieldDO(),
            _textFieldRemision(), // Campo "Remisión"
            // _textFieldObservaciones(),
            _textFieldPeso(),
            _textFieldMaterial(),// Campo "Observaciones"
            _textFieldDescription(),
            _buttonCreate(context)
          ],
        ),
      ),
    );
  }


  Widget _dropDownRoute() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton<String>(
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
          'Seleccionar Ruta',
          style: TextStyle(fontSize: 15, color: Colors.black54,),

        ),
        items: [
          DropdownMenuItem(
            child: Text('Planta a Cedi Serpomar'),
            value: 'Planta a Cedi Serpomar',
          ),
          DropdownMenuItem(
            child: Text('Planta a Cedi Ext.1'),
            value: 'Planta a Cedi Ext.1',
          ),
          DropdownMenuItem(
            child: Text('Planta a Cedi Ext.2'),
            value: 'Planta a Cedi Ext.2',
          ),
        ],
        value: con.selectedRoute.value == '' ? null : con.selectedRoute.value,
        onChanged: (option) {
          con.selectedRoute.value = option.toString();
        },
      ),
    );
  }


  Widget _dateTimeField(BuildContext context, String labelText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: IconButton(
            icon: Icon(Icons.date_range, color: Colors.indigoAccent),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                locale: const Locale('es', 'ES'),  // Ajusta el DatePicker al español
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd', 'es_ES').format(pickedDate);
                controller.text = formattedDate;
              }
            },
          ),
        ),
      ),
    );
  }


  Widget _textFieldRemision() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: con.remisionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Remision',
          prefixIcon: Icon(Icons.receipt, color: Colors.indigoAccent),
        ),
      ),
    );
  }


  Widget _textFieldPeso() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        // controller: con.pesoController, // Asegúrate de tener un controlador para este campo en tu controlador
        keyboardType: TextInputType.number, // Cambia el tipo de teclado a numérico
        decoration: InputDecoration(
          hintText: 'Peso',
          prefixIcon: Icon(Icons.scale, color: Colors.indigoAccent), // Puedes cambiar el ícono si lo deseas
        ),
      ),
    );
  }

  Widget _textFieldMaterial() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        // controller: con.materialController, // Asegúrate de tener un controlador para este campo en tu controlador
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Material',
          prefixIcon: Icon(Icons.category, color: Colors.indigoAccent), // Puedes cambiar el ícono si lo deseas
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
            color: Colors.indigoAccent, // Color del icono cambiado a azul
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Tipo de la solicitud',
          style: TextStyle(fontSize: 15),
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


  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Observacion',
            prefixIcon: Icon(Icons.password_sharp, color: Colors.indigoAccent) // Color del icono cambiado a azul
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 30),
      child: ElevatedButton(
          onPressed: () {
            con.createProduct(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.indigoAccent, // Cambiado de color predeterminado a Colors.blue
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
        margin: EdgeInsets.only(top: 0),
        alignment: Alignment.topCenter,
        child: Text(
          'SOLICITAR TRASLADO',
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

}