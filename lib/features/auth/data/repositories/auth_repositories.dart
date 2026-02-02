// import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../../domain/entities/user_entity.dart';


// class AuthRepositoryImpl implements AuthRepository {

//   final FirebaseAuth auth= FirebaseAuth.instance;
//   // Dummy data storage
//   final List<Map<String, String>> _users = [
//     {
//       'id': '1',
//       'name': 'Ahmed Ali',
//       'email': 'ahmed@example.com',
//       'password': '123456',
//       'token': 'token',
//     },
//     {
//       'id': '2',
//       'name': 'Fatima Khan',
//       'email': 'fatima@example.com',
//       'password': 'password',
//       'token': 'token'
//     },
//   ];

//   @override
//   Future<UserEntity> login(String email, String password) async {
    
//     await Future.delayed(const Duration(seconds: 1));

//     final user = _users.firstWhere(

//       (u) => u['email'] == email && u['password'] == password,
      
//       orElse: () => throw Exception('Invalid email or password'),
//     );

//     // Return UserEntity (not model)
//     return UserEntity(
//       id: user['id']!,
//       name: user['name']!,
//       email: user['email']!,
//       token: 'dummy_token_${user['id']}',
//     );
//   }

//   @override
//   Future<UserEntity> register(String name, String email, String password) async {
   
//     await Future.delayed(const Duration(seconds: 1));

  
//     final exists = _users.any((u) => u['email'] == email);
    
//     if (exists) {
//       throw Exception('Email already registered');
//     }

//     // Create new user
//     final newUserId = (_users.length + 1).toString();

//     final newUser = {
//       'id': newUserId,
//       'name': name,
//       'email': email,
//       'password': password,
//     };

//     _users.add(newUser);

//     return UserEntity(
//       id: newUserId,
//       name: name,
//       email: email,
//       token: 'dummy_token_$newUserId',
//     );
//   }
// }


import 'package:coffee_app/features/coffee/domain/entities/user_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;


    @override
  User? getCurrentUser() => _auth.currentUser;

  
  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final UserCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserCredential.user;
      if (user == null) {
        throw Exception("User not found");
      }

      return UserEntity(
        id: user.uid,
        name: user.displayName ?? "User",
        email: user.email ?? "",
        token: await user.getIdToken() ?? 
        '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // 📝 REGISTER
  @override
  Future<UserEntity> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception("User creation failed");
      }

      // Optional: save name
      await user.updateDisplayName(name);

      return UserEntity(
        id: user.uid,
        name: name,
        email: email,
        token: await user.getIdToken()?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    }
  }

 @override
  Future<void> logout() async {
    await _auth.signOut();
    
  }
}
