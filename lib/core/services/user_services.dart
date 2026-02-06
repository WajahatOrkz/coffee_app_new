import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Rx<User?> firebaseUser = Rx<User?>(null);
  
  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }
  
  String? get currentUserId => _auth.currentUser?.uid;
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
}