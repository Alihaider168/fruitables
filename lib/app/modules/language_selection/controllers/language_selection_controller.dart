import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

class LanguageSelectionController extends GetxController {
  RxInt selectedPreference = 0.obs;
  RxInt selectedLanguage = 0.obs;
  bool fromMenu = false;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    
    super.onInit();
  }
}
