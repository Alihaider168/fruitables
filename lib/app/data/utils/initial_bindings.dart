import 'package:rexsa_cafe/app/modules/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
