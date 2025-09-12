import 'package:flutter/foundation.dart';

@immutable
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String imageUrl;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
  });

  // Converte um Map (geralmente de JSON) para um objeto Character.
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      imageUrl: json['image'],
    );
  }

  // Converte um objeto Character para um Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': imageUrl,
    };
  }
}
