import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/utils/cart/cart.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  MainMenuController menuController = Get.put(MainMenuController());

  RxBool useWallet = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

}
