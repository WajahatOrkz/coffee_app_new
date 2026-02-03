import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;


    @override
  User? getCurrentUser() => _auth.currentUser;

  // Login k liye
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

  // REGISTER k liye
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
      // await user.updateDisplayName(name);

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
