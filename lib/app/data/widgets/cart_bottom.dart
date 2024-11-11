import 'package:flutter/cupertino.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';

class CartBottom extends StatelessWidget{

  final controller = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>  controller.bottomBar.value
        ? Container(
      width: size.width,
      height: size.height*0.12,
      padding: getPadding(left: 16,right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(getSize(20)),
          topRight: Radius.circular(getSize(20)),
        ),
        boxShadow: [
          // Top shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Card-like shadow color
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, -4), // Move shadow upwards
          ),
          // Left shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Card-like shadow color
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(-4, 0), // Move shadow to the left
          ),
          // Right shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Card-like shadow color
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(4, 0), // Move shadow to the right
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: ()=> Get.toNamed(Routes.CART),
          child: Container(
            width: size.width,
            // height: getSize(50),
            decoration: BoxDecoration(
                color: ColorConstant.primaryPink,
                borderRadius: BorderRadius.circular(getSize(5))
            ),
            padding: getPadding(left: 15,right: 15,top: 10,bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: getPadding(all: 8),
                  margin: Utils.checkIfUrduLocale() ? getMargin(left: 15) : getMargin(right: 10),
                  decoration: BoxDecoration(
                      color: ColorConstant.white,
                      shape: BoxShape.circle
                  ),
                  child: Obx(()=> MyText(
                    title: '${controller.cart.items.value.length}',
                    color: ColorConstant.primaryPink,
                  )),
                ),
                MyText(
                  title: "lbl_view_cart".tr,
                  fontSize: 18,
                  color: ColorConstant.white,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MyText(
                      title:
                          Utils.checkIfUrduLocale() ? '${controller.cart.getTotalDiscountedPrice().toDouble()} ${'lbl_rs'.tr}' :
                      '${'lbl_rs'.tr} ${controller.cart.getTotalDiscountedPrice().toDouble()}',
                      fontSize: 14,
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                    ),
                    MyText(
                      title: 'price_exclusive_tax'.tr,
                      fontSize: 12,
                      color: ColorConstant.white,
                      // fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    )
        : Offstage());
  }

}