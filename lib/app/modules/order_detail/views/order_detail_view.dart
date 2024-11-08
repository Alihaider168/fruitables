import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    double subtotal = controller.order.items.fold(
      0.0,
          (sum, item) => sum + (item.price * item.quantity),
    );
    double grandTotal = subtotal + controller.order.deliveryFee;

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
                    controller.order.status,
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
            MyText(title:
              "${controller.order.id}",
                fontWeight: FontWeight.bold,
                fontSize: 16,
            ),
            MyText(title:
              "${"order".tr} #${controller.order.orderNumber}",
              color: Colors.grey,
            ),
            MyText(title:
              DateFormat.yMMMMd().add_jm().format(controller.order.date),
              color: Colors.grey,
            ),
            SizedBox(height: getSize(24)),
            // Address and Payment Method
            _buildSectionTitle("delivery_address".tr),
            MyText(title:controller.order.address),
            SizedBox(height: getSize(16)),
            _buildSectionTitle("payment_method".tr),
            MyText(title:controller.order.paymentMethod),
            SizedBox(height: getSize(24)),
            // Item List
            _buildSectionTitle("item_list".tr),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: getPadding(all: 16),
                child: Column(
                  children: controller.order.items.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(title:
                              "${item.name} x${item.quantity}",
                              fontWeight: FontWeight.bold,
                            ),
                            MyText(title:
                              "${'lbl_rs'.tr} ${item.price.toStringAsFixed(2)}",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        if (item.sauces.isNotEmpty)
                          Padding(
                            padding: getPadding(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: item.sauces
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => MyText(title:
                                  "(${entry.key + 1}ST SAUCE) ${entry.value}",
                                  color: Colors.grey,
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: getSize(16)),
            // Total Calculation
            Padding(
              padding: getPadding(left: 8,right: 8),
              child: Column(
                children: [
                  _buildTotalRow("lbl_subtotal".tr, subtotal),
                  _buildTotalRow("lbl_delivery_fee".tr, controller.order.deliveryFee),
                  SizedBox(height: getSize(16)),
                  Divider(thickness: 1),
                  _buildTotalRow(
                    "lbl_grand_total".tr,
                    grandTotal,
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
        fontSize: 16,
        fontWeight: FontWeight.bold,
    );
  }

  Widget _buildTotalRow(String label, double amount,
      {bool isBold = false, double fontSize = 14}) {
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
            "${'lbl_rs'.tr} ${amount.toStringAsFixed(2)}",
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }
}

// Order Model
class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final String status;
  final String address;
  final String paymentMethod;
  final List<OrderItem> items;
  final double deliveryFee;

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.items,
    required this.deliveryFee,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final List<String> sauces;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.sauces = const [],
  });
}