import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/orders_model.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:fruitables/app/modules/orders/controllers/orders_controller.dart';
import 'package:get/get.dart';

class OrderPlacedController extends GetxController {

  MainMenuController menuController = Get.put(MainMenuController());
  OrdersController ordersController = Get.put(OrdersController());

  RxBool isLoading = false.obs;

  Rx<Orders> order = Orders().obs;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data!= null && data['order']!= null){
      order.value = data['order'];
    }
    super.onInit();

  }


}
