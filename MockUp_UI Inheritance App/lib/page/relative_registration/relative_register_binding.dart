
import 'package:get/get.dart';
import 'package:inheritance_app/page/relative_registration/relative_register_controller.dart';

class RelativeRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RelativeRegisterController>(
      () => RelativeRegisterController(),
    );
  }
}
