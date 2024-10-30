import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/widgets/custom_collapsable_widget.dart';
import 'package:fruitables/app/data/widgets/custom_drawer.dart';
import 'package:fruitables/app/modules/category_detail/views/category_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/main_menu_controller.dart';

class MainMenuView extends GetView<MainMenuController> {
  const MainMenuView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryPink,
        leading: IconButton(
          onPressed: (){
            controller.scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu,color: ColorConstant.white,),
        ),
        title: GestureDetector(
          onTap: (){
            Get.toNamed(Routes.LOCATION_SELECTION);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MyText(
                    title: "lbl_deliver_to".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.white,
                  ),
                  Icon(Icons.keyboard_arrow_down,color: ColorConstant.white,size: getSize(20),)
                ],
              ),
              MyText(
                title: controller.branch?.address??"",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstant.white,
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              // controller.scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.search,color: ColorConstant.white,),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body:Padding(
        padding: getPadding(bottom: 16),
        child: Obx(()=> CustomCollapsableWidget(
          banners: controller.menuModel.value.data?.banners??[],
          header: // Horizontal ListView for categories
          Obx(()=> controller.menuModel.value.data?.categories != null && (controller.menuModel.value.data?.categories??[]).isNotEmpty ?
          Column(
            children: [
              SizedBox(height: getSize(15),),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of items per row
                  childAspectRatio: 0.68, // Adjust the aspect ratio as needed
                  // crossAxisSpacing: 8, // Space between items in the cross axis
                  // mainAxisSpacing: 8, // Space between items in the main axis
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap:true,
                itemCount: !controller.showAllCategories.value ?

              (  (controller.menuModel.value.data?.categories?.length??0) >8
                    ? 8 : (controller.menuModel.value.data?.categories?.length??0)) : (controller.menuModel.value.data?.categories??[]).length,
                // itemCount: (controller.menuModel.value.data?.categories??[]).length,
                itemBuilder: (context, index) {
                  final cat = (controller.menuModel.value.data?.categories??[])[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.CATEGORY_DETAIL,arguments: {'category':index});
                    },
                    child: Container(
                      padding: getPadding(left: 10,right: 10,top: 5,bottom: 10),
                      child: Column(
                        children: [
                          CustomImageView(
                            url: cat.image,
                            height: getSize(80),
                            padding: getPadding(all: getSize(5)),
                            margin: getMargin(bottom: getSize(5)),
                            width: size.width,
                            border: Border.all(color: ColorConstant.grayBorder.withOpacity(0.3)),
                          ),
                          MyText(
                            title: Utils.checkIfUrduLocale() ? cat.urduName??"" : cat.englishName??"",
                            center: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: getSize(15),),
              GestureDetector(
                onTap: (){
                  controller.showAllCategories.value = !controller.showAllCategories.value;
                },
                child: MyText(
                  title: controller.showAllCategories.value ? "Hide Categories \u25B2" : "View All Categories \u25BC",
                  under: true,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ): Offstage()),

          child:
          Column(
            children: [

              const SizedBox(height: 10),

              ListView.separated(
                itemCount: (controller.menuModel.value.data?.categories?.length??0) >5
                  ? 5 : (controller.menuModel.value.data?.categories?.length??0),
                separatorBuilder: (_,__){
                  return SizedBox(height: getSize(20),);
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final category = controller.menuModel.value.data?.categories![index];
                      final items = (controller.menuModel.value.data?.items ?? []).where((element) => category?.id == element.categoryId).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header
                          Container(
                            padding: getPadding(all: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  title: Utils.checkIfUrduLocale() ? category?.urduName??"" : category?.englishName??"",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),

                                Visibility(
                                  visible: items.length>4,
                                  child: GestureDetector(
                                    onTap:(){
                                      Get.toNamed(Routes.CATEGORY_DETAIL,arguments: {'category':index});
                                    },
                                    child: MyText(
                                      title: 'lbl_view_all'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      under: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: getSize(270),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length>4 ? 4 : items.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CustomItemCard(item: items[i]),
                                );
                              },
                            ),
                          ),
                          // Items of the category
                          // SingleChildScrollView(
                          //   a,
                          //   child: Row(
                          //     children: [...items.map((item) => CustomItemCard(item: item))],
                          //   ),
                          // ),
                          // ...items.map((item) => CustomItemCard(item: item)),
                        ],
                      );
                },
              ),


              // Obx(()=> ScrollablePositionedList.builder(
              //   itemCount: (controller.menuModel.value.data?.categories?.length??0) >5
              //       ? 5 : (controller.menuModel.value.data?.categories?.length??0),
              //   itemScrollController: controller.itemScrollController,
              //   itemPositionsListener: controller.itemPositionsListener,
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemBuilder: (context, index) {
              //     final category = controller.menuModel.value.data?.categories![index];
              //     final items = (controller.menuModel.value.data?.items ?? []).where((element) => category?.id == element.categoryId);
              //
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // Category Header
              //         Container(
              //           padding: getPadding(all: 16),
              //           child: MyText(
              //             title: Utils.checkIfUrduLocale() ? category?.urduName??"" : category?.englishName??"",
              //             // style: const TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //             // ),
              //           ),
              //         ),
              //         // Items of the category
              //         ...items.map((item) => ItemWidget(item: item)),
              //       ],
              //     );
              //   },
              // )),
            ],
          ),
        )),
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
        ),
      )
          : Offstage()),
    );
  }
}


class CustomItemCard extends StatelessWidget {
  CustomItemCard({super.key, required this.item});

  final MainMenuController controller = Get.put(MainMenuController());

  final Items item;

  RxInt quantity = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!controller.checkForMultipleValues(item)){
          controller.addItemsToCart(item,size: "small");
          quantity.value += 1;
          controller.bottomBar.value = true;
        }else{
          controller.showAddToCartItemSheet(context, item);
        }
      },
      child: SizedBox(
        width: getSize(180),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Discount Badge

              SizedBox(height: 4),

              // Product Image
              Stack(
                children: [

                  CustomImageView(
                    url: item.image,
                    height: getSize(150),
                    width: getSize(180),
                    fit: BoxFit.cover,
                  ),
                  controller.checkForDiscountedPercentage(item)!= 0 ?Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: getMargin(left: 5,top: 5),
                      padding: getPadding(left: 6,right: 6,top: 4,bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: MyText(
                        title: "${controller.checkForDiscountedPercentage(item)!= 0? controller.checkForDiscountedPercentage(item) :""}% ${'lbl_off'.tr}",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.white,
                      ),
                    ),
                  ) : Offstage(),
                  // Add Button
                  Positioned(
                    right: getSize(5),
                    bottom: getSize(5),
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
                    )
                  ),
                ],
              ),
              SizedBox(height: getSize(10)),

              // Pricing
              RichText(
                text: TextSpan(
                  children: [
                    // Check if the prefix 'From' should be added
                    if (controller.checkForMultipleValues(item))
                      TextSpan(
                        text: '${'lbl_from'.tr} ', // Prefix text
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
              MyText(
                title: Utils.checkIfUrduLocale() ? item.name??"" : item.englishName??"",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                line: 2,
                overflow: TextOverflow.ellipsis,
              ),


            ],
          ),
        ),
      ),
    );
  }
}

