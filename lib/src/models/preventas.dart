import 'dart:convert';

class Preventas {
  int? id;
  int idPlaca;
  int idConductor;
  String estadoPuerto;
  String proyecto;
  String operativo;
  String estado;
  String flota;
  int inactivo;
  DateTime createdAt;
  DateTime updatedAt;

  Preventas({
    this.id,
    required this.idPlaca,
    required this.idConductor,
    required this.estadoPuerto,
    required this.proyecto,
    required this.operativo,
    required this.estado,
    required this.flota,
    this.inactivo = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preventas.fromJson(Map<String, dynamic> json) => Preventas(
    id: json['id'],
    idPlaca: json['id_placa'],
    idConductor: json['id_conductor'],
    estadoPuerto: json['estado_puerto'],
    proyecto: json['proyecto'],
    operativo: json['operativo'],
    estado: json['estado'],
    flota: json['flota'],
    inactivo: json['inactivo'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_placa': idPlaca,
    'id_conductor': idConductor,
    'estado_puerto': estadoPuerto,
    'proyecto': proyecto,
    'operativo': operativo,
    'estado': estado,
    'flota': flota,
    'inactivo': inactivo,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  static String preventasToJson(Preventas data) {
    return json.encode(data.toJson());
  }

  static Preventas preventasFromJson(String str) {
    return Preventas.fromJson(json.decode(str));
  }
}
