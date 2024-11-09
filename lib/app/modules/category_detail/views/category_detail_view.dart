import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/widgets/cart_bottom.dart';
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
        leading: Padding(
          padding:  Utils.checkIfUrduLocale() ? getPadding(right: 15): getPadding(left: 15),
          child: GestureDetector(
            onTap: ()=>  Get.back(),
            child: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
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
                    title: "lbl_deliver_to".tr,
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
      body:Padding(
        padding: getPadding(bottom: 16),
        child: Column(
          children: [
            Obx(()=> controller.menuModel.value.data?.categories != null && (controller.menuModel.value.data?.categories??[]).isNotEmpty ?
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              color: ColorConstant.white,
              child: Container(
                height: getSize(47),
                padding: getPadding(bottom: 6,left: 5,right: 5),
                child:ScrollablePositionedList.builder(
                  itemScrollController: controller.horizontalItemScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.menuModel.value.data?.categories?.length??0,
                  itemBuilder: (context, index) {
                    final item = controller.menuModel.value.data!.categories![index];
                    return Obx(() => GestureDetector(
                      onTap: () {
                        controller.horizontalItemScrollController.scrollTo(
                          index: index,
                          alignment: 0.3, // Center the selected item
                          duration: Duration(milliseconds: 1),
                          curve: Curves.easeInOut,
                        );
                        controller.scrollToCategory(index);
                      },
                      child: Container(
                        padding: getPadding(left: 15, right: 15, top: 10, bottom: 10),
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
                                : ColorConstant.textGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                  },
                ),
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
                          fontSize: 18,
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
      bottomNavigationBar:CartBottom(),
    );
  }
}


class ItemWidget extends StatelessWidget {
  ItemWidget({super.key, required this.item,this.fromFav = false,this.onFavTap});

  final MainMenuController controller = Get.put(MainMenuController());

  final Items item;
  final bool fromFav;
  final void Function()? onFavTap;

  RxInt quantity = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.showAddToCartItemSheet(context,item,fromFav: fromFav,onFavTap: onFavTap);
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
                  (item.isNew == true || item.isHot == true || item.isTrending == true) ?
                  Row(
                    children: [
                      Container(
                        // width: getSize(70),
                        height: getSize(30),
                        margin: getMargin(bottom: 10),
                        padding: getPadding(left: 15,right: 15),
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryPink,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(getSize(50)),
                              bottomRight: Radius.circular(getSize(50)),
                            )
                        ),
                        alignment: Alignment.center,
                        child: MyText(title: item.isNew == true ? "lbl_new".tr : item.isHot == true ? "lbl_hot".tr : item.isTrending == true ? "lbl_trending".tr : "",
                          color: ColorConstant.white,fontWeight: FontWeight.bold,
                          fontSize: 12,
                          ),
                      ),
                    ],
                  ): Offstage(),

                  MyText(
                    title: Utils.checkIfUrduLocale() ? item.name??"" : item.englishName??"",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: getSize(3),),
                  MyText(
                    title: Utils.checkIfUrduLocale() ? item.description??"" : item.englishName??"",
                    fontSize: 14,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black, // Change this to the desired color
                                  ),
                                ),

                              // Display the price
                              TextSpan(
                                text: "${'lbl_rs'.tr} ${controller.checkForDiscountedPrice(item) != 0 ? controller.checkForDiscountedPrice(item) : controller.calculatePrice(item)}  ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black, // Change this to the desired color
                                ),
                              ),

                              // Conditionally show the original price if a discount is present
                              if (controller.checkForDiscountedPrice(item) != 0)
                                TextSpan(
                                  text: "${'lbl_rs'.tr} ${controller.calculatePrice(item)}",
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
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: getSize(10),),
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
                          controller.showAddToCartItemSheet(context,item,fromFav: fromFav,onFavTap: onFavTap);
                        }

                      },
                      child: Container(
                        width: getSize(35),
                        height: getSize(35),
                        decoration: BoxDecoration(
                            color: ColorConstant.blue.withOpacity(.7),
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