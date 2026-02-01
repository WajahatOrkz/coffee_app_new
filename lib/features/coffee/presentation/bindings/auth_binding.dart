import 'package:coffee_app/features/coffee/data/respositories/auth_repositories.dart';
import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/login.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/signup.dart';
import 'package:get/get.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    
    // Controllers
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
  }
}