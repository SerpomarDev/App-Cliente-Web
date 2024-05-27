import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:serpomar_client/src/pages/asignacion/address/map/asignacion_address_map_controller.dart';

class AsignacionAddressMapPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  AsignacionAddressMapController con = Get.put(AsignacionAddressMapController());

  @override
  Widget build(BuildContext context) {
    con.setSearchController(searchController);

    return Obx(() => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Ubica la ruta en el mapa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          // _googleMaps(),
          // _cardAddress(),
          // _buttonAccept(context),
          // _searchField(),
          // _iconMyLocation(), // Mueve este widget al final de la lista para que se dibuje encima de todo.
        ],
      ),
    ));
  }




//   Future<void> searchPlace() async {
//     final query = searchController.text;
//
//     final apiKey = "AIzaSyDem4aCxEGa2fYzDujN3vkdqSXtuif-Us0";
//     final apiUrl =
//         'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$query&inputtype=textquery&fields=geometry,name&key=$apiKey';
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final candidates = data['candidates'];
//
//         if (candidates.isNotEmpty) {
//           final location = candidates[0]['geometry']['location'];
//           final lat = location['lat'];
//           final lng = location['lng'];
//
//           // con.initialPosition = CameraPosition(
//           //   target: LatLng(lat, lng),
//           //   zoom: 14,
//           // );
//
//           // (await con.mapController.future).animateCamera(CameraUpdate.newCameraPosition(con.initialPosition));
//           //
//           // await con.setLocationDraggableInfo();
//         } else {
//           print('No se encontraron resultados para: $query');
//         }
//       } else {
//         print('Error en la solicitud HTTP: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error al buscar lugar: $e');
//     }
//   }
//
//   Widget _searchField() {
//     return Positioned(
//       top: 15,
//       right: 15,
//       left: 15,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextField(
//           controller: searchController,
//           decoration: InputDecoration(
//             hintText: 'Buscar dirección...',
//             border: InputBorder.none,
//             suffixIcon: IconButton(
//               icon: Icon(Icons.search),
//               onPressed: searchPlace,
//             ),
//           ),
//           onSubmitted: (value) {
//             searchPlace();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buttonAccept(BuildContext context) {
//     return Positioned(
//       bottom: 50,
//       left: 70,
//       right: 70,
//       child: ElevatedButton(
//         onPressed: () => (context),
//         child: Text('SELECCIONAR ESTE PUNTO', style: TextStyle(color: Colors.white, fontSize: 16)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF0073FF),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//         ),
//       ),
//     );
//   }
//
//   Widget _cardAddress() {
//     return Positioned(
//       top: 80,
//       left: 30,
//       right: 30,
//       child: Card(
//         color: Colors.blueGrey[800],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: EdgeInsets.all(15),
//           child: Text(
//             con.addressName.value,
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _iconMyLocation() {
//     return Positioned(
//       bottom: 190,
//       right: 10,
//       child: FloatingActionButton(
//         onPressed: () => con.updateLocation(), // Mueve la cámara a la ubicación actual
//         child: Icon(Icons.my_location, color: Colors.white),
//         backgroundColor: Colors.blueGrey,
//       ),
//     );
//   }
//
//   Widget _googleMaps() {
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: con.initialPosition,
//           mapType: MapType.normal,
//           onMapCreated: con.onMapCreate,
//           myLocationButtonEnabled: false,
//           myLocationEnabled: false,
//           onCameraMove: (position) {
//             con.initialPosition = position;
//           },
//           onCameraIdle: () async {
//             await con.setLocationDraggableInfo(); // EMPEZAR A OBTENER LA LAT Y LNG DE LA POSICION CENTRAL DEL MAPA
//           },
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: Icon(
//             Icons.location_on,
//             size: 50, // Puedes ajustar el tamaño según tus necesidades
//             color: Colors.red, // El color del icono, puedes cambiarlo según tus preferencias
//           ),
//         ),
//       ],
//     );
//   }
//
}
