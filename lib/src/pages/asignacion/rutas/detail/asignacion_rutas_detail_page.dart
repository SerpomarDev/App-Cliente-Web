import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/detail/asignacion_rutas_detail_controller.dart';

class AsignacionRutasDetailPage extends StatelessWidget {
  Product? product;
  late AsignacionRutasDetailController con;
  var counter = 1.obs; // Inicializa counter en 1

  AsignacionRutasDetailPage({@required this.product}) {
    con = Get.put(AsignacionRutasDetailController());
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductsWasAdded(product!, counter);
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(245, 245, 245, 1.0),
        height: 0,
        child: _buttonsAddToBag(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageSlideshow(context),
            _textNameProduct(),
            _textDetail("Ruta seleccionada: ", product?.selectedRoute ?? ''),
            _textDetail("Fecha de almacén del puerto: ", product?.portWarehouseDate ?? ''),
            _textDetail("Fecha de días libres: ", product?.freeDaysDate ?? ''),
            _textDetail("URL de adjunto: ", product?.attachmentUrl ?? ''),
            _textDetail("Tipos de contenedor: ", product?.containerTypes ?? ''),
            _textDetail("Fecha de retiro del patio: ", product?.patioWithdrawalDate ?? ''),
            _textDetail("Remisión: ", product?.remision ?? ''),
            _textDetail("Observaciones: ", product?.description ?? ''),
            _textDetail("Fecha de vencimiento: ", product?.expirationDate ?? ''),
            _textDetail("Fecha de carga: ", product?.loadingDate ?? ''),
            _textDetail("Número de contenedores: ", product?.numContainers?.toString() ?? ''),
          ],
        ),
      ),
    ));
  }

  Widget _textDetail(String title, String value) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, left: 30, right: 30),
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: Text('DATOS DE LA SOLICITUD',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Color(0xFF0073FF),
        ),
      ),
    );
  }

  Widget _buttonsAddToBag() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 25),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  '${counter.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.40,
      initialPage: 0,
      indicatorColor: Color(0xFF0073FF),
      indicatorBackgroundColor: Colors.grey,
      children: [
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: product!.image1 != null
              ? NetworkImage(product!.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
      ],
    );
  }
}
