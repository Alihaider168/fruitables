import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/utils/cart/cart.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  MainMenuController menuController = Get.put(MainMenuController());

  RxBool useWallet = false.obs;
  RxBool usePoints = false.obs;

  num? usedPointsBalance;
  num? usedWalletBalance;

  @override
  void onInit() {
    super.onInit();
  }

  num getWalletAmount() {
    num walletBalance = Constants.userModel?.customer?.balance ?? 0;
    num totalCheckoutPrice = Utils.getNewCheckoutPrice(
      menuController.cart.getTotalDiscountedPrice(),
      menuController.cart.getTax(),
    );

    // Use the lesser of wallet balance or total checkout price
    usedWalletBalance = walletBalance < totalCheckoutPrice ? walletBalance : totalCheckoutPrice;
    return walletBalance < totalCheckoutPrice ? walletBalance : totalCheckoutPrice;
  }

  num getPointsAmount() {
    num walletBalance = Constants.userModel?.customer?.balance ?? 0;
    num pointsBalance = Constants.userModel?.customer?.points ?? 0;
    num totalCheckoutPrice = Utils.getNewCheckoutPrice(
      menuController.cart.getTotalDiscountedPrice(),
      menuController.cart.getTax(),
    );

    // If wallet is being used and can fully cover the total
    if (useWallet.value && walletBalance >= totalCheckoutPrice) {
      usedPointsBalance = 0; // No need to use points
      return 0; // No need to use points
    }

    // If wallet is being used but cannot fully cover the total
    if (useWallet.value && walletBalance < totalCheckoutPrice) {
      num remainingAmount = totalCheckoutPrice - walletBalance;

      // Use the lesser of remaining amount or points balance
      usedPointsBalance =  pointsBalance < remainingAmount ? pointsBalance : remainingAmount;
      return pointsBalance < remainingAmount ? pointsBalance : remainingAmount;
    }

    // If wallet is not being used, use points to cover as much of the total as possible
    usedPointsBalance =  pointsBalance < totalCheckoutPrice ? pointsBalance : totalCheckoutPrice;
    return pointsBalance < totalCheckoutPrice ? pointsBalance : totalCheckoutPrice;
  }

}
