import 'package:get/get.dart';

import '../controllers/location_selection_controller.dart';

class LocationSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationSelectionController>(
      () => LocationSelectionController(),
    );
  }
}
