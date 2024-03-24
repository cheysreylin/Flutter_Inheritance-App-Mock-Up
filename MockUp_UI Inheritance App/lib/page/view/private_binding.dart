
import 'package:get/get.dart';
import 'package:inheritance_app/page/view/private_controller.dart';

class PrivateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivateController>(
      () => PrivateController(),
    );
  }
}
