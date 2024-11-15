import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';

import 'package:get/get.dart';

import '../controllers/current_order_detail_controller.dart';

class CurrentOrderDetailView extends GetView<CurrentOrderDetailController> {
  const CurrentOrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: getSize(320),
            child: Stack(
              children: [
                Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.splash,
                      // 'assets/your_image.jpg',
                      fit: BoxFit.cover,
                      height: getSize(300),
                      width: size.width,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust the blur intensity
                      child: Container(
                        color: ColorConstant.white.withOpacity(0), // Transparent overlay
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: getPadding(left: 16,right: 16,top: 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:()=> Get.back(),
                            child: Card(
                              color: ColorConstant.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(getSize(35))
                              ),
                              child: Padding(padding: getPadding(all: 8),
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                          Container(
                            padding: getPadding(
                                left: 10,right: 10,top: 7,bottom: 7
                            ),
                            decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(getSize(10)),
                                border: Border.all(color: ColorConstant.grayBorder)
                            ),
                            child: MyText(title: "help".tr),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: getPadding(left: 20,right: 20,bottom: 30),
                      child: Card(
                        color: ColorConstant.white,
                        child: Container(
                          padding: getPadding(all: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(title: "Arrive in",color: ColorConstant.textGrey,fontSize: 12,),
                              SizedBox(height: getSize(10),),
                              MyText(
                                title: '20 - 35 ${"mins".tr}',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(height: getSize(10),),
                              OrderStatusIndicator(currentIndex: controller.index),
                              SizedBox(height: getSize(10),),
                              MyText(
                                title: "${(controller.order?.status??"").capitalizeFirst} ${'your_order'.tr}",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(height: getSize(3),),
                              MyText(
                                title: 'when_its_ready'.tr,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: getPadding(all: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title: "items".tr,
                    color: ColorConstant.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  SizedBox(height: getSize(15),),
                  Column(
                    children: (controller.order?.products??[]).map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(title:
                              "${item.name} x${item.quantity}",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              MyText(title:
                              "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${item.price?.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
                                fontSize: 10,
                                color: ColorConstant.textGrey,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(title:
                              "${"lbl_size".tr}: ${item.size}",
                                fontWeight: FontWeight.bold,
                                color: ColorConstant.textGrey,
                                fontSize: 12,
                              ),
                              MyText(title:
                              "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${item.price?.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
                                fontSize: 10,
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(getSize(8)),  // Custom border radius
                    ),

                    color: ColorConstant.white,
                    child: Container(
                      width: size.width,
                      padding: getPadding(all: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow("lbl_subtotal".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(controller.order?.totalAmount??0) - (controller.order?.discount??0) -(Constants.DELIVERY_FEES)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                          _buildSummaryRow("lbl_discount".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(controller.order?.discount??0).toDouble()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                        (controller.order?.type??"") == "delivery" ? _buildSummaryRow("lbl_delivery_fee".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${Constants.DELIVERY_FEES}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"): Offstage(),
                          _buildSummaryRow("${"lbl_tax".tr} (15.0%)", "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.order?.tax??0}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                          _buildSummaryRow("lbl_grand_total".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.order?.totalAmount??0}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}", isBold: true),
                          // _buildSummaryRow("lbl_grand_total".tr, "${"lbl_rs".tr}  ${controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + Constants.DELIVERY_FEES}", isBold: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )

    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title: label, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
          MyText(title: amount, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
        ],
      ),
    );
  }
}
