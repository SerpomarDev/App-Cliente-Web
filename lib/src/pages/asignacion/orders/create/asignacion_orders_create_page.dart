import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/create/asignacion_orders_create_controller.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AsignacionOrdersCreatePage extends StatelessWidget {

  AsignacionOrdersCreateController con = Get.put(AsignacionOrdersCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx (() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: 100,
        child: _totalToPay(context),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'MI ENCARGO',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: con.selectedProducts.length > 0
          ? ListView(
        children: con.selectedProducts.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
          : Center(
          child:
          NoDataWidget(text: 'No hay ninguna ruta agregada aun')
      ),
    ));
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 0, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: 0, top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\0',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0),

                child: ElevatedButton(
                    onPressed: () => con.goToAddressList(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15)
                    ),
                    child: Text(
                      'CONFIRMAR ENCARGO',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
              )
            ],
          ),
        )

      ],
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                product.description ?? '',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 7),

            ],
          ),
          Spacer(),
          Column(
            children: [
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () => con.deleteItem(product),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }





  Widget _imageProduct(Product product) {
    return Container(
      height: 80,
      width: 80,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }
}
