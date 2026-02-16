import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required String id,
    required String name,
    required String address,
  }) : super(id: id, name: name, address: address);

  factory StoreModel.fromJson(Map<String, dynamic> json, String id) {
    return StoreModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address};
  }

  StoreEntity toEntity() {
    return StoreEntity(id: id, name: name, address: address);
  }
}
