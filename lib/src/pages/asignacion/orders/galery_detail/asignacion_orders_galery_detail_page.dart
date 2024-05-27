import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:serpomar_client/src/models/galeries.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery_detail/asignacion_orders_galery_detail_controller.dart';



class AsignacionOrdersGalery_detailPage extends StatelessWidget {

  Galeries? galeries;
  AsignacionOrdersGalery_detailController con = Get.put(AsignacionOrdersGalery_detailController());

  AsignacionOrdersGalery_detailPage({@required this.galeries});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(245, 245, 245, 1.0),
        height: 100,
      ),
      body: Column(
        children: [
          _imageSlideshow(context),
          _textNameProduct(),
          _textDescriptionProduct(),
        ],
      ),
    );
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Text(
        galeries?.name ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
        galeries?.description ?? '',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      initialPage: 0,
      indicatorColor: Colors.indigoAccent,
      indicatorBackgroundColor: Colors.grey,
      children: [
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image1 != null
              ? NetworkImage(galeries!.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image2 != null
              ? NetworkImage(galeries!.image2!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image3 != null
              ? NetworkImage(galeries!.image3!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image4 != null
              ? NetworkImage(galeries!.image4!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image5 != null
              ? NetworkImage(galeries!.image5!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
          image: galeries!.image6 != null
              ? NetworkImage(galeries!.image6!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
        ),
      ],
    );
  }
}
