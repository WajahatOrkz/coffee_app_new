import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';

import '../../domain/entities/user_entity.dart';


class AuthRepositoryImpl implements AuthRepository {
  // Dummy data storage
  final List<Map<String, String>> _users = [
    {
      'id': '1',
      'name': 'Ahmed Ali',
      'email': 'ahmed@example.com',
      'password': '123456',
      'token': 'token',
    },
    {
      'id': '2',
      'name': 'Fatima Khan',
      'email': 'fatima@example.com',
      'password': 'password',
      'token': 'token'
    },
  ];

  @override
  Future<UserEntity> login(String email, String password) async {
    
    await Future.delayed(const Duration(seconds: 1));

    final user = _users.firstWhere(

      (u) => u['email'] == email && u['password'] == password,
      
      orElse: () => throw Exception('Invalid email or password'),
    );

    // Return UserEntity (not model)
    return UserEntity(
      id: user['id']!,
      name: user['name']!,
      email: user['email']!,
      token: 'dummy_token_${user['id']}',
    );
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
   
    await Future.delayed(const Duration(seconds: 1));

  
    final exists = _users.any((u) => u['email'] == email);
    
    if (exists) {
      throw Exception('Email already registered');
    }

    // Create new user
    final newUserId = (_users.length + 1).toString();

    final newUser = {
      'id': newUserId,
      'name': name,
      'email': email,
      'password': password,
    };

    _users.add(newUser);

    return UserEntity(
      id: newUserId,
      name: name,
      email: email,
      token: 'dummy_token_$newUserId',
    );
  }
}