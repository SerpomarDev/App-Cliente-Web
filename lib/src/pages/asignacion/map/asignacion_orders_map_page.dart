// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:serpomar_client/src/pages/asignacion/orders/map/asignacion_orders_map_controller.dart';
// import 'package:serpomar_client/src/pages/conductor/orders/map/conductor_orders_map_controller.dart';
//
//
// class AsignacionOrdersMapPage extends StatelessWidget {
//
//   AsignacionOrdersMapController con = Get.put(AsignacionOrdersMapController());
//   //
//   // @override
//   // Widget build(BuildContext context) {
//   //   return GetBuilder<AsignacionOrdersMapController> (
//   //       builder: (value) => Scaffold(
//   //         backgroundColor: Colors.grey[900],
//   //         body: Stack(
//   //           children: [
//   //             Container(
//   //                 height: MediaQuery.of(context).size.height * 0.68,
//   //                 child: _googleMaps()
//   //             ),
//   //             SafeArea(
//   //               child: Column(
//   //                 children: [
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       _buttonBack(),
//   //                       _iconCenterMyLocation(),
//   //                     ],
//   //                   ),
//   //                   Spacer(),
//   //                   _cardOrderInfo(context),
//   //                 ],
//   //               ),
//   //             ),
//   //             // _buttonAccept(context)
//   //           ],
//   //         ),
//   //       ));
//   // }
//   //
//   // Widget _buttonBack() {
//   //   return Container(
//   //     alignment: Alignment.centerLeft,
//   //     margin: EdgeInsets.only(left: 5),
//   //     child: IconButton(
//   //       onPressed: () => Get.back(),
//   //       icon: Icon(
//   //         Icons.arrow_back_ios,
//   //         color: Colors.indigo,
//   //         size: 30,
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _cardOrderInfo(BuildContext context) {
//   //   return Container(
//   //     height: MediaQuery.of(context).size.height * 0.33,
//   //     width: double.infinity,
//   //     decoration: BoxDecoration(
//   //         color: Colors.grey[200],
//   //         borderRadius: BorderRadius.only(
//   //           topRight: Radius.circular(20),
//   //           topLeft: Radius.circular(20),
//   //         ),
//   //         boxShadow: [
//   //           BoxShadow(
//   //               color: Colors.black.withOpacity(0.5),
//   //               spreadRadius: 7,
//   //               blurRadius: 8,
//   //               offset: Offset(0, 5)
//   //           )
//   //         ]
//   //     ),
//   //     child: Column(
//   //       children: [
//   //         _listTileAddress(
//   //             con.order.address?.neighborhood ?? '',
//   //             'Barrio',
//   //             Icons.my_location
//   //         ),
//   //         _listTileAddress(
//   //             con.order.address?.address ?? '',
//   //             'Direccion',
//   //             Icons.location_on
//   //         ),
//   //         Divider(color: Colors.grey, endIndent: 30, indent: 30),
//   //         _deliveryInfo(),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _deliveryInfo() {
//   //   return Container(
//   //     margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
//   //     child: Row(
//   //       children: [
//   //         _imageClient(),
//   //         SizedBox(width: 15),
//   //         Text(
//   //           '${con.order.delivery?.name ?? ''} ${con.order.delivery?.lastname ?? ''}',
//   //           style: TextStyle(
//   //               color: Colors.black,
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.bold
//   //           ),
//   //           maxLines: 1,
//   //         ),
//   //         Spacer(),
//   //         Container(
//   //           decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.all(Radius.circular(15)),
//   //               color: Colors.lightGreenAccent[200]
//   //           ),
//   //           child: IconButton(
//   //             onPressed: () => con.callNumber(),
//   //             icon: Icon(Icons.phone, color: Colors.indigoAccent),
//   //           ),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _imageClient() {
//   //   return Container(
//   //     height: 50,
//   //     width: 50,
//   //     // padding: EdgeInsets.all(2),
//   //     child: ClipRRect(
//   //       borderRadius: BorderRadius.circular(12),
//   //       child: FadeInImage(
//   //         image: con.order.delivery!.image != null
//   //             ? NetworkImage(con.order.delivery!.image!)
//   //             : AssetImage('assets/img/no-image.png') as ImageProvider,
//   //         fit: BoxFit.cover,
//   //         fadeInDuration: Duration(milliseconds: 50),
//   //         placeholder:  AssetImage('assets/img/no-image.png'),
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _listTileAddress(String title, String subtitle, IconData iconData) {
//   //   return Container(
//   //     margin: EdgeInsets.symmetric(horizontal: 20),
//   //     child: ListTile(
//   //       title: Text(
//   //         title,
//   //         style: TextStyle(
//   //             fontSize: 15,
//   //             color: Colors.black,
//   //             fontWeight: FontWeight.bold
//   //
//   //         ),
//   //       ),
//   //       subtitle: Text(
//   //         subtitle,
//   //         style: TextStyle(
//   //             color: Colors.black
//   //         ),
//   //       ),
//   //       trailing: Icon(iconData, color: Colors.indigoAccent,),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _iconCenterMyLocation() {
//   //   return GestureDetector(
//   //     onTap: () => con.centerPosition(),
//   //     child: Container(
//   //       alignment: Alignment.centerRight,
//   //       margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//   //       child: Card(
//   //         shape: CircleBorder(),
//   //         color: Colors.white,
//   //         elevation: 4,
//   //         child: Container(
//   //           padding: EdgeInsets.all(10),
//   //           child: Icon(
//   //             Icons.location_searching,
//   //             color: Colors.grey[600],
//   //             size: 20,
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   //
//   // Widget _googleMaps() {
//   //   return GoogleMap(
//   //     initialCameraPosition: con.initialPosition,
//   //     mapType: MapType.normal,
//   //     onMapCreated: con.onMapCreate,
//   //     myLocationButtonEnabled: false,
//   //     myLocationEnabled: false,
//   //     markers: Set<Marker>.of(con.markers.values),
//   //     polylines: con.polylines,
//   //   );
//   // }
// }
