import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
import 'package:get/get.dart';

class LogoutController extends GetxController {
  final AuthRepository repository = Get.find<AuthRepository>();

  Future<void> logout()async{
   await repository.logout();
  }

}