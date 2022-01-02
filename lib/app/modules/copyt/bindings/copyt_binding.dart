import 'package:get/get.dart';

import '../controllers/copyt_controller.dart';

class CopytBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CopytController>(
      () => CopytController(),
    );
  }
}
