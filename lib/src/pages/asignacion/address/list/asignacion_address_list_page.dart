import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/address.dart';
import 'package:serpomar_client/src/pages/asignacion/address/list/asignacion_address_list_controller.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AsignacionAddressListPage extends StatelessWidget {

  AsignacionAddressListController con = Get.put(AsignacionAddressListController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'RUTAS',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        actions: [
          _iconAddressCreate()
        ],
      ),
      body: GetBuilder<AsignacionAddressListController> ( builder: (value) => Stack(
        children: [
          _textSelectAddress(),
          _listAddress(context)
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.createOrder(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ENCARGAR',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: con.getAddress(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorAddress(snapshot.data![index], index);
                    }
                );
              }
              else {
                return Center(
                  child: NoDataWidget(text: 'No hay rutas'),
                );
              }
            }
            else {
              return Center(
                child: NoDataWidget(text: 'No hay rutas'),
              );
            }
          }
      ),
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: con.radioValue.value,
                onChanged: con.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.address ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    address.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12
                    ),
                  )
                ],
              )
            ],
          ),
          Divider(color: Colors.grey[400])
        ],
      ),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        'Selecciona la ruta a encargar',
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.black,
        )
    );
  }
}
