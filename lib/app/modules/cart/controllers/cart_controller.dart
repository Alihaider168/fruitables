import 'package:flutter/material.dart';
import 'package:fruitables/app/data/utils/cart/cart.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  MainMenuController menuController = Get.put(MainMenuController());

  @override
  void onInit() {
    super.onInit();
  }

}
