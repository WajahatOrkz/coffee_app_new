import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

class CoffeeModel {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String image;
  final double rating;

  CoffeeModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.rating,
  });

  factory CoffeeModel.fromEntity(CoffeeEntity entity) {
    return CoffeeModel(
      id: entity.id,
      name: entity.name,
      subtitle: entity.subtitle,
      price: entity.price,
      image: entity.image,
      rating: entity.rating,
    );
  }

  factory CoffeeModel.fromMap(Map<String, dynamic> map) {
    return CoffeeModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as double? ?? 0.0),
      image: map['image'] as String? ?? '',
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] as double? ?? 0.0),
    );
  }

  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    return CoffeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image'] ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'price': price,
        'image': image,
        'rating': rating,
      };

  Map<String, dynamic> toJson() => toMap();

  CoffeeEntity toEntity() {
    return CoffeeEntity(
      id: id,
      name: name,
      subtitle: subtitle,
      price: price,
      image: image,
      rating: rating,
    );
  }
}