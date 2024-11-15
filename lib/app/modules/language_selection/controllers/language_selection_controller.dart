import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:get/get.dart';

class LanguageSelectionController extends GetxController {
  RxInt selectedPreference = 0.obs;

  RxInt selectedLanguage = 0.obs;

  bool fromMenu = false;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data!= null && data["from_menu"] != null){
      fromMenu = data['from_menu'];
    }
    super.onInit();
  }

}
