import 'package:coffee_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:coffee_app/features/auth/presentation/controllers/splash.dart';

import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);

    Get.put<SplashController>(SplashController());
  }
}
