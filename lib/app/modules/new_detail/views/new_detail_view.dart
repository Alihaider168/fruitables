import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';

import '../controllers/new_detail_controller.dart';

class NewDetailView extends GetView<NewDetailController> {
  const NewDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    image: NetworkImage(Utils.getCompleteUrl(controller.order?.branch?.image?.key)), // Replace with your image
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
                        onTap: (){
                          if(controller.fromOrder){
                            Get.offAllNamed(Routes.MAIN_MENU);
                          }else{
                            Get.back();
                          }
                        },
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
                    SizedBox(height: 15),
                    !((controller.order?.type == "delivery" && controller.order?.deliveredAt != null) ||  (controller.order?.type == "pickup" && controller.order?.completedAt != null)) ?
                    OrderStatusIndicator(currentIndex: controller.order?.status == "pending" ? 0 : controller.order?.status == "preparing" ? 1 : controller.order?.status == "ready" ? 2 : 0):
                    MyText(
                      title: controller.order?.type == "delivery" && controller.order?.deliveredAt != null? "${"delivered_on".tr} ${Utils.formatTimestamp(controller.order?.completedAt)}" : controller.order?.type != "delivery" && controller.order?.completedAt != null ?"${"picked_on".tr} ${Utils.formatTimestamp(controller.order?.completedAt)}":"",
                      color: ColorConstant.textGrey,
                      fontSize: 13,
                    ),
                    SizedBox(height: getSize(10),),
                    Divider(),
                    SizedBox(height: getSize(16),),

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
                        (controller.order?.usedWalletBallance ??"")!= "" && controller.order?.usedWalletBallance != "0" ? _buildTotalRow("from_wallet".tr, controller.order?.usedWalletBallance??0) : Offstage(),
                        (controller.order?.usedPointsBalance ??"")!= "" && controller.order?.usedPointsBalance != "0"? _buildTotalRow("from_points".tr,controller.order?.usedPointsBalance??0) : Offstage(),
                        Divider(thickness: 1, height: 32),
                        _buildTotalRow("lbl_total".tr,controller.order?.totalAmount??0,isBold: true),
                        Divider(thickness: 1, height: 32),
                      ],
                    ),



                    // Payment Method
                    MyText(
                      title: "paid_with".tr,
                      color: ColorConstant.textGrey,
                      fontSize: 12,
                    ),
                    SizedBox(height: getSize(8)),
                    Row(
                      children: [
                        Icon(Icons.money, color: ColorConstant.textGrey),
                        SizedBox(width: getSize(8)),
                        MyText(
                          title: controller.order?.paymentMethod == 'cod'?  "cash_on_delivery".tr :
                            "credit_debit_card".tr,
                          fontWeight: FontWeight.bold, fontSize: 14,
                        ),
                        Spacer(),
                        MyText(title:
                        "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(controller.order?.payableAmount??0).toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: getSize(20)),
                    CustomButton(
                      text: "reorder".tr,
                      onTap: (){
                        for(int i=0;i<(controller.order?.products??[]).length;i++){
                          final item = (controller.order?.products??[])[i];

                          Items? foundItem = (controller.menuController.menuModel.value.data?.items??[]).firstWhere(
                                (test) => test.id == item.id || test.id == item.productId,
                          );
                          if(foundItem != null){
                            controller.menuController.addItemsToCart(
                                foundItem,
                                size: item.size??'bottle',
                                quantity: item.quantity??1
                            );
                            controller.menuController.loadCart();
                            controller.menuController.bottomBar.value = true;
                          }

                        }
                        controller.menuController.loadCart();
                        Get.toNamed(Routes.CART);
                      },
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