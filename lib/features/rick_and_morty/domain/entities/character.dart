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

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        species.hashCode ^
        imageUrl.hashCode;
  }
}
