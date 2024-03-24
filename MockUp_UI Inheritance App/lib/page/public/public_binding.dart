
import 'package:get/get.dart';
import 'package:inheritance_app/page/public/public_controller.dart';

class PublicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublicController>(
      () => PublicController(),
    );
  }
}
