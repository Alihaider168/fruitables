import 'package:get/get.dart';

import '../controllers/new_detail_controller.dart';

class NewDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewDetailController>(
      () => NewDetailController(),
    );
  }
}
