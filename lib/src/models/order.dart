import 'dart:convert';

import 'package:serpomar_client/src/models/address.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/models/user.dart';



Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String? id;
  String? idClient;
  String? idDelivery;
  String? idAddress;
  String? status;
  double? lat;
  double? lng;
  double? lat2; // Segunda latitud
  double? lng2; // Segunda longitud
  double? lat3; // Tercera latitud
  double? lng3; // Tercera longitud
  String? citaPuerto;
  DateTime? update_at;
  int? timestamp;
  int? destinationReached; // Añadido para registrar el destino alcanzado
  List<Product>? products = [];
  User? client;
  User? delivery;
  Address? address;

  Order({
    this.id,
    this.idClient,
    this.idDelivery,
    this.idAddress,
    this.status,
    this.lat,
    this.lng,
    this.lat2,
    this.lng2,
    this.lat3,
    this.lng3,
    this.citaPuerto,
    this.update_at,
    this.timestamp,
    this.destinationReached, // Inicializado aquí
    this.products,
    this.client,
    this.delivery,
    this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    idClient: json["id_client"],
    idDelivery: json["id_delivery"],
    idAddress: json["id_address"],
    status: json["status"],
    lat: json["lat"],
    lng: json["lng"],
    lat2: json["lat2"],
    lng2: json["lng2"],
    lat3: json["lat3"],
    lng3: json["lng3"],
    citaPuerto: json["cita_puerto"],
    update_at: json["update_at"] != null ? DateTime.parse(json["update_at"]) : null,
    timestamp: json["timestamp"],
    destinationReached: json["destinationReached"],
    products: json["products"] != null ? List<Product>.from(json["products"].map((model) => model is Product ? model : Product.fromJson(model))) : [],
    client: json['client'] is String ? userFromJson(json['client']) : json['client'] is User ? json['client'] : User.fromJson(json['client'] ?? {}),
    delivery: json['delivery'] is String ? userFromJson(json['delivery']) : json['delivery'] is User ? json['delivery'] : User.fromJson(json['delivery'] ?? {}),
    address: json['address'] is String ? addressFromJson(json['address']) : json['address'] is Address ? json['address'] : Address.fromJson(json['address'] ?? {}),
  );

  static List<Order> fromJsonList(List<dynamic> jsonList) {
    List<Order> toList = [];
    jsonList.forEach((item) {
      Order order = Order.fromJson(item);
      toList.add(order);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_client": idClient,
    "id_delivery": idDelivery,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "lat2": lat2,
    "lng2": lng2,
    "lat3": lat3,
    "lng3": lng3,
    "cita_puerto": citaPuerto,
    "update_at": update_at != null ? update_at?.toIso8601String() : null,
    "timestamp": timestamp,
    "destination_reached": destinationReached, // Añadido para la serialización
    "products": products,
    "client": client,
    "delivery": delivery,
    "address": address,
  };
}
