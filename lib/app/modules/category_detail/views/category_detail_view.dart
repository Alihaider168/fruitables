import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/widgets/custom_collapsable_widget.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';

import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/category_detail_controller.dart';

class CategoryDetailView extends GetView<CategoryDetailController> {
  const CategoryDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryPink,
        title: const Text('MainMenuView'),
        centerTitle: true,
      ),
      body:Padding(
        padding: getPadding(bottom: 16),
        child: Column(
          children: [
            Obx(()=> controller.menuModel.value.data?.categories != null && (controller.menuModel.value.data?.categories??[]).isNotEmpty ?
            Card(
              child: Container(
                height: getSize(80),
                padding: getPadding(all: 10),
                child:ScrollablePositionedList.builder(
                  itemScrollController: controller.horizontalItemScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.menuModel.value.data?.categories?.length??0,
                  itemBuilder: (context, index) {
                    final item = controller.menuModel.value.data!.categories![index];
                    return Obx(() => GestureDetector(
                      onTap: () {
                        controller.selectedCategoryIndex.value = index; // Update the selected index
                        controller.horizontalItemScrollController.scrollTo(
                          index: index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: getMargin(right: 15),
                        padding: getPadding(left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: controller.selectedCategoryIndex.value == index
                              ? ColorConstant.primaryPink
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: MyText(
                            title: Utils.checkIfUrduLocale() ? item.urduName ?? "" : item.englishName ?? "",
                            color: controller.selectedCategoryIndex.value == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                  },
                ),

                // ListView.builder(
                //   controller: controller.scrollController,
                //   scrollDirection: Axis.horizontal,
                //   itemCount: controller.menuModel.value.data?.categories?.length,
                //   itemBuilder: (context, index) {
                //     final item = controller.menuModel.value.data!.categories![index];
                //     return Obx(()=> GestureDetector(
                //       onTap: () => controller.scrollToCategory(index),
                //       child: Container(
                //         margin:getMargin(right: 15),
                //         padding: getPadding(left: 20,right: 20,top: 10,bottom: 10),
                //         decoration: BoxDecoration(
                //           color: controller.selectedCategoryIndex.value == index
                //               ? ColorConstant.primaryPink
                //               : Colors.transparent,
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: Center(
                //           child: MyText(
                //             title: Utils.checkIfUrduLocale() ? item.urduName??"" : item.englishName??"",
                //             color: controller.selectedCategoryIndex.value == index
                //                 ? Colors.white
                //                 : Colors.black,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ));
                //   },
                // ),
              ),
            ) : Offstage()),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(()=> ScrollablePositionedList.builder(
                itemCount: controller.menuModel.value.data?.categories?.length??0,
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
                itemBuilder: (context, index) {
                  final category = controller.menuModel.value.data?.categories![index];
                  final items = (controller.menuModel.value.data?.items ?? []).where((element) => category?.id == element.categoryId);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      Container(
                        padding: getPadding(all: 16),
                        child: MyText(
                          title: Utils.checkIfUrduLocale() ? category?.urduName??"" : category?.englishName??"",
                          // style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          // ),
                        ),
                      ),
                      // Items of the category
                      ...items.map((item) => ItemWidget(item: item)),
                    ],
                  );
                },
              )),
            ),
          ],
        )

      ),
      bottomNavigationBar:Obx(()=>  controller.bottomBar.value
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
                    title: '${controller.cart.items.value.length}',
                    color: ColorConstant.primaryPink,
                  )),
                ),
                MyText(
                  title: "View Cart",
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
                      title: '${'lbl_rs'.tr} ${controller.cart.getTotalDiscountedPrice().toDouble()}',
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
      )
          : Offstage()),
    );
  }
}


class ItemWidget extends StatelessWidget {
  ItemWidget({super.key, required this.item});

  final MainMenuController controller = Get.put(MainMenuController());

  final Items item;

  RxInt quantity = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.showAddToCartItemSheet(context,item);
      },
      child: Container(
        padding: getPadding(top: 15,bottom: 20,left: 16,right: 16),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ColorConstant.grayBackground,width: 3)
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  item.isNew == true? Row(
                    children: [
                      Container(
                        // width: getSize(70),
                        height: getSize(30),
                        margin: getMargin(bottom: 20),
                        padding: getPadding(left: 15,right: 15),
                        decoration: BoxDecoration(
                            color: ColorConstant.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(getSize(50)),
                              bottomRight: Radius.circular(getSize(50)),
                            )
                        ),
                        alignment: Alignment.center,
                        child: MyText(title: "lbl_new".tr,color: ColorConstant.white,fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ):  item.isHot == true? Row(
                    children: [
                      Container(
                        // width: getSize(70),
                        height: getSize(30),
                        margin: getMargin(bottom: 20),
                        padding: getPadding(left: 15,right: 15),
                        decoration: BoxDecoration(
                            color: ColorConstant.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(getSize(50)),
                              bottomRight: Radius.circular(getSize(50)),
                            )
                        ),
                        alignment: Alignment.center,
                        child: MyText(title: "lbl_hot".tr,color: ColorConstant.white,fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ): item.isTrending == true? Row(
                    children: [
                      Container(
                        // width: getSize(70),
                        height: getSize(30),
                        margin: getMargin(bottom: 20),
                        padding: getPadding(left: 15,right: 15),
                        decoration: BoxDecoration(
                            color: ColorConstant.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(getSize(50)),
                              bottomRight: Radius.circular(getSize(50)),
                            )
                        ),
                        alignment: Alignment.center,
                        child: MyText(title: "lbl_trending".tr,color: ColorConstant.white,fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ): Offstage(),

                  MyText(
                    title: Utils.checkIfUrduLocale() ? item.name??"" : item.englishName??"",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: getSize(3),),
                  MyText(
                    title: Utils.checkIfUrduLocale() ? item.description??"" : item.englishName??"",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.textGrey,
                  ),
                  SizedBox(height: getSize(10),),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              // Check if the prefix 'From' should be added
                              if (controller.checkForMultipleValues(item))
                                TextSpan(
                                  text: '${'lbl_from'.tr}  ', // Prefix text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black, // Change this to the desired color
                                  ),
                                ),

                              // Display the price
                              TextSpan(
                                text: "${'lbl_rs'.tr} ${controller.checkForDiscountedPrice(item) != 0 ? controller.checkForDiscountedPrice(item) : controller.calculatePrice(item)}  ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black, // Change this to the desired color
                                ),
                              ),

                              // Conditionally show the original price if a discount is present
                              if (controller.checkForDiscountedPrice(item) != 0)
                                TextSpan(
                                  text: "${'lbl_rs'.tr} ${controller.calculatePrice(item)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                                    decoration: TextDecoration.lineThrough, // Strikethrough for original price
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      Visibility(
                        visible: controller.checkForDiscountedPrice(item)!= 0,
                        child: Container(
                          margin: getMargin(left: 5),
                          padding: getPadding(left: 10,right: 10,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: ColorConstant.grayBackground,
                              borderRadius: BorderRadius.circular(getSize(15))
                          ),
                          child: MyText(
                            title: "${controller.checkForDiscountedPercentage(item)!= 0? controller.checkForDiscountedPercentage(item) :""}% ${'lbl_off'.tr}",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: getSize(20),),
            SizedBox(
              width: getSize(120),
              height: getSize(120),
              child: Stack(
                children: [
                  CustomImageView(
                    url: item.image,
                    fit: BoxFit.contain,
                    width: getSize(120),
                    height: getSize(120),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: (){
                        if(!controller.checkForMultipleValues(item)){
                          controller.addItemsToCart(item,size: "small");
                          quantity.value += 1;
                          controller.bottomBar.value = true;
                        }else{
                          controller.showAddToCartItemSheet(context, item);
                        }

                      },
                      child: Container(
                        width: getSize(35),
                        height: getSize(35),
                        decoration: BoxDecoration(
                            color: ColorConstant.yellow,
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: Obx(()=> quantity.value == 0
                            ? Icon(Icons.add,color: ColorConstant.white,)
                            : MyText(title: "${quantity.value}",color: ColorConstant.white,fontWeight: FontWeight.w600,)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



}