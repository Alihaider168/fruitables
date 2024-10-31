import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';
import 'package:fruitables/app/modules/category_detail/views/category_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_search_products".tr,fontWeight: FontWeight.bold,fontSize: 22,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: Padding(
        padding: getPadding(all: 16),
        child: Column(
          children: [
            SizedBox(height: getSize(5),),
            CustomTextFormField(
              labelText: "lbl_search".tr,
              textInputAction: TextInputAction.done,
              onChanged: (value){
                controller.onChanged(value);
              },
            ),
            SizedBox(height: getSize(15),),
            Expanded(
              child: Obx(()=> ListView.builder(
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];

                  return ItemWidget(item: item);
                },
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar:Obx(()=>  controller.mainMenuController.bottomBar.value
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
                    margin: getMargin(right: 10),
                    decoration: BoxDecoration(
                        color: ColorConstant.white,
                        shape: BoxShape.circle
                    ),
                    child: Obx(()=> MyText(
                      title: '${controller.mainMenuController.cart.items.value.length}',
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
                        title: '${'lbl_rs'.tr} ${controller.mainMenuController.cart.getTotalDiscountedPrice().toDouble()}',
                        fontSize: 14,
                        color: ColorConstant.white,
                        fontWeight: FontWeight.bold,
                      ),
                      MyText(
                        title: 'Price Exclusive TAX',
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
          : Offstage()),
    );
  }
}
