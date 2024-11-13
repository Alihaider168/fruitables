import 'package:get/get.dart';

import '../controllers/current_order_detail_controller.dart';

class CurrentOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentOrderDetailController>(
      () => CurrentOrderDetailController(),
    );
  }
}
