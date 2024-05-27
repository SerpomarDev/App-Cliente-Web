import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:serpomar_client/src/models/response_api.dart';
import 'package:serpomar_client/src/providers/orders_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';



class ConductorOrdersMapController extends GetxController {

  String finishTime = ''; // Variable para almacenar la hora de finalización

  Socket socket = io('${Enviroment.API_URL}orders/delivery', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });

  // Método para establecer la hora de finalización
  void setFinishTime(String time) {
    finishTime = time;
  }

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  // CameraPosition initialPosition = CameraPosition(
  //     target: LatLng(10.4187453, -75.5194536),
  //     zoom: 14
  // );
  //
  // LatLng? addressLatLng;
  // var addressName = ''.obs;
  //
  // Completer<GoogleMapController> mapController = Completer();
  // Position? position;
  //
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  // BitmapDescriptor? deliveryMarker;
  // BitmapDescriptor? homeMarker;
  //
  // StreamSubscription? positionSubscribe;
  //
  // Set<Polyline> polylines = <Polyline>{}.obs;
  // List<LatLng> points = [];
  //
  // double distanceBetween = 0.0;
  // bool isClose = false;
  //
  // ConductorOrdersMapController() {
  //   print('Order: ${order.toJson()}');
  //
  //   checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
  //   connectAndListen();
  // }
  //
  // void isCloseToDeliveryPosition() {
  //
  //   if (position != null) {
  //     distanceBetween = Geolocator.distanceBetween(
  //         position!.latitude,
  //         position!.longitude,
  //         order.address!.lat!,
  //         order.address!.lng!
  //     );
  //
  //     print('distanceBetween ${distanceBetween}');
  //
  //     if (distanceBetween <= 200 && isClose == false) {
  //       isClose = true;
  //       update();
  //     }
  //   }
  // }
  //
  // void connectAndListen() {
  //   socket.connect();
  //   socket.onConnect((data) {
  //     print('ESTE DISPISITIVO SE CONECTO A SOCKET IO');
  //   });
  // }
  //
  // void emitPosition() {
  //   if (position != null) {
  //     socket.emit('position', {
  //       'id_order': order.id,
  //       'lat': position!.latitude,
  //       'lng': position!.longitude,
  //     });
  //   }
  // }
  //
  // void emitToDelivered() {
  //   socket.emit('delivered', {
  //     'id_order': order.id,
  //   });
  // }
  //
  //
  // Future setLocationDraggableInfo() async {
  //
  //   double lat = initialPosition.target.latitude;
  //   double lng = initialPosition.target.longitude;
  //
  //   List<Placemark> address = await placemarkFromCoordinates(lat, lng);
  //
  //   if (address.isNotEmpty) {
  //     String direction = address[0].thoroughfare ?? '';
  //     String street = address[0].subThoroughfare ?? '';
  //     String city = address[0].locality ?? '';
  //     String department = address[0].administrativeArea ?? '';
  //     String country = address[0].country ?? '';
  //     addressName.value = '$direction #$street, $city, $department';
  //     addressLatLng = LatLng(lat, lng);
  //     print('LAT Y LNG: ${addressLatLng?.latitude ?? 0} ${addressLatLng?.longitude ?? 0}');
  //   }
  //
  // }
  //
  // Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
  //   ImageConfiguration configuration = ImageConfiguration();
  //   BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
  //       configuration, path
  //   );
  //
  //   return descriptor;
  // }
  //
  // void addMarker(
  //     String markerId,
  //     double lat,
  //     double lng,
  //     String title,
  //     String content,
  //     BitmapDescriptor iconMarker
  //     ) {
  //   MarkerId id = MarkerId(markerId);
  //   Marker marker = Marker(
  //       markerId: id,
  //       icon: iconMarker,
  //       position: LatLng(lat, lng),
  //       infoWindow: InfoWindow(title: title, snippet: content)
  //   );
  //
  //   markers[id] = marker;
  //
  //   update();
  // }
  //
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(
  //       data.buffer.asUint8List(),
  //       targetWidth: width
  //   );
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  // }
  //
  // Future<BitmapDescriptor> createResizedMarkerFromAssets(String path, int width) async {
  //   Uint8List markerImage = await getBytesFromAsset(path, width);
  //   return BitmapDescriptor.fromBytes(markerImage);
  // }
  //
  // void checkGPS() async {
  //   // Asegúrate de que este método se llame en un lugar donde tengas acceso a un BuildContext
  //   // Por ejemplo, podría llamarse desde el método build de un widget.
  //   double screenSize = MediaQuery.of(Get.context!).size.width; // Usar Get.context si estás usando el paquete GetX
  //   int iconSize = (screenSize / 4).round();
  //
  //   deliveryMarker = await createResizedMarkerFromAssets('assets/img/delivery_little.png', iconSize);
  //   homeMarker = await createMarkerFromAssets('assets/img/home.png');
  //
  //   bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (isLocationEnabled) {
  //     updateLocation();
  //   } else {
  //     bool locationGPS = await location.Location().requestService();
  //     if (locationGPS) {
  //       updateLocation();
  //     }
  //   }
  // }
  //
  // Future<void> setPolylines(LatLng from, LatLng to) async {
  //   PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
  //   PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
  //   PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
  //       Enviroment.API_KEY_MAPS,
  //       pointFrom,
  //       pointTo
  //   );
  //
  //   for (PointLatLng point in result.points) {
  //     points.add(LatLng(point.latitude, point.longitude));
  //   }
  //
  //   Polyline polyline = Polyline(
  //       polylineId: PolylineId('poly'),
  //       color: Colors.indigoAccent,
  //       points: points,
  //       width: 5
  //   );
  //
  //   polylines.add(polyline);
  //   update();
  // }
  //
  // void updateToDelivered() async {
  //   if (distanceBetween <= 200) {
  //     ResponseApi responseApi = await ordersProvider.updateToDelivered(order);
  //     Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
  //     if (responseApi.success == true) {
  //       emitToDelivered();
  //       Get.offNamedUntil('/conductor/home', (route) => false);
  //     }
  //   }
  //   else {
  //     Get.snackbar('Operacion no permitida', 'Debes estar mas cerca a la posicion de entrega del encargo');
  //   }
  // }
  //
  // void updateLocation() async {
  //   try{
  //     await _determinePosition();
  //     position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)
  //     saveLocation();
  //     animateCameraPosition(position?.latitude ?? 10.4187453, position?.longitude ?? -75.5194536);
  //
  //     addMarker(
  //         'delivery',
  //         position?.latitude ?? 10.4187453,
  //         position?.longitude ?? -75.5194536,
  //         'Tu posicion',
  //         '',
  //         deliveryMarker!
  //     );
  //
  //     addMarker(
  //         'Entrega',
  //         order.address?.lat ?? 10.4187453,
  //         order.address?.lng ?? -75.5194536,
  //         'Lugar de entrega',
  //         '',
  //         homeMarker!
  //     );
  //
  //     LatLng from = LatLng(position!.latitude, position!.longitude);
  //     LatLng to = LatLng(order.address?.lat ?? 10.4187453, order.address?.lng ?? -75.5194536);
  //
  //     setPolylines(from, to);
  //
  //     LocationSettings locationSettings = LocationSettings(
  //         accuracy: LocationAccuracy.best,
  //         distanceFilter: 1
  //     );
  //
  //     positionSubscribe = Geolocator.getPositionStream(
  //         locationSettings: locationSettings
  //     ).listen((Position pos ) { // POSICION EN TIEMPO REAL
  //       position = pos;
  //       addMarker(
  //           'delivery',
  //           position?.latitude ?? 10.4187453,
  //           position?.longitude ?? -75.5194536,
  //           'Tu posicion',
  //           '',
  //           deliveryMarker!
  //       );
  //       animateCameraPosition(position?.latitude ?? 10.4187453, position?.longitude ?? -75.5194536);
  //       emitPosition();
  //       isCloseToDeliveryPosition();
  //     });
  //
  //   } catch(e) {
  //     print('Error: ${e}');
  //   }
  // }
  //
  // void callNumber() async{
  //   String number = order.client?.phone ?? ''; //set the number here
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }
  //
  // void centerPosition() {
  //   if (position != null) {
  //     animateCameraPosition(position!.latitude, position!.longitude);
  //   }
  // }
  //
  // void saveLocation() async {
  //   if (position != null) {
  //     order.lat = position!.latitude;
  //     order.lng = position!.longitude;
  //     await ordersProvider.updateLatLng(order);
  //   }
  // }
  //
  // Future animateCameraPosition(double lat, double lng) async {
  //   GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target: LatLng(lat, lng),
  //           zoom: 15,
  //           bearing: 0
  //       )
  //   ));
  // }
  //
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //
  //   return await Geolocator.getCurrentPosition();
  // }
  //
  // void onMapCreate(GoogleMapController controller) {
  //   controller.setMapStyle('[]');
  //   mapController.complete(controller);
  // }
  //
  // void goToImgencargo() {
  //   Get.toNamed('/conductor/orders/imgencargo');
  // }
  //
  // // Agrega un controlador de diálogo
  // final RxBool confirmDialogResult = false.obs;
  //
  // void showConfirmationDialog() {
  //   Get.defaultDialog(
  //     title: "¿Ya subió las imágenes?",
  //     titlePadding: EdgeInsets.only(top: 20), // Espaciado superior
  //     content: Container(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Text(
  //               "Por favor, confirme si ya ha subido las imágenes del encargo.",
  //               style: TextStyle(fontSize: 16, color: Colors.black),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   confirmDialogResult.value = true; // Usuario dijo "Sí"
  //                   Get.back(); // Cierra el diálogo
  //                   Fluttertoast.showToast(
  //                     msg: "Ya puede FINALIZAR la asignación",
  //                     toastLength: Toast.LENGTH_SHORT, // Duración del toast
  //                     gravity: ToastGravity.CENTER, // Posición del toast
  //                   );
  //                 },
  //                 child: Text("Sí", style: TextStyle(color: Colors.white)),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.green,
  //                 ),
  //               ),ese
  //               ElevatedButton(
  //                 onPressed: () {
  //                   confirmDialogResult.value = false; // Usuario dijo "No"
  //                   Get.back(); // Cierra el diálogo
  //                   Fluttertoast.showToast(
  //                     msg: "SUBIR las imágenes",
  //                     toastLength: Toast.LENGTH_SHORT, // Duración del toast
  //                     gravity: ToastGravity.CENTER, // Posición del toast
  //                   );
  //                 },
  //                 child: Text("No", style: TextStyle(color: Colors.white)),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.red,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  //
  //
  //
  //
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //   socket.disconnect();
  //   positionSubscribe?.cancel();
  // }
}