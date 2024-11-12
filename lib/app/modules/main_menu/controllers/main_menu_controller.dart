import 'package:flutter/cupertino.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/utils/cart/cart.dart';

class MainMenuController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Rx<MenuModel> menuModel = MenuModel().obs;
  RxBool bottomBar = false.obs;

  RxBool showAllCategories = false.obs;
  RxBool orderAdded = false.obs;

  Cart cart = Cart();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    getMenu();
  }

  Future<void> loadCart() async {
    await cart.loadCartFromPreferences();
    if(cart.items.isNotEmpty){
      bottomBar.value = true;
    }else{
      bottomBar.value = false;
    }
  }

  Future<dynamic> getMenu() async {
    Utils.check().then((value) async {
      // isLoading.value = true;
      if (value) {
        await BaseClient.get(ApiUtils.getMenu,
          onSuccess: (response) async {
            menuModel.value = MenuModel.fromJson(response.data);
            isLoading.value = false;
            return true;
          },
          onError: (error) {
            isLoading.value = false;
            BaseClient.handleApiError(error);
            update();
            return false;
          },
        );
      }
    });
  }

  void addItemsToCart(Items item, {String size = 'small',int quantity = 1}){
    cart.addItem(item, size, quantity);
    loadCart();
  }


  showAddToCartItemSheet(BuildContext ctx, Items item,{bool fromFav = false,void Function()? onFavTap}) {
    RxInt quantity = 1.obs;
    RxString selectedSize = "small".obs;
    RxBool isLiked =(fromFav).obs;
    if((item.bottlePrice??0) != 0 ){
      selectedSize.value = "bottle";
    }else if((item.largePrice??0) != 0 ){
      selectedSize.value = "large";
    }else if((item.mediumPrice??0) != 0 ) {
      selectedSize.value = "medium";
    }else if((item.smallPrice??0) != 0 ) {
      selectedSize.value = "small";
    }

      Widget getCheckbox({String value = 'small',required String title,num price = 0,num discountedPrice = 0,}){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: getSize(30),
              child: GestureDetector(
                onTap: (){
                  selectedSize.value = value;
                },
                child: Row(
                  children: [
                    Obx(()=> Radio<String>(
                      value: value,
                      activeColor: ColorConstant.primaryPink,
                      groupValue: selectedSize.value,
                      onChanged: (value) {
                        selectedSize.value = value!;
                      },
                    ),),
                    MyText(title: title,fontSize: 15,fontWeight: FontWeight.w600,),
                  ],
                ),
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${discountedPrice != 0 ? discountedPrice : price}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black, // Change this to the desired color
              ),

              // Conditionally show the original price if a discount is present
              if (discountedPrice != 0)
                MyText(
                  title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${price}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                  cut: true, // Strikethrough for original price
                ),
            ],
          )
        ],
      );
    }


    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true, // Allows the sheet to expand beyond half screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(getSize(15)),
          topRight: Radius.circular(getSize(15)),
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.7, // Start expanded to full screen
            minChildSize: 0.5,     // Minimum size is full screen
            maxChildSize: 0.9,
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
                                    url: Utils.getCompleteUrl(item.image?.key),
                                    width: getSize(180),
                                    height: getSize(180),
                                    fit: BoxFit.contain,
                                    margin: getMargin(bottom: 10),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Utils.checkIfArabicLocale() ? Alignment.centerRight: Alignment.centerLeft,
                                        child: MyText(
                                          title: Utils.checkIfArabicLocale() ? item.name??"" : item.englishName??"",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: getSize(15),),
                                    GestureDetector(
                                      onTap: (){
                                        isLiked.value = !isLiked.value;
                                      },
                                      child: Obx(()=> CustomImageView(
                                        svgPath: isLiked.value ? ImageConstant.likeActive : ImageConstant.likeInactive,
                                        color: isLiked.value ? ColorConstant.primaryPink : ColorConstant.black,
                                        height: getSize(20),
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
                                          // if (checkForMultipleValues(item))
                                            // TextSpan(
                                            //   text: '${'lbl_from'.tr}  ', // Prefix text
                                            //   style: TextStyle(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w700,
                                            //     color: Colors.black, // Change this to the desired color
                                            //   ),
                                            // ),

                                          // Display the price
                                          TextSpan(
                                            text: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${checkForDiscountedPrice(item) != 0 ? checkForDiscountedPrice(item) : calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"} ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black, // Change this to the desired color
                                            ),
                                          ),

                                          // Conditionally show the original price if a discount is present
                                          if (checkForDiscountedPrice(item) != 0   && checkForDiscountedPrice(item) != calculatePrice(item))
                                            TextSpan(
                                              text: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr}"}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                                                decoration: TextDecoration.lineThrough, // Strikethrough for original price
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: checkForDiscountedPrice(item)!= 0 && checkForDiscountedPrice(item) != calculatePrice(item),
                                      child: Container(
                                        margin: getMargin(left: 15),
                                        padding: getPadding(left: 10,right: 10,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            color: ColorConstant.grayBackground,
                                            borderRadius: BorderRadius.circular(getSize(15))
                                        ),
                                        child: MyText(
                                          title:
                                          "${checkForDiscountedPercentage(item)!= 0? checkForDiscountedPercentage(item).toString().split(".")[0] :""}% ${'lbl_off'.tr}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                item.description == null &&  item.englishDescription == null? Offstage() : SizedBox(height: getSize(10),),
                                item.description == null &&  item.englishDescription == null? Offstage() : MyText(
                                  title: Utils.checkIfArabicLocale() ? (item.description??"") : (item.englishDescription??""),
                                  fontSize: 14,
                                  color: ColorConstant.black,
                                ),
                                SizedBox(height: getSize(15),),
                                Divider(),
                                SizedBox(height: getSize(15),),
                                checkForMultipleValues(item) ? Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MyText(title: "variation".tr,fontWeight: FontWeight.bold,),
                                            MyText(title: "select_option".tr,fontSize: 12,),
                                          ],
                                        ),
                                        Spacer(),
                                        MyText(title: "required *  ",fontSize: 14,color: ColorConstant.red,),
                                      ],
                                    ),
                                    ((item.smallPrice??0) == 0)? Offstage() :getCheckbox(title: 'lbl_small'.tr,value: 'small',price: item.smallPrice??0,discountedPrice: item.mobileSmall??0),
                                    ((item.mediumPrice??0) == 0)? Offstage() :getCheckbox(title: 'lbl_medium'.tr,value: 'medium',price: item.mediumPrice??0,discountedPrice: item.mobileMedium??0),
                                    ((item.largePrice??0) == 0)? Offstage() :getCheckbox(title: 'lbl_large'.tr,value: 'large',price: item.largePrice??0,discountedPrice: item.mobileLarge??0),
                                    ((item.bottlePrice??0) == 0)? Offstage() :getCheckbox(title: 'lbl_bottle'.tr,value: 'bottle',price: item.largePrice??0,discountedPrice: item.mobileLarge??0),
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
                         Container(
                           margin: getMargin(right: 8,left: 8),
                           child: Obx(()=>  MyText(title: quantity.value.toString(),fontSize: 20,
                             fontWeight: FontWeight.bold,
                           ),),
                         ),
                          GestureDetector(
                            onTap: (){
                              quantity.value+=1;
                            },
                            child: Container(
                              height: getSize(35),
                              width: getSize(35),
                              margin: getMargin(left: Utils.checkIfArabicLocale() ? 10: null,right: !Utils.checkIfArabicLocale() ? 10: null),
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
                                if(selectedSize.value!= null || !checkForMultipleValues(item)){
                                  addItemsToCart(item,size: selectedSize.value??'small',quantity: quantity.value);
                                  bottomBar.value = true;
                                  Get.back();
                                }else{
                                  CustomSnackBar.showCustomErrorToast(message: "Please select size");
                                }

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
    if(item.mobileSmall != null && item.mobileSmall != 0){
      return item.mobileSmall??0;
    }
    if(item.mobileMedium != null && item.mobileMedium != 0){
      return item.mobileMedium??0;
    }
    if(item.mobileLarge != null && item.mobileLarge != 0){
      return item.mobileLarge??0;
    }
    return 0;
  }

  num? checkForDiscountedPercentage(Items item){
    if(item.mobileSmall != null && item.mobileSmall != 0){
      return 100 -((item.mobileSmall??0)/(item.smallPrice??0)*100);
    }
    if(item.mobileMedium != null && item.mobileBottle != 0){
      return 100 - ((item.mobileMedium??0)/(item.mediumPrice??0)*100);
    }
    if(item.mobileLarge != null && item.mobileLarge != 0){
      return 100 - ((item.mobileLarge??0)/(item.largePrice??0)*100);
    }
    return 0;
  }


  checkPricesForCheckout(Items item,String size){
    if(size == 'small'){
      if((item.mobileSmall??0) != 0 && item.smallPrice != item.mobileSmall ){
        return item.mobileSmall??0;
      }else{
        return item.smallPrice??0;
      }
    }
    if(size == 'medium'){
      if((item.mobileMedium??0) != 0 && item.mediumPrice != item.mobileMedium ){
      // if(item.mobileMedium != null && item.mobileMedium != 0){
        return item.mobileMedium??0;
      }else{
        return item.mediumPrice??0;
      }
    }
    if(size == 'large'){
      if((item.mobileLarge??0) != 0 && item.largePrice != item.mobileLarge ){
      // if(item.mobileLarge != null && item.mobileLarge != 0){
        return item.mobileLarge??0;
      }else{
        return item.largePrice??0;
      }
    }
  }
}
