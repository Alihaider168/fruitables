import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class NewDetailController extends GetxController {

  MainMenuController menuController = Get.put(MainMenuController());
  Orders? order;
  bool fromOrder = false;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data != null && data['order']!=null){
      order = data['order'];
    }
    if(data != null && data['from_order']!=null){
      fromOrder = data['from_order'];
    }
    super.onInit();
  }

}
