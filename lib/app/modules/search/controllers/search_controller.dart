import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  MainMenuController mainMenuController = Get.put(MainMenuController());

  RxList<Items> filteredItems = <Items>[].obs;

  @override
  void onInit() {
    super.onInit();

  }

  onChanged(String? value){
    value = value?.toLowerCase();
    filteredItems.value = (mainMenuController.menuModel.value.data?.items??[]).where((element)=> (element.name??"").toLowerCase().contains(value??"") || (element.englishName??"").toLowerCase().contains(value??"")).toList();
    filteredItems.refresh();
  }

}
