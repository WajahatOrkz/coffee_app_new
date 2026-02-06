import 'package:coffee_app/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<void> logout();
  User? getCurrentUser();
  Stream<User?> authStateChanges();


}
