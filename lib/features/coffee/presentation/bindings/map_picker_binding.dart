import 'package:coffee_app/features/coffee/presentation/controllers/map_picker_controller.dart';
import 'package:get/get.dart';

class MapPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapPickerController>(() => MapPickerController());
  }
}
