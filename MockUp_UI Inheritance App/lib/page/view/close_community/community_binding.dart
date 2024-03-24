import 'package:get/get.dart';
import 'package:inheritance_app/page/view/close_community/community_controller.dart';

class PrivateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityController>(
      () => CommunityController(),
    );
  }
}
