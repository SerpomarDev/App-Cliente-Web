import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? id;
  String? name;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? idCategory;
  String? idUserCreator;
  int? quantity;
  String? selectedRoute;
  String? portWarehouseDate;
  String? fechaDate;
  String? freeDaysDate;
  String? attachmentUrl;
  String? containerTypes;
  String? patioWithdrawalDate;
  String? remision;
  String? observaciones;
  String? expirationDate;
  String? loadingDate;
  int? numContainers;
  String? doNumber;
  String? schedulingDate;
  bool isAssigned; // Nuevo campo para controlar si el producto ha sido asignado

  Product({
    this.id,
    this.name,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.idCategory,
    this.idUserCreator,
    this.quantity,
    this.selectedRoute,
    this.portWarehouseDate,
    this.fechaDate,
    this.freeDaysDate,
    this.attachmentUrl,
    this.containerTypes,
    this.patioWithdrawalDate,
    this.remision,
    this.observaciones,
    this.expirationDate,
    this.loadingDate,
    this.numContainers,
    this.doNumber,
    this.schedulingDate,
    this.isAssigned = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    idCategory: json["id_category"],
    idUserCreator: json["id_user_creator"],
    quantity: json["quantity"],
    selectedRoute: json["selected_route"],
    portWarehouseDate: json["port_warehouse_date"],
    fechaDate: json["fecha_date"],
    freeDaysDate: json["free_days_date"],
    attachmentUrl: json["attachment_url"],
    containerTypes: json["container_types"],
    patioWithdrawalDate: json["patio_withdrawal_date"],
    remision: json["remision"],
    observaciones: json["observaciones"],
    expirationDate: json["expiration_date"],
    loadingDate: json["loading_date"],
    numContainers: json["num_containers"],
    doNumber: json["do_number"],
    schedulingDate: json["scheduling_date"],
    isAssigned: json["is_assigned"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "id_category": idCategory,
    "id_user_creator": idUserCreator,
    "quantity": quantity,
    "selected_route": selectedRoute,
    "port_warehouse_date": portWarehouseDate,
    "fecha_date": fechaDate,
    "free_days_date": freeDaysDate,
    "attachment_url": attachmentUrl,
    "container_types": containerTypes,
    "patio_withdrawal_date": patioWithdrawalDate,
    "remision": remision,
    "observaciones": observaciones,
    "expiration_date": expirationDate,
    "loading_date": loadingDate,
    "num_containers": numContainers,
    "scheduling_date": schedulingDate,
    "do_number": doNumber,
    "is_assigned": isAssigned,
  };

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    List<Product> toList = [];

    jsonList.forEach((item) {
      Product product = Product.fromJson(item);
      toList.add(product);
    });

    return toList;
  }
}
