import 'dart:convert';

CategoryGaleries categoryGaleriesFromJson(String str) => CategoryGaleries.fromJson(json.decode(str));

String categoryGaleriesToJson(CategoryGaleries data) => json.encode(data.toJson());

class CategoryGaleries {
  String? id;
  String? name;

  CategoryGaleries({
    required this.id,
    required this.name,
  });

  factory CategoryGaleries.fromJson(Map<String, dynamic> json) => CategoryGaleries(
    id: json["id"],
    name: json["name"],
  );

  static List<CategoryGaleries> fromJsonList(List<dynamic> jsonList) {
    List<CategoryGaleries> toList = [];

    jsonList.forEach((item) {
      CategoryGaleries categoryGaleries = CategoryGaleries.fromJson(item);
      toList.add(categoryGaleries);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
