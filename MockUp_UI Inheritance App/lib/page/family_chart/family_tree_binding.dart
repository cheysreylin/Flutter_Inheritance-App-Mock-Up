import 'package:get/get.dart';
import 'package:inheritance_app/page/family_chart/family_tree_controller.dart';
class FamilyTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyTreeController>(
      () => FamilyTreeController(),
    );
  }
}
