import 'package:coffee_app/features/coffee/data/respositories/auth_repositories.dart';
import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/features/auth/presentation/controllers/login.dart';
import 'package:coffee_app/features/auth/presentation/controllers/signup.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';



class AuthBinding extends Bindings {
  @override
  void dependencies() {

    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    
    // Controllersy
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
  }
}