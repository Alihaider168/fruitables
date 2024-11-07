import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class FavouritesController extends GetxController {
  MainMenuController mainMenuController = Get.put(MainMenuController());

  RxList<Items> initialList = <Items>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialList.value = (mainMenuController.menuModel.value.data?.items??[]).length > 5
        ? (mainMenuController.menuModel.value.data?.items??[]).sublist(0,4)
        :mainMenuController.menuModel.value.data?.items??[];
  }
}
