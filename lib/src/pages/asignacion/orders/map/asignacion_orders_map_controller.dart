import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serpomar_client/src/environment/environment.dart';
import 'package:serpomar_client/src/models/order.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class AsignacionOrdersMapController extends GetxController {
  Timer? updateTimer;
  Socket socket = io('${Enviroment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(10.4187453, -75.5194536),
      zoom: 14
  );

  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? redMarker;
  BitmapDescriptor? greenMarker;
  BitmapDescriptor? blueMarker;

  AsignacionOrdersMapController() {
    print('Order: ${order.toJson()}');
    connectAndListen();
  }

  @override
  void onInit() {
    super.onInit();
    initializeMarkers();
    updateLocation();
    updateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      updateLocation();
    });
  }

  void initializeMarkers() async {
    deliveryMarker = await createMarkerFromAssets('assets/img/delivery_little.png', 40, 40);
    redMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    greenMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    blueMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    update();
  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print('Cliente conectado a Socket IO');
    });
    listenPosition();
  }

  void listenPosition() {
    socket.on('position/${order.id}', (data) {
      order.lat = data['lat'];
      order.lng = data['lng'];
      updateLocation();
    });
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path, double width, double height) async {
    final ImageConfiguration configuration = ImageConfiguration(size: Size(width, height));
    return await BitmapDescriptor.fromAssetImage(configuration, path);
  }

  void addMarker(String markerId, double lat, double lng, String title, String content, BitmapDescriptor iconMarker) {
    final MarkerId id = MarkerId(markerId);
    final Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
    update();
  }

  void updateLocation() async {
    try {
      if (deliveryMarker != null) {
        addMarker(
            'delivery',
            order.lat ?? 10.4187453,
            order.lng ?? -75.5194536,
            'Conductor',
            '',
            deliveryMarker!
        );
        addMarker(
            'marker1',
            order.address?.lat ?? 10.4187453,
            order.address?.lng ?? -75.5194536,
            'Ubicación 1',
            'Descripción de la ubicación 1',
            redMarker!
        );
        addMarker(
            'marker2',
            order.address?.lat2 ?? 10.4187453,
            order.address?.lng2 ?? -75.5194536,
            'Ubicación 2',
            'Descripción de la ubicación 2',
            greenMarker!
        );
        addMarker(
            'marker3',
            order.address?.lat3 ?? 10.4187453,
            order.address?.lng3 ?? -75.5194536,
            'Ubicación 3',
            'Descripción de la ubicación 3',
            blueMarker!
        );
        animateCameraPosition(order.lat ?? 10.4187453, order.lng ?? -75.5194536);
      }
    } catch (e) {
      print('Error: ${e}');
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15,
            bearing: 0
        )
    ));
  }


  void onMapCreate(GoogleMapController controller) {
    controller.setMapStyle('[]');
    mapController.complete(controller);
    updateLocation();
  }

  @override
  void onClose() {
    super.onClose();
    updateTimer?.cancel();
    socket.disconnect();
  }
}
