import 'package:coffee_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';

import 'package:coffee_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:coffee_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);

    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => SignUpController());
    // Get.lazyPut(()=> LogoutController());
  }
}
