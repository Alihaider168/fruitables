import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/widgets/cart_bottom.dart';
import 'package:fruitables/app/data/widgets/custom_collapsable_widget.dart';
import 'package:fruitables/app/data/widgets/custom_drawer.dart';
import 'package:fruitables/app/modules/category_detail/views/category_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/main_menu_controller.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final controller = Get.put(MainMenuController());

  @override
  void initState() {
    super.initState();
    Utils.setUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: Utils.checkIfArabicLocale() ? getPadding(right: 15):getPadding(left: 15),
          child: GestureDetector(
            onTap: ()=>  controller.scaffoldKey.currentState!.openDrawer(),
            child: Icon(Icons.menu,color: ColorConstant.white,),
          ),
        ),
        leadingWidth: getSize(35),
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
                    title: !Constants.isDelivery.value ? "pickup_from".tr : "lbl_deliver_to".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.white,
                  ),
                  Icon(Icons.keyboard_arrow_down,color: ColorConstant.white,size: getSize(20),)
                ],
              ),
              MyText(
                title: Constants.selectedBranch?.address??"",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorConstant.white,
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
             Get.toNamed(Routes.SEARCH);
            },
            icon: Icon(Icons.search,color: ColorConstant.white,),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body:
      Obx(()=> controller.isLoading.value ? Center(
        child: CircularProgressIndicator(),
      ):
      Padding(
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
                            url:Utils.getCompleteUrl( cat.appImage?.key),
                            // url: cat.image,
                            height: getSize(80),
                            padding: getPadding(all: getSize(5)),
                            margin: getMargin(bottom: getSize(5)),
                            width: size.width,
                            border: Border.all(color: ColorConstant.grayBorder.withOpacity(0.3)),
                          ),
                          MyText(
                            title: Utils.checkIfArabicLocale() ? cat.arabicName??"" : cat.englishName??"",
                            center: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      title: controller.showAllCategories.value ? "hide_categories".tr : "view_all_categories".tr,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      width: getSize(5),
                    ),
                    Icon(!controller.showAllCategories.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),

                  ],
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
                              title: Utils.checkIfArabicLocale() ? category?.arabicName??"" : category?.englishName??"",
                              fontSize: 18,
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.black.withOpacity(.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getSize(182),
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
      ),
      bottomNavigationBar: CartBottom(),
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
        controller.showAddToCartItemSheet(context,item);
      },
      child: SizedBox(
        width: getSize(140),
        child: Padding(
          padding: getPadding(top: 5,right: 3,left: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getSize(140),
                height: getSize(130),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(10)),
                  // color: ColorConstant.grayBackground.withOpacity(.5),
                  border: Border.all(color: ColorConstant.grayBorder.withOpacity(0.3)),
                ),
                padding: getPadding(all: 5),
                child: Stack(
                  children: [

                    Center(
                      child: CustomImageView(
                        url: Utils.getCompleteUrl(item.image?.key),
                        height: getSize(110),
                        width: getSize(110),
                        fit: BoxFit.contain,
                      ),
                    ),
                    controller.checkForDiscountedPercentage(item)!= 0 ?Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        // margin: getMargin(left: 5,top: 5),
                        padding: getPadding(left: 5,right: 5,top: 3,bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MyText(
                          title: "${controller.checkForDiscountedPercentage(item)!= 0? controller.checkForDiscountedPercentage(item).toString().split(".")[0] :""}% ${'lbl_off'.tr}",
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.white,
                        ),
                      ),
                    ) : Offstage(),
                    // Add Button
                    Positioned(
                      left: Utils.checkIfArabicLocale() ? getSize(5) : null,
                      right: Utils.checkIfArabicLocale() ? null : getSize(5),
                      bottom: getSize(5),
                      child: GestureDetector(
                        onTap: (){
                          if(!controller.checkForMultipleValues(item)){
                            String selectedSize = "small";
                            if((item.largePrice??0) != 0 ){
                              selectedSize = "large";
                            }else if((item.mediumPrice??0) != 0 ) {
                              selectedSize = "medium";
                            }else if((item.smallPrice??0) != 0 ) {
                              selectedSize = "small";
                            }
                            controller.addItemsToCart(item,size: selectedSize);
                            quantity.value += 1;
                            controller.bottomBar.value = true;
                          }else{
                            controller.showAddToCartItemSheet(context, item);
                          }

                        },
                        child: Container(
                          width: getSize(28),
                          height: getSize(28),
                          decoration: BoxDecoration(
                              color: ColorConstant.white,
                              shape: BoxShape.circle,
                            border: Border.all(color: ColorConstant.grayBorder)
                          ),
                          alignment: Alignment.center,
                          child:
                          // Obx(()=> quantity.value == 0
                          //     ?
                          Icon(Icons.add,color: ColorConstant.grayBorder,)
                              // : MyText(title: "${quantity.value}",color: ColorConstant.grayBorder,fontWeight: FontWeight.w600,)
                          // ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: getSize(3)),

              // Pricing
              RichText(
                text: TextSpan(
                  children: [
                    // Check if the prefix 'From' should be added
                    if (controller.checkForMultipleValues(item))
                      TextSpan(
                        text: '${'lbl_from'.tr} ', // Prefix text
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: controller.checkForMultipleValues(item) ? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                        ),
                      ),

                    // Display the price
                    TextSpan(
                      text: "${Utils.checkIfArabicLocale() ? "": "lbl_rs".tr}${controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item)? controller.checkForDiscountedPrice(item) : controller.calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "": "lbl_rs".tr} ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: controller.checkForDiscountedPrice(item) != 0? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                      ),
                    ),

                    // Conditionally show the original price if a discount is present
                    if (controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item))
                      TextSpan(
                        text: "${Utils.checkIfArabicLocale() ? "": "lbl_rs".tr}${controller.calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "": "lbl_rs".tr}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                          decoration: TextDecoration.lineThrough, // Strikethrough for original price
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: getSize(2),),
              MyText(
                title: Utils.checkIfArabicLocale() ? item.name??"" : item.englishName??"",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstant.textGrey,
                line: 1,
                overflow: TextOverflow.ellipsis,
              ),


            ],
          ),
        ),
      ),
    );
  }
}

