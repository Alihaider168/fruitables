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
          controller.menuController.cart.clearCart();
          controller.menuController.orderAdded.value = true;
          Get.offAllNamed(Routes.MAIN_MENU);
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
              controller.menuController.cart.clearCart();
              controller.menuController.orderAdded.value = true;
              controller.menuController.loadCart();
              Get.offAllNamed(Routes.MAIN_MENU);
              },
          ),
        ],
      ),
      body: Padding(
        padding: getPadding(all: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(Icons.inventory, size: 100, color: ColorConstant.textGrey.withOpacity(.7)),
              SizedBox(height: 10),
              MyText(title:
                "order_placed".tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              // Order ID and Date
              Column(
                children: [
                  MyText(title:
                    "5RM4-59HG6",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  MyText(title:"${"order".tr} #15523392"),
                  MyText(title:
                    DateFormat('MMMM d, yyyy h:mm a').format(DateTime.now()),
                    color: ColorConstant.textGrey,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Delivery Address and Payment Method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(title:"delivery_address".tr,fontWeight: FontWeight.bold),
                        SizedBox(height: 5),
                        MyText(title:
                          "street turbine, مظفرپور گہمن سیالکوٹ, Muzaffarpur, Sialkot",
                          color: ColorConstant.textGrey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MyText(title:"Payment Method", fontWeight: FontWeight.bold),
                        SizedBox(height: 5),
                        MyText(title:"cash_on_delivery".tr),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Item List
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstant.textGrey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(title:"item_list".tr, fontSize: 18, fontWeight: FontWeight.bold),
                    SizedBox(height: 10),
                    // Item 1
                    _buildCartItemsList(),

                    // Subtotal and Delivery Fee
                    _buildSummaryRow("lbl_subtotal".tr, "${"lbl_rs".tr} ${controller.menuController.cart.getTotalDiscountedPrice()}"),
                    _buildSummaryRow("lbl_delivery_fee".tr, "${"lbl_rs".tr} ${Constants.DELIVERY_FEES}"),
                    _buildSummaryRow("${"lbl_tax".tr} (15.0%)", "${"lbl_rs".tr} ${controller.menuController.cart.getTax()}"),

                    Divider(thickness: 1, color: ColorConstant.textGrey.withOpacity(.3)),
                    // Grand Total
                    _buildSummaryRow("lbl_grand_total".tr, "${"lbl_rs".tr}  ${controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + Constants.DELIVERY_FEES}", isBold: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow({
    required String itemName,
    required int quantity,
    required double price,
    List<String>? details,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(title:
              "$itemName x$quantity",
              fontSize: 16,
            ),
            MyText(title:
              "${"lbl_rs".tr} ${price.toStringAsFixed(2)}",
              fontSize: 16,
            ),
          ],
        ),
        if (details != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details
                  .map((detail) => MyText(title:
                detail,
                color: ColorConstant.textGrey,
              ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.menuController.cart.items.length,
      itemBuilder: (context, i) {
        final item = controller.menuController.cart.items[i];
        return _buildCartItem(item: item,index: i);
      },
    );


  }

  Widget _buildCartItem({required CartItem item,required int index}) {
    return Container(
      margin: getMargin(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.textGrey.withOpacity(.3)
          )
        )
      ),
      child: Padding(
        padding: getPadding(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyText(
                      title: Utils.checkIfUrduLocale() ? item.item.name ?? "" : item.item.englishName ?? "",
                      color: ColorConstant.black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: getSize(5),),

                    MyText(
                      title: "(x${item.quantity})",
                      color: ColorConstant.textGrey,
                    ),
                  ],
                ),
                controller.menuController.checkForMultipleValues(item.item) ? MyText(
                  title: "${"lbl_size".tr}: ${item.size}",
                  color: ColorConstant.black,
                  fontSize: 14,
                ) : Offstage(),
              ],
            ),
            Spacer(),
            MyText(
              title: "${"lbl_rs".tr} ${controller.menuController.checkPricesForCheckout(item.item, item.size) * item.quantity}",
              color: ColorConstant.black,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),

      ),
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