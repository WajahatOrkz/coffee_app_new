import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';

import 'package:get/get.dart';

class LogoutController extends GetxController {
  final AuthRepository repository = Get.find<AuthRepository>();

  RxBool isLoading = false.obs;

  Future<void> logout() async {
  try {
    isLoading.value = true;
    await repository.logout();
  } finally {
    isLoading.value = false;
  }
}
}