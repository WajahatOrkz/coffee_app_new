import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required String id,
    required String name,
    required String address,
    double? latitude,
    double? longitude,
  }) : super(
          id: id,
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude,
        );

  factory StoreModel.fromJson(Map<String, dynamic> json, String id) {
    return StoreModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] is num ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] is num ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  StoreEntity toEntity() {
    return StoreEntity(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
