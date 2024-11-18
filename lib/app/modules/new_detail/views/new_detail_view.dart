import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

import '../controllers/new_detail_controller.dart';

class NewDetailView extends GetView<NewDetailController> {
  const NewDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: Text(
      //     "Order Details",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.help_outline, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Image
              Container(
                height: getSize(200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(Utils.getCompleteUrl(controller.order?.branch?.image)), // Replace with your image
                    fit: BoxFit.cover,
                  ),
                  color: Colors.orange
                ),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: getPadding(left: 16,top: 10),
                      child: GestureDetector(
                        onTap: ()=> Get.back(),
                        child: CircleAvatar(
                          radius: getSize(17),
                          backgroundColor: ColorConstant.white,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),

                    Container(
                      margin: getMargin(right: 16,top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorConstant.textGrey),
                        borderRadius: BorderRadius.circular(getSize(10))
                      ),
                      padding: getPadding(top: 7,bottom: 7,left: 12,right: 12),
                      child: MyText(title: "help".tr),
                    )
                  ],
                ),
              ),
              Padding(
                padding: getPadding(left: 16,right: 16,top: 16,bottom: 20),
                child: Column(
                  children: [

                    // Order Information
                    MyText(
                      title: "${"order_number".tr}${controller.order?.saleId}",
                      fontWeight: FontWeight.bold, fontSize: 16,
                    ),
                    SizedBox(height: 4),
                    MyText(
                      title: controller.order?.type == "delivery"? "${"delivered_on".tr} 12 Nov 22:57" : "${"picked_on".tr} 12 Nov 22:57",
                      color: ColorConstant.textGrey,
                      fontSize: 13,
                    ),
                    Divider(thickness: 1, height: 32),

                    // Delivery Information
                    Row(
                      children: [
                        Icon(Icons.store, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: MyText(
                            title:"lbl_order_from".tr,
                            fontSize: 12, color: ColorConstant.textGrey,
                          ),
                        ),
                        Expanded(
                          child: MyText(
                            title: Utils.checkIfArabicLocale() ? controller.order?.branch?.name??"" : controller.order?.branch?.englishName??"",
                            fontWeight: FontWeight.bold, fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, height: getHorizontalSize(30)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (controller.order?.products??[]).length,
                      itemBuilder: (_,index){
                        final product = (controller.order?.products??[])[index];
                        return Row(
                          children: [
                            MyText(
                              title: "${(product.quantity??0)}x",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: MyText(
                                title: "${Utils.checkIfArabicLocale() ? product.arabicName :product.name}",
                                fontSize: 12,
                              ),
                            ),
                            MyText(
                              title: '${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(product.price??0) * (product.quantity??0)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}',
                            ),
                          ],
                        );
                      },
                    ),
                    // Item List

                    SizedBox(height: 16),

                    // Pricing Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalRow("lbl_subtotal".tr, (controller.order?.totalAmount??0)-(controller.order?.tax??0) - (controller.order?.discount??0) -((controller.order?.type??"") == "delivery" ? Constants.DELIVERY_FEES : 0)),
                        _buildTotalRow("lbl_discount".tr, (controller.order?.discount??0).toDouble()),
                        (controller.order?.type??"") == "delivery" ? _buildTotalRow("lbl_delivery_fee".tr, Constants.DELIVERY_FEES) : Offstage(),
                        _buildTotalRow("${"lbl_tax".tr} (15.0%)",controller.order?.tax??0),
                        (controller.order?.usedWalletBallance ??"")!= "" && controller.order?.usedWalletBallance != "0" ? _buildTotalRow("from_wallet".tr, num.parse(controller.order?.usedWalletBallance??"0")) : Offstage(),
                        (controller.order?.usedPointsBalance ??"")!= "" && controller.order?.usedPointsBalance != "0"? _buildTotalRow("from_points".tr,num.parse(controller.order?.usedPointsBalance??"0")) : Offstage(),
                        Divider(thickness: 1, height: 32),
                        _buildTotalRow("lbl_total".tr,controller.order?.totalAmount??0,isBold: true),
                        Divider(thickness: 1, height: 32),
                      ],
                    ),



                    // Payment Method
                    Text(
                      "Paid with",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.money, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "cash on delivery",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          "Rs. 258.99",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(thickness: 1, height: 32),

                    // Download Invoice
                    Row(
                      children: [
                        Icon(Icons.file_download, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "Download invoice",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.pink, // Adjust the color
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(
                        "Select items to reorder",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
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