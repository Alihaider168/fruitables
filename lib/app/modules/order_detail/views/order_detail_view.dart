import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    // double subtotal = controller.order.items.fold(
    //   0.0,
    //       (sum, item) => sum + (item.price * item.quantity),
    // );
    // double grandTotal = subtotal + controller.order.deliveryFee;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "order_details".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: getPadding(all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Icon
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: getSize(80),
                    color: Colors.black54,
                  ),
                  SizedBox(height: getSize(8)),
                  MyText(title:
                    (controller.order?.status??" ").capitalizeFirst??"",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: getSize(8)),
                  Divider(
                    thickness: 2,
                    indent: 40,
                    endIndent: 40,
                  ),
                ],
              ),
            ),
            SizedBox(height: getSize(16)),
            // Order Info
            // MyText(title:
            //   "${controller.order?.saleId}",
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            // ),
            MyText(title:
              "${"order".tr} #${controller.order?.saleId}",
              fontWeight: FontWeight.bold,
            ),
            MyText(title:
            DateFormat("d MMM, yy").format(DateTime.parse(controller.order?.createdAt??"")),
              color: Colors.grey,
            ),
            SizedBox(height: getSize(24)),
      //       // Address and Payment Method
            _buildSectionTitle(
              "${"order_type".tr}: ${(controller.order?.type??"") == "delivery" ? "delivery_address".tr : "lbl_pickup".tr}",
            ),
            MyText(title:(controller.order?.type??"") == "delivery" ? (controller.order?.address??"") : (controller.order?.branch?.address??"")),
            // SizedBox(height: getSize(16)),
            // _buildSectionTitle("payment_method".tr),
            // MyText(title:controller.order?.p??""),
            SizedBox(height: getSize(24)),
            // Item List
            _buildSectionTitle("item_list".tr),
            SizedBox(height: getSize(16)),
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
            SizedBox(height: getSize(16)),
            // Total Calculation
            Padding(
              padding: getPadding(left: 8,right: 8),
              child: Column(
                children: [
                  _buildTotalRow("lbl_subtotal".tr, (controller.order?.totalAmount??0) - (controller.order?.discount??0) -(Constants.DELIVERY_FEES)),
                  _buildTotalRow("lbl_discount".tr, (controller.order?.discount??0).toDouble()),
                  (controller.order?.type??"") == "delivery" ? _buildTotalRow("lbl_delivery_fee".tr, Constants.DELIVERY_FEES) : Offstage(),
                  _buildTotalRow("lbl_discount".tr, (controller.order?.tax??0).toDouble()),
                  SizedBox(height: getSize(16)),
                  Divider(thickness: 1),
                  _buildTotalRow(
                    "lbl_grand_total".tr,
                    controller.order?.totalAmount??0,
                    isBold: true,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return MyText(title:
      title,
        fontSize: 14,
        fontWeight: FontWeight.bold,
    );
  }

  Widget _buildTotalRow(String label, num amount,
      {bool isBold = false, double fontSize = 14})
  {
    return Padding(
      padding: getPadding(top: 4,bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title:
            label,
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          MyText(title:
            "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${amount.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }
}