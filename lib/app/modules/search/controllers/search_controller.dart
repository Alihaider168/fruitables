import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class SearchViewController extends GetxController {
  MainMenuController mainMenuController = Get.put(MainMenuController());
  RxString searchText = ''.obs;

  RxList<Items> filteredItems = <Items>[].obs;

  @override
  void onInit() {
    super.onInit();

  }

  onChanged(String? value){
    value = value?.toLowerCase();
        searchText.value = value!;

    filteredItems.value = (mainMenuController.menuModel.value.data?.items??[]).where((element)=> (element.name??"").toLowerCase().contains(value??"") || (element.englishName??"").toLowerCase().contains(value??"")).toList();
    filteredItems.refresh();
  }

}
