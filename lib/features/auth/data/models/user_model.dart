import 'package:coffee_app/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: this.id,
      name: this.name,
      email: this.email,
      token: this.token,
    );
  }
}
