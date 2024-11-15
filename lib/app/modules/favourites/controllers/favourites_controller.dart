import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/utils/fav_utils/fav_utils.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class FavouritesController extends GetxController {
  MainMenuController mainMenuController = Get.put(MainMenuController());

  RxList<Items?> initialList = <Items?>[].obs;

  FavUtils favUtils = FavUtils();

  @override
  void onInit() {
    super.onInit();

    initialList.value = favUtils.favItems.value??[];
  }
}
