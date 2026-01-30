import 'package:coffee_app/features/coffe/domain/entities/user_entity.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
