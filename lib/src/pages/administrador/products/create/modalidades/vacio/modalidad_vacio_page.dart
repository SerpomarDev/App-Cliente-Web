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
import 'modalidad_vacio_controller.dart';

class ModalidadVacioPage extends StatelessWidget {
  ModalidadVacioController con = Get.put(ModalidadVacioController());

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
            _dropDownRoute(),
            _textFieldDO(),
            _textFieldNumContainers(),
            _dateTimeField(context, 'Fecha Retiro',
                con.portWarehouseDateController),
            Obx(() => con.isFreePoolSelected.value
                ? Container()
                : _dateTimeField(context, 'Fecha Documental',
                con.freeDaysDateController)),
            Obx(() => con.isFreePoolSelected.value
                ? _dateTimeField(context, 'Fecha Vencimiento',
                con.expirationDateController)
                : Container()),
            _dateTimeField(context, 'Fecha Cargue',
                con.loadingDateController),
            _textFieldDescription(),
            _filePicker(context),
            _textFieldRemision(),
            _buttonCreate(context)
          ],
        ),
      ),
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
          'Seleccionar opción',
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
        items: [
          DropdownMenuItem(
            child: Text('Free pool'),
            value: 'Free pool',
          ),
          DropdownMenuItem(
            child: Text('Exportación'),
            value: 'Exportación',
          ),
        ],
        value: con.selectedRoute.value == '' ? null : con.selectedRoute.value,
        onChanged: (option) {
          con.selectedRoute.value = option.toString();
          con.isFreePoolSelected.value = (option == 'Free pool');
        },
      ),
    );
  }

  Widget _textFieldNumContainers() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: con.numContainersController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '# de contenedores',
          prefixIcon: Icon(Icons.filter_frames, color: Colors.indigoAccent),
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
          labelText: 'Remisión',
          prefixIcon: Icon(Icons.receipt, color: Colors.indigoAccent),
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
          'Tipo de la solicitud',
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option) {
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  Widget _dateTimeField(BuildContext context, String labelText,
      TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        controller: controller,
        readOnly: true,
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
                locale: const Locale('es', 'ES'),
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

  Widget _filePicker(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                con.pickFile();
              },
              child: Text('Adjuntar Documento'),
            ),
            SizedBox(height: 10),
            Text(
              con.selectedFile.value?.path.split('/').last ??
                  'Ningún archivo seleccionado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    });
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: 'Observaciones',
            prefixIcon: Icon(Icons.notes, color: Colors.indigoAccent)),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 20),
      child: ElevatedButton(
          onPressed: () {
            con.createProduct(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.indigoAccent,
          ),
          child: Text(
            'Generar Solicitud',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _textNewCategory(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 0),
        alignment: Alignment.topCenter,
        child: Text(
          'SOLICITAR RET. VACÍO',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

}
