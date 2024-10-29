import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/utils/cart/cart.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../data/core/app_export.dart';

class CategoryDetailController extends GetxController {
  Rx<MenuModel> menuModel = MenuModel().obs;
  RxBool bottomBar = false.obs;
  var selectedCategoryIndex = 0.obs;

  MainMenuController mainMenuController = Get.put(MainMenuController());

  final ScrollController scrollController = ScrollController();
  final double itemWidth = 150; // Adjust this based on your item width

  Cart cart = Cart();

  bool isInit = false;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemScrollController horizontalItemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void onInit() {
    var data = Get.arguments;
    super.onInit();
    menuModel.value = mainMenuController.menuModel.value;



    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisible = positions.first.index;
        onVerticalScroll(firstVisible);
      }

      if(!isInit){
        isInit = true;
        if(data!= null && data['category']!= null){
          await Future.delayed(1.seconds);
          scrollToCategory(data['category']);
          horizontalItemScrollController.scrollTo(
            index: data['category'],
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }

    });


  }

  void scrollToCategory(int index) {
    selectedCategoryIndex.value = index;
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onVerticalScroll(int firstVisibleIndex) {
    selectedCategoryIndex.value = firstVisibleIndex;
    horizontalItemScrollController.scrollTo(
      index: firstVisibleIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Here, you can add additional logic if needed, e.g., to highlight the selected category in the horizontal view
  }

  void addItemsToCart(Items item, {String size = 'small'}){
    cart.addItem(item, size);
  }

  void removeItemFromCart(String id){
    cart.removeItem(id);
  }


  showAddToCartItemSheet(BuildContext ctx, Items item) {
    RxInt quantity = 1.obs;
    RxString selectedSize = 'small'.obs;
    RxBool isLiked =false.obs;


    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          )),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.99,
            minChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: getPadding(all: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Expanded(
                        child: Stack(
                          children: [

                            SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: CustomImageView(
                                      url: item.image,
                                      width: getSize(200),
                                      margin: getMargin(bottom: 20),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyText(
                                          title: Utils.checkIfUrduLocale() ? item.name??"" : item.englishName??"",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: getSize(15),),
                                      GestureDetector(
                                        onTap: (){
                                          isLiked.value = !isLiked.value;
                                        },
                                        child: Obx(()=> Icon(isLiked.value ? Icons.heart_broken : Icons.heart_broken_outlined,
                                          color: isLiked.value ? ColorConstant.primaryPink : ColorConstant.black,
                                        )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: getSize(10),),
                                  Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            // Check if the prefix 'From' should be added
                                            if (checkForMultipleValues(item))
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
                                              text: "${'lbl_rs'.tr} ${checkForDiscountedPrice(item) != 0 ? checkForDiscountedPrice(item) : calculatePrice(item)}  ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black, // Change this to the desired color
                                              ),
                                            ),

                                            // Conditionally show the original price if a discount is present
                                            if (checkForDiscountedPrice(item) != 0)
                                              TextSpan(
                                                text: "${'lbl_rs'.tr} ${calculatePrice(item)}",
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
                                      Visibility(
                                        visible: checkForDiscountedPrice(item)!= 0,
                                        child: Container(
                                          margin: getMargin(left: 15),
                                          padding: getPadding(left: 10,right: 10,top: 5,bottom: 5),
                                          decoration: BoxDecoration(
                                              color: ColorConstant.grayBackground,
                                              borderRadius: BorderRadius.circular(getSize(15))
                                          ),
                                          child: MyText(
                                            title: "${checkForDiscountedPercentage(item)!= 0? checkForDiscountedPercentage(item) :""}% ${'lbl_off'.tr}",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: getSize(20),),
                                  MyText(
                                    title: Utils.checkIfUrduLocale() ? item.description??"" : item.englishName??"",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.textGrey,
                                  ),
                                  SizedBox(height: getSize(20),),
                                  Divider(),
                                  SizedBox(height: getSize(20),),
                                  checkForMultipleValues(item) ? Column(
                                    children: [
                                      SizedBox(
                                        height: getSize(40),
                                        child: Obx(()=> RadioListTile<String>(
                                          title: MyText(title: 'lbl_small'.tr,fontSize: 18,fontWeight: FontWeight.w600,),
                                          value: 'small',
                                          activeColor: ColorConstant.primaryPink,
                                          groupValue: selectedSize.value,
                                          onChanged: (value) {
                                            selectedSize.value = value!;
                                          },
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0), // Smaller padding
                                        ),),
                                      ),
                                      SizedBox(
                                        height: getSize(40),
                                        child: Obx(()=> RadioListTile<String>(
                                          title: MyText(title:'lbl_medium'.tr,fontSize: 18,fontWeight: FontWeight.w600,),
                                          value: 'medium',
                                          activeColor: ColorConstant.primaryPink,
                                          groupValue: selectedSize.value,
                                          onChanged: (value) {
                                            selectedSize.value = value!;
                                          },
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0), // Smaller padding
                                        ),),
                                      ),
                                      SizedBox(
                                        height: getSize(40),
                                        child: Obx(()=> RadioListTile<String>(
                                          title: MyText(title:'lbl_large'.tr,fontSize: 18,fontWeight: FontWeight.w600,),
                                          value: 'large',
                                          activeColor: ColorConstant.primaryPink,
                                          groupValue: selectedSize.value,
                                          onChanged: (value) {
                                            selectedSize.value = value!;
                                          },
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0), // Smaller padding
                                        ),),
                                      ),
                                    ],
                                  ): Offstage()
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: ColorConstant.black,
                                      shape: BoxShape.circle
                                  ),
                                  padding: getPadding(all: 3),
                                  child: Icon(
                                    Icons.close,
                                    color: ColorConstant.white,
                                    size: getSize(18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                      padding: getPadding(top: 30),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                if(quantity.value > 1){
                                  quantity.value -=1;
                                }
                              },
                              child: Obx(()=> Container(
                                height: getSize(35),
                                width: getSize(35),
                                margin: getMargin(right: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: quantity.value > 1 ? ColorConstant.blue : ColorConstant.blue.withOpacity(.5)
                                ),
                                alignment: Alignment.center,
                                child: MyText(title: "-",fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.white,
                                ),
                              ),)
                          ),
                          Obx(()=>  MyText(title: quantity.value.toString(),fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          GestureDetector(
                            onTap: (){
                              quantity.value+=1;
                            },
                            child: Container(
                              height: getSize(35),
                              width: getSize(35),
                              margin: getMargin(left: 10,right: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstant.blue
                              ),
                              alignment: Alignment.center,
                              child: MyText(title: "+",fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstant.white,
                              ),
                            ),
                          ),

                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                for(int i = 0; i<quantity.value;i++){
                                  addItemsToCart(item,size: selectedSize.value);
                                }
                                bottomBar.value = true;
                                Get.back();
                              },
                              text: "lbl_add_to_cart".tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }



  num? calculatePrice (Items item){
    if(item.smallPrice != null && item.smallPrice != 0){
      return item.smallPrice??0;
    }
    if(item.mediumPrice != null && item.mediumPrice != 0){
      return item.mediumPrice??0;
    }
    if(item.largePrice != null && item.largePrice != 0){
      return item.largePrice??0;
    }

    return 0;
  }

  bool checkForMultipleValues (Items item){
    bool isMultiple = false;

    if(item.smallPrice != null && item.smallPrice != 0){
      if(item.mediumPrice != null && item.mediumPrice != 0){
        isMultiple = true;
      }
      if(item.largePrice != null && item.largePrice != 0){
        isMultiple = true;
      }
    }
    if(item.mediumPrice != null && item.mediumPrice != 0){
      if(item.largePrice != null && item.largePrice != 0){
        isMultiple = true;
      }
    }
    return isMultiple;
  }

  num? checkForDiscountedPrice(Items item){
    if(item.smallDiscountedPrice != null && item.smallDiscountedPrice != 0){
      return item.smallDiscountedPrice??0;
    }
    if(item.mediumDiscountedPrice != null && item.mediumDiscountedPrice != 0){
      return item.mediumDiscountedPrice??0;
    }
    if(item.largeDiscountedPrice != null && item.largeDiscountedPrice != 0){
      return item.largeDiscountedPrice??0;
    }
    return 0;
  }
  num? checkForDiscountedPercentage(Items item){
    if(item.smallDiscountedPercentage != null && item.smallDiscountedPercentage != 0){
      return item.smallDiscountedPercentage??0;
    }
    if(item.mediumDiscountedPercentage != null && item.mediumDiscountedPercentage != 0){
      return item.mediumDiscountedPercentage??0;
    }
    if(item.largeDiscountedPercentage != null && item.largeDiscountedPercentage != 0){
      return item.largeDiscountedPercentage??0;
    }
    return 0;
  }
}
