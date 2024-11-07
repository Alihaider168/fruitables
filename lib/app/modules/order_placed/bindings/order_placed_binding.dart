import 'package:get/get.dart';

import '../controllers/order_placed_controller.dart';

class OrderPlacedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPlacedController>(
      () => OrderPlacedController(),
    );
  }
}
