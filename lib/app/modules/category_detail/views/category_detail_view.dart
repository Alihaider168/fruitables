import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/category_detail_controller.dart';

class CategoryDetailView extends GetView<CategoryDetailController> {
  const CategoryDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding:  Utils.checkIfArabicLocale() ? getPadding(right: 15): getPadding(left: 15),
          child: GestureDetector(
            onTap: ()=>  Get.back(),
            child: Icon(Icons.arrow_back_ios,color: ColorConstant.white,size: getSize(18),),
          ),
        ),
        leadingWidth: getSize(30),
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
                    title: !Constants.isDelivery.value ? "pickup_from".tr :"lbl_deliver_to".tr,
                    fontSize:Utils.checkIfArabicLocale() ?11: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.white,
                  ),
                  Icon(Icons.keyboard_arrow_down,color: ColorConstant.white,size: getSize(20),)
                ],
              ),
              MyText(
                title: Constants.selectedBranch?.address??"",
                fontSize:Utils.checkIfArabicLocale() ?11: 14,
                fontWeight: FontWeight.w600,
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
                padding: getPadding(bottom: 5,left: 5,right: 5),
                child:ScrollablePositionedList.builder(
                  itemScrollController: controller.horizontalItemScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.menuModel.value.data?.categories?.length??0,
                  itemBuilder: (context, index) {
                    final item = controller.menuModel.value.data!.categories![index];
                    return Obx(() => GestureDetector(
                      onTap: () {
                        controller.onTapItemChange(index);
                        // controller.centerSelectedHorizontalItem(index);
                        // controller.scrollToCategory(index);
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
                            title: Utils.checkIfArabicLocale() ? item.arabicName ?? "" : item.englishName?.toUpperCase() ?? "",
                            color: controller.selectedCategoryIndex.value == index
                                ? Colors.white
                                : ColorConstant.textGrey,
                                fontSize: 12,
                            fontWeight:controller.selectedCategoryIndex.value == index? FontWeight.w500:FontWeight.w600,
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              ),
            ) : Offstage()),
            // const SizedBox(height: 10),
            Expanded(
              child: Obx(()=> ScrollablePositionedList.builder(
                itemCount: controller.menuModel.value.data?.categories?.length??0,
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
                // reverse: controller.isRTL,
                itemBuilder: (context, index) {
                  final category = controller.menuModel.value.data?.categories![index];
                  final items = (controller.menuModel.value.data?.items ?? []).where((element) => category?.id == element.categoryId);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      Container(
                        width: Get.width,
                       alignment:Utils.checkIfArabicLocale()?Alignment.centerRight:Alignment.centerLeft ,
                        padding: getPadding(right: 16,left: 16,bottom: 6,top: 24),
                        child: MyText(
                          alignRight: Utils.checkIfArabicLocale(),
                          title: Utils.checkIfArabicLocale() ? category?.arabicName??"" : category?.englishName?.toUpperCase()??"",
                          // style: const TextStyle(
                          fontSize:Utils.checkIfArabicLocale() ?22: 22,
                          fontWeight: FontWeight.w600,
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
      bottomNavigationBar:Obx(()=> !controller.mainMenuController.bottomBar.value  && !controller.mainMenuController.orderAdded.value? Offstage() : CartBottom(showCurrentOrder :controller.mainMenuController.orderAdded.value,order: controller.mainMenuController.currentOrder.value,)),
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
        padding: getPadding(top: 10,bottom: 15,left: 16,right: 16),
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
                        padding: getPadding(left: Utils.checkIfArabicLocale() ?15:10,right:Utils.checkIfArabicLocale() ?15: 10),
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryPink,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(getSize(Utils.checkIfArabicLocale() ? 0 :50)),
                              bottomRight: Radius.circular(getSize(Utils.checkIfArabicLocale() ? 0 :50)),
                              topLeft: Radius.circular(getSize(!Utils.checkIfArabicLocale() ? 0 :50)),
                              bottomLeft: Radius.circular(getSize(!Utils.checkIfArabicLocale() ? 0 :50))
                            )
                        ),
                        alignment: Alignment.center,
                        child: MyText(title: item.isNew == true ? "lbl_new".tr : item.isHot == true ? "lbl_hot".tr : item.isTrending == true ? "lbl_trending".tr : "",
                          color: ColorConstant.white,fontWeight: FontWeight.w500,
                          fontSize: 11,
                          ),
                      ),
                    ],
                  ): Offstage(),

                  MyText(
                    
                    title: Utils.checkIfArabicLocale() ? item.name??"" : item.englishName??"",
                    fontSize:Utils.checkIfArabicLocale() ?13: 14,
                    line: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                  item.description == null &&  item.englishDescription == null? Offstage() : SizedBox(height: getSize(3),),
                  item.description == null &&  item.englishDescription == null? Offstage() : MyText(
                    
                    title: Utils.checkIfArabicLocale() ? (item.description??"") : (item.englishDescription??""),
                    fontSize: Utils.checkIfArabicLocale() ?10.5:12,
                    line: 2,
                    
                    alignRight: Utils.checkIfArabicLocale() ? true : null,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.textGrey,
                  ),
                  SizedBox(height: getSize(10),),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: Utils.checkIfArabicLocale() ?TextAlign.right:TextAlign.left,
                          text: TextSpan(
                             
                  children: [
                    // Check if the prefix 'From' should be added
                    if (controller.checkForMultipleValues(item))
                      TextSpan(
                        text: '${'lbl_from'.tr} ', // Prefix text
                        style: TextStyle(
                          fontSize:Utils.checkIfArabicLocale()?10.5: 12,
                          fontWeight: FontWeight.w700,
                          color: controller.checkForMultipleValues(item) ? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                        ),
                      ),

                    // Display the price
                    TextSpan(
                      text: "${Utils.checkIfArabicLocale() ? "lbl_rs".tr: "lbl_rs".tr} ${controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item)? controller.checkForDiscountedPrice(item) : controller.calculatePrice(item)}  ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: controller.checkForDiscountedPrice(item) != 0? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                      ),
                    ),
                    // Conditionally show the original price if a discount is present
                    if (controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item))
                      TextSpan(
                        text: "${Utils.checkIfArabicLocale() ? "lbl_rs".tr: "lbl_rs".tr} ${controller.calculatePrice(item)} ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                          decoration: TextDecoration.lineThrough, // Strikethrough for original price
                        ),
                      ),
                  ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.checkForDiscountedPrice(item)!= 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item),
                        child: Container(
                          margin: getMargin(left: 5),
                          padding: getPadding(left: 10,right: 10,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: ColorConstant.grayBackground,
                              borderRadius: BorderRadius.circular(getSize(15))
                          ),
                          child: MyText(
                            title: "${controller.checkForDiscountedPercentage(item)!= 0? controller.checkForDiscountedPercentage(item).toString().split(".")[0] :""}% ${'lbl_off'.tr}",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
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
                    url: Utils.getCompleteUrl(item.image?.key),
                    fit: BoxFit.contain,
                    width: getSize(120),
                    height: getSize(120),
                  ),
                  Positioned(
                    left: Utils.checkIfArabicLocale() ? 0 : null,
                    right: Utils.checkIfArabicLocale() ? null : 0,
                    bottom: 0,
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
                          controller.showAddToCartItemSheet(context,item,fromFav: fromFav,onFavTap: onFavTap);
                        }
                      },
                      child: Container(
                        width: getSize(35),
                        height: getSize(35),
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryPink1,
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child:
                        
                        Icon(Icons.add,color: ColorConstant.white,)
                       
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