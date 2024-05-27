import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serpomar_client/src/pages/conductor/orders/map/conductor_orders_map_controller.dart';

class ConductorOrdersMapPage extends StatelessWidget {
  final ConductorOrdersMapController con = Get.put(ConductorOrdersMapController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return GetBuilder<ConductorOrdersMapController>(
      builder: (value) => Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            // _googleMaps(),
            SafeArea(
              child: Column(
                children: [
                  // _topBar(theme),
                  Spacer(),
                  // _buttonImages(context),
                  // _cardOrderInfo(mediaQuery, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _topBar(ThemeData theme) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _buttonBack(theme),
  //       _iconCenterMyLocation(),
  //     ],
  //   );
  // }
  //
  // Widget _buttonBack(ThemeData theme) {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     margin: const EdgeInsets.only(left: 5),
  //     child: IconButton(
  //       onPressed: () => Get.back(),
  //       icon: Icon(
  //         Icons.arrow_back_ios,
  //         color: theme.primaryColor,
  //         size: 30,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _iconCenterMyLocation() {
  //   return GestureDetector(
  //     onTap: () => con.centerPosition(),
  //     child: Container(
  //       alignment: Alignment.centerRight,
  //       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //       child: Card(
  //         shape: CircleBorder(),
  //         color: Colors.white,
  //         elevation: 4,
  //         child: Padding(
  //           padding: const EdgeInsets.all(10),
  //           child: Icon(
  //             Icons.location_searching,
  //             color: Colors.grey[600],
  //             size: 20,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buttonImages(BuildContext context) {
  //   return Visibility(
  //     visible: con.isClose,
  //     child: Container(
  //       width: double.infinity,
  //       margin: const EdgeInsets.only(left: 120, right: 120, bottom: 5),
  //       child: ElevatedButton(
  //         onPressed: () => con.goToImgencargo(),
  //         child: const Text(
  //           'SUBIR IMÁGENES',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 15,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           padding: const EdgeInsets.all(10),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _cardOrderInfo(MediaQueryData mediaQuery, BuildContext context) {
  //   return Container(
  //     height: mediaQuery.size.height * 0.40,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200],
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(20),
  //         topLeft: Radius.circular(20),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.5),
  //           spreadRadius: 7,
  //           blurRadius: 8,
  //           offset: Offset(0, 5),
  //         )
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         _listTileAddress(
  //             con.order.address?.neighborhood ?? '',
  //             'Barrio',
  //             Icons.my_location
  //         ),
  //         _listTileAddress(
  //             con.order.address?.address ?? '',
  //             'Dirección',
  //             Icons.location_on
  //         ),
  //         Divider(color: Colors.black, endIndent: 30, indent: 30),
  //         _clientInfo(),
  //         _buttonAccept(context)
  //       ],
  //     ),
  //   );
  // }
  //
  //
  // Widget _listTileAddress(String title, String subtitle, IconData iconData) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     child: ListTile(
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //             fontSize: 15,
  //             color: Colors.indigoAccent,
  //             fontWeight: FontWeight.bold
  //         ),
  //       ),
  //       subtitle: Text(
  //         subtitle,
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       trailing: Icon(iconData, color: Colors.indigoAccent),
  //     ),
  //   );
  // }
  //
  // Widget _clientInfo() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
  //     child: Row(
  //       children: [
  //         _imageClient(),
  //         SizedBox(width: 15),
  //         Text(
  //           'Asignador: ${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''}',
  //           style: TextStyle(
  //             color: Colors.black87,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //           maxLines: 2,
  //         ),
  //         Spacer(),
  //         _callButton()
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _imageClient() {
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(10),
  //       child: FadeInImage(
  //         image: con.order.client!.image != null
  //             ? NetworkImage(con.order.client!.image!)
  //             : AssetImage('assets/img/no-image.png') as ImageProvider,
  //         fit: BoxFit.cover,
  //         fadeInDuration: Duration(milliseconds: 50),
  //         placeholder: AssetImage('assets/img/no-image.png'),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _callButton() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(15)),
  //         color: Colors.lightGreenAccent[200]
  //     ),
  //     child: IconButton(
  //       onPressed: () => con.callNumber(),
  //       icon: Icon(Icons.phone, color: Colors.indigoAccent),
  //     ),
  //   );
  // }
  //
  // Widget _buttonAccept(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     margin: EdgeInsets.only(left: 30, right: 30),
  //     child: ElevatedButton(
  //       onPressed: con.isClose == true
  //           ? () async {
  //         con.showConfirmationDialog();
  //         await Future.delayed(Duration.zero); // Espera para permitir que se actualice confirmDialogResult
  //         if (con.confirmDialogResult.value) {
  //           con.updateToDelivered();
  //         } else {
  //           con.goToImgencargo();
  //         }
  //       }
  //           : null,
  //       child: Text(
  //         'FINALIZAR ASIGNACIÓN',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 15,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         padding: EdgeInsets.all(15),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _googleMaps() {
  //   return GoogleMap(
  //     initialCameraPosition: con.initialPosition,
  //     mapType: MapType.normal,
  //     onMapCreated: con.onMapCreate,
  //     myLocationButtonEnabled: false,
  //     myLocationEnabled: false,
  //     markers: Set<Marker>.of(con.markers.values),
  //     polylines: con.polylines,
  //   );
  // }
}
