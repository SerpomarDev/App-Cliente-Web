import 'dart:convert';

import 'package:serpomar_client/src/models/Rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

  String? id; //NULL SAFETY
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? password;
  String? placa;
  String? sessionToken;
  List<Rol>? roles_app = [];


  User({
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.phone,
    this.image,
    this.password,
    this.placa,
    this.sessionToken,
    this.roles_app
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    lastname: json["lastname"],
    phone: json["phone"],
    image: json["image"],
    password: json["password"],
    placa: json["placa"],
    sessionToken: json["session_token"],
    roles_app: json["roles_app"] == null ? [] : List<Rol>.from(json["roles_app"].map((model) => Rol.fromJson(model))),
  );

  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];

    jsonList.forEach((item) {
      User users = User.fromJson(item);
      toList.add(users);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "lastname": lastname,
    "phone": phone,
    "image": image,
    "password": password,
    "placa": placa,
    "session_token": sessionToken,
    'roles_app': roles_app
  };
}
