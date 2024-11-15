import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/utils/cart/cart.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_placed_controller.dart';

class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.offAllNamed(Routes.MAIN_MENU);
          controller.menuController.bottomBar.value = false;
          controller.menuController.orderAdded.value = true;
          controller.ordersController.getOrders();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "order_placed".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.headset_mic,color: ColorConstant.white,),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(Icons.close,color: ColorConstant.white,),
            onPressed: ()  {
              Get.offAllNamed(Routes.MAIN_MENU);
              controller.menuController.bottomBar.value = false;
              controller.menuController.orderAdded.value = true;
              controller.ordersController.getOrders();
            },
          ),
        ],
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
                    Icon(Icons.inventory, size: 100, color: ColorConstant.textGrey.withOpacity(.7)),
                    SizedBox(height: getSize(8)),
                    MyText(title:
                    (controller.order.value.status??" ").capitalizeFirst??"",
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
              //   "${controller.order.value.saleId}",
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              // ),
              MyText(title:
              "${"order".tr} #${controller.order.value.saleId}",
                fontWeight: FontWeight.bold,
              ),
              MyText(title:
              DateFormat("d MMM, yy").format(DateTime.parse(controller.order.value.createdAt??DateTime.now().toString())),
                color: Colors.grey,
              ),
              SizedBox(height: getSize(24)),
              //       // Address and Payment Method
              _buildSectionTitle(
                "${"order_type".tr}: ${(controller.order.value.type??"") == "delivery" ? "delivery_address".tr : "lbl_pickup".tr}",
              ),
              MyText(title:(controller.order.value.type??"") == "delivery" ? (controller.order.value.address??"") : (controller.order.value.branch?.address??"")),
              // SizedBox(height: getSize(16)),
              // _buildSectionTitle("payment_method".tr),
              // MyText(title:controller.order.value.p??""),
              SizedBox(height: getSize(24)),
              // Item List
              _buildSectionTitle("item_list".tr),
              SizedBox(height: getSize(16)),
              Column(
                children: (controller.order.value.products??[]).map((item) {
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
                    _buildTotalRow("lbl_subtotal".tr, (controller.order.value.totalAmount??0) - (controller.order.value.discount??0) -(Constants.DELIVERY_FEES)),
                    _buildTotalRow("lbl_discount".tr, (controller.order.value.discount??0).toDouble()),
                    (controller.order.value.type??"") == "delivery" ? _buildTotalRow("lbl_delivery_fee".tr, Constants.DELIVERY_FEES) : Offstage(),
                    SizedBox(height: getSize(16)),
                    Divider(thickness: 1),
                    _buildTotalRow(
                      "lbl_grand_total".tr,
                      controller.order.value.totalAmount??0,
                      isBold: true,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    //   body: Padding(
    //     padding: getPadding(all: 16),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           SizedBox(height: 20),
    //           Icon(Icons.inventory, size: 100, color: ColorConstant.textGrey.withOpacity(.7)),
    //           SizedBox(height: 10),
    //           MyText(title:
    //           (controller.order.value.status??" ").capitalizeFirst??"",
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //           ),
    //           SizedBox(height: getSize(8)),
    //           Divider(
    //             thickness: 2,
    //             indent: 40,
    //             endIndent: 40,
    //           ),
    //     SizedBox(height: getSize(16)),
    //     // Order Info
    //     // MyText(title:
    //     //   "${controller.order.value.saleId}",
    //     //     fontWeight: FontWeight.bold,
    //     //     fontSize: 16,
    //     // ),
    //     MyText(title:
    //     "${"order".tr} #${controller.order.value.saleId}",
    //       fontWeight: FontWeight.bold,
    //     ),
    //     MyText(title:
    //     DateFormat("d MMM, yy").format(DateTime.parse(controller.order.value.createdAt??"")),
    //       color: Colors.grey,
    //     ),
    //     SizedBox(height: getSize(24)),
    //     //       // Address and Payment Method
    //     _buildSectionTitle(
    //       "${"order_type".tr}: ${(controller.order.value.type??"") == "delivery" ? "delivery_address".tr : "lbl_pickup".tr}",
    //     ),
    //     MyText(title:(controller.order.value.type??"") == "delivery" ? (controller.order.value.address??"") : (controller.order.value.branch?.address??"")),
    //     // SizedBox(height: getSize(16)),
    //     // _buildSectionTitle("payment_method".tr),
    //     // MyText(title:controller.order.value.p??""),
    //     SizedBox(height: getSize(24)),
    //     // Item List
    //     _buildSectionTitle("item_list".tr),
    //     SizedBox(height: getSize(16)),
    //     Column(
    //       children: (controller.order.value.products??[]).map((item) {
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 MyText(title:
    //                 "${item.name} x${item.quantity}",
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 14,
    //                 ),
    //                 MyText(title:
    //                 "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${item.price?.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
    //                   fontSize: 10,
    //                   color: ColorConstant.textGrey,
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 MyText(title:
    //                 "${"lbl_size".tr}: ${item.size}",
    //                   fontWeight: FontWeight.bold,
    //                   color: ColorConstant.textGrey,
    //                   fontSize: 12,
    //                 ),
    //                 MyText(title:
    //                 "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${item.price?.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
    //                   fontSize: 10,
    //                 ),
    //               ],
    //             ),
    //             Divider(),
    //           ],
    //         );
    //       }).toList(),
    //     ),
    //     SizedBox(height: getSize(16)),
    //     // Total Calculation
    //     Padding(
    //       padding: getPadding(left: 8,right: 8),
    //       child: Column(
    //         children: [
    //           _buildTotalRow("lbl_subtotal".tr, (controller.order.value.totalAmount??0) - (controller.order.value.discount??0) -(Constants.DELIVERY_FEES)),
    //           _buildTotalRow("lbl_discount".tr, (controller.order.value.discount??0).toDouble()),
    //           (controller.order.value.type??"") == "delivery" ? _buildTotalRow("lbl_delivery_fee".tr, Constants.DELIVERY_FEES) : Offstage(),
    //           SizedBox(height: getSize(16)),
    //           Divider(thickness: 1),
    //           _buildTotalRow(
    //             "lbl_grand_total".tr,
    //             controller.order.value.totalAmount??0,
    //             isBold: true,
    //             fontSize: 18,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ]),
    );
  }

  // Widget _buildCartItemsList() {
  //   return ListView.builder(
  //     scrollDirection: Axis.vertical,
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: controller.menuController.cart.items.length,
  //     itemBuilder: (context, i) {
  //       final item = controller.menuController.cart.items[i];
  //       return _buildCartItem(item: item,index: i);
  //     },
  //   );
  //
  //
  // }

  // Widget _buildCartItem({required CartItem item,required int index}) {
  //   return Container(
  //     margin: getMargin(bottom: 10),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(
  //           color: ColorConstant.textGrey.withOpacity(.3)
  //         )
  //       )
  //     ),
  //     child: Padding(
  //       padding: getPadding(left: 16,right: 16,top: 10,bottom: 10),
  //       child: Row(
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   MyText(
  //                     title: Utils.checkIfArabicLocale() ? item.item.name ?? "" : item.item.englishName ?? "",
  //                     color: ColorConstant.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   SizedBox(width: getSize(5),),
  //
  //                   MyText(
  //                     title: "(x${item.quantity})",
  //                     color: ColorConstant.textGrey,
  //                   ),
  //                 ],
  //               ),
  //               controller.menuController.checkForMultipleValues(item.item) ? MyText(
  //                 title: "${"lbl_size".tr}: ${item.size}",
  //                 color: ColorConstant.black,
  //                 fontSize: 14,
  //               ) : Offstage(),
  //             ],
  //           ),
  //           Spacer(),
  //           MyText(
  //             title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.checkPricesForCheckout(item.item, item.size) * item.quantity}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
  //             color: ColorConstant.black,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ],
  //       ),
  //
  //     ),
  //   );
  // }


  // Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         MyText(title: label, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
  //         MyText(title: amount, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
  //       ],
  //     ),
  //   );
  // }


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