import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/features/auth/presentation/controllers/splash.dart';
import 'package:coffee_app/features/coffee/data/respositories/auth_repositories.dart';


import 'package:get/get.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {

    Get.put<AuthRepository>(AuthRepositoryImpl());
  
    Get.put<SplashController>(SplashController());
  }
}
