import 'dart:convert';

Galeries galeriesFromJson(String str) => Galeries.fromJson(json.decode(str));

String galeriesToJson(Galeries data) => json.encode(data.toJson());

class Galeries {
  String? id;
  String? name;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? image6;
  String? idCategoryGaleries;

  Galeries({
     this.id,
     this.name,
     this.description,
     this.image1,
    this.image2,
     this.image3,
     this.image4,
     this.image5,
     this.image6,
 this.idCategoryGaleries,
  });

  factory Galeries.fromJson(Map<String, dynamic> json) => Galeries(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    image4: json["image4"],
    image5: json["image5"],
    image6: json["image6"],
    idCategoryGaleries: json["id_category_galeries"],
  );

  static List<Galeries> fromJsonList(List<dynamic> jsonList) {
    List<Galeries> toList = [];

    jsonList.forEach((item) {
      Galeries galeries = Galeries.fromJson(item);
      toList.add(galeries);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "image5": image5,
    "image6": image6,
    "id_category_galeries": idCategoryGaleries,
  };
}