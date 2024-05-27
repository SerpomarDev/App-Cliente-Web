import 'dart:async';

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



class AsignacionOrdersMapController extends GetxController {

  Socket socket = io('${Enviroment.API_URL}orders/delivery', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  // CameraPosition initialPosition = CameraPosition(
  //     target: LatLng(10.4187453, -75.5194536),
  //     zoom: 14
  // );

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
  // AsignacionOrdersMapController() {
  //   print('Order: ${order.toJson()}');
  //
  //   checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
  //   connectAndListen();
  // }
  //
  // void connectAndListen() {
  //   socket.connect();
  //   socket.onConnect((data) {
  //     print('ESTE DISPISITIVO SE CONECTO A SOCKET IO');
  //   });
  //   listenPosition();
  //   listenToDelivered();
  // }
  //
  // void listenPosition() {
  //   socket.on('position/${order.id}', (data) {
  //
  //     addMarker(
  //         'delivery',
  //         data['lat'],
  //         data['lng'],
  //         'Conductor',
  //         '',
  //         deliveryMarker!
  //     );
  //
  //   });
  // }
  //
  // void listenToDelivered() {
  //   socket.on('delivered/${order.id}', (data) {
  //     Fluttertoast.showToast(
  //         msg: 'El estado de la orden se actualizo a finalizado',
  //         toastLength: Toast.LENGTH_LONG
  //     );
  //     Get.offNamedUntil('/asignacion/home', (route) => false);
  //   });
  // }
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
  // void selectRefPoint(BuildContext context) {
  //   if (addressLatLng != null) {
  //     Map<String, dynamic> data = {
  //       'address': addressName.value,
  //       'lat': addressLatLng!.latitude,
  //       'lng': addressLatLng!.longitude,
  //     };
  //     Navigator.pop(context, data);
  //   }
  //
  // }
  //
  // Future<BitmapDescriptor> createMarkerFromAssets(String path, double width, double height) async {
  //   final ImageConfiguration configuration = ImageConfiguration();
  //   final BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
  //     configuration,
  //     path,
  //   );
  //
  //   return descriptor;
  // }
  //
  //
  // void addMarker(
  //     String markerId,
  //     double lat,
  //     double lng,
  //     String title,
  //     String content,
  //     BitmapDescriptor iconMarker
  //     ) {
  //   final MarkerId id = MarkerId(markerId);
  //   final Marker marker = Marker(
  //     markerId: id,
  //     icon: iconMarker,
  //     position: LatLng(lat, lng),
  //     infoWindow: InfoWindow(title: title, snippet: content),
  //   );
  //
  //   markers[id] = marker;
  //   update();
  // }
  //
  //
  // void checkGPS() async {
  //   deliveryMarker = await createMarkerFromAssets('assets/img/delivery_little.png', 40.0, 40.0);
  //   homeMarker = await createMarkerFromAssets('assets/img/home.png', 40.0, 40.0);
  //
  //
  //   bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //   if (isLocationEnabled == true) {
  //     updateLocation();
  //   }
  //   else {
  //     bool locationGPS = await location.Location().requestService();
  //     if (locationGPS == true) {
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
  // void updateLocation() async {
  //   try{
  //     await _determinePosition();
  //     position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)
  //     animateCameraPosition(order.lat ?? 10.4187453, order.lng ?? -75.5194536);
  //
  //
  //     addMarker(
  //         'delivery',
  //         order.lat ?? 10.4187453,
  //         order.lng ?? -75.5194536,
  //         'Conductor',
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
  //     LatLng from = LatLng(order.lat ?? 10.4187453, order.lng ?? -75.5194536);
  //     LatLng to = LatLng(order.address?.lat ?? 10.4187453, order.address?.lng ?? -75.5194536);
  //
  //     setPolylines(from, to);
  //
  //
  //   } catch(e) {
  //     print('Error: ${e}');
  //   }
  // }
  //
  // void callNumber() async{
  //   String number = order.delivery?.phone ?? ''; //set the number here
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }
  //
  // void centerPosition() {
  //   if (position != null) {
  //     animateCameraPosition(position!.latitude, position!.longitude);
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
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //   socket.disconnect();
  //   positionSubscribe?.cancel();
  // }
}