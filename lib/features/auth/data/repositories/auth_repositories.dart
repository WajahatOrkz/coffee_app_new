import 'dart:io';

import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/features/coffee/domain/entities/user_entity.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? getCurrentUser() => _auth.currentUser;

  @override
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

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
        token: await user.getIdToken() ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // 📝 REGISTER
  @override
  Future<UserEntity> register(
    String name,
    String email,
    String password,
  ) async {
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
        token: await user.getIdToken() ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    }
  }

  // 🔑 GOOGLE SIGN-IN
  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with serverClientId on Android
      // The serverClientId is the Web OAuth 2.0 Client ID from Google Cloud Console
      final String? serverClientId = Platform.isAndroid
          ? '549640564957-s9qo8eld8j8nke29veg3ikp9d02l401m.apps.googleusercontent.com'
          : null;

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .initialize(serverClientId: serverClientId)
          .then((_) => GoogleSignIn.instance.authenticate());

      if (googleUser == null) {
        throw Exception("Google Sign-In was cancelled");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("Failed to sign in with Google");
      }

      return UserEntity(
        id: user.uid,
        name: user.displayName ?? "Google User",
        email: user.email ?? "",
        token: await user.getIdToken() ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Google Sign-In failed");
    } catch (e) {
      throw Exception("Google Sign-In error: ${e.toString()}");
    }
  }
  
  @override
  Future<void> logout() {
    throw UnimplementedError();
  } 



}
