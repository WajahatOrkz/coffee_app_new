import '../../domain/entities/coffee_entity.dart';

class CoffeeModel extends CoffeeEntity {
  CoffeeModel({
    required super.id,
    required super.name,
    required super.subtitle,
    required super.price,
    required super.image,
    required super.rating,
  });

  // JSON se Model banao
  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    return CoffeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  // Model ko JSON banao
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'price': price,
      'image': image,
      'rating': rating,
    };
  }

  CoffeeEntity toEntity() {
  return CoffeeEntity(
    id: this.id,
    name: this.name,
    price: this.price,
    subtitle: this.subtitle,
    image: this.image,
    rating: this.rating
  );
}
}