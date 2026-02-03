import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:get/get.dart';
class SplashController extends GetxController {
  final AuthRepository _repository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }



  void _checkLoginStatus() async {

    print("splash main enter ho raha hai?");
    await Future.delayed(Duration(seconds: 2)); // thoda delay for splash effect
    final user = _repository.getCurrentUser();

    if (user != null) {
      Get.offAllNamed(AppRoutes.kHomeCoffeeRoute);
    } else {
      Get.offAllNamed(AppRoutes.kLoginRoute);
    }
  }
}
