import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String? address;
  String? neighborhood;
  String? idUser;
  double? lat;
  double? lng;
  double? lat2; // Segunda latitud
  double? lng2; // Segunda longitud
  double? lat3; // Tercera latitud
  double? lng3; // Tercera longitud

  Address({
    this.id,
    this.address,
    this.neighborhood,
    this.idUser,
    this.lat,
    this.lng,
    this.lat2,
    this.lng2,
    this.lat3,
    this.lng3,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    idUser: json["id_user"],
    lat: json["lat"],
    lng: json["lng"],
    lat2: json["lat2"],
    lng2: json["lng2"],
    lat3: json["lat3"],
    lng3: json["lng3"],
  );

  static List<Address> fromJsonList(List<dynamic> jsonList) {
    List<Address> toList = [];

    jsonList.forEach((item) {
      Address address = Address.fromJson(item);
      toList.add(address);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "neighborhood": neighborhood,
    "id_user": idUser,
    "lat": lat,
    "lng": lng,
    "lat2": lat2,
    "lng2": lng2,
    "lat3": lat3,
    "lng3": lng3,
  };
}
