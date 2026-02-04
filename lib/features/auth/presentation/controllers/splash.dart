// import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
// import 'package:coffee_app/routes/routes.dart';
// import 'package:get/get.dart';
// class SplashController extends GetxController {
//   final AuthRepository _repository = Get.find<AuthRepository>();

//   @override
//   void onInit() {
//     super.onInit();
//     _checkLoginStatus();
//   }

//   void _checkLoginStatus() async {

//     print("splash main enter ho raha hai?");
//     await Future.delayed(Duration(seconds: 2)); // thoda delay for splash effect
//     final user = _repository.getCurrentUser();

//     if (user != null) {
//       Get.offAllNamed(AppRoutes.kHomeCoffeeRoute);
//     } else {
//       Get.offAllNamed(AppRoutes.kLoginRoute);
//     }
//   }
// }

import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SplashController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();

    _repo.authStateChanges().listen((user) async {
      await Future.delayed(Duration(seconds: 2));
      if (user == null) {
        Get.offAllNamed(AppRoutes.kLoginRoute);
      } else {
        Get.offAllNamed(AppRoutes.kHomeCoffeeRoute);
      }
    });
  }
}
