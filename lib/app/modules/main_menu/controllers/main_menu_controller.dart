import 'dart:convert';

import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:rexsa_cafe/app/modules/orders/controllers/orders_controller.dart';
import 'package:http/http.dart' as http;
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/utils/cart/cart.dart';
import 'package:rexsa_cafe/app/data/utils/fav_utils/fav_utils.dart';

class MainMenuController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<MenuModel> menuModel = MenuModel().obs;
  RxBool bottomBar = false.obs;
  AppPreferences appPreferences = AppPreferences();
  RxBool showAllCategories = false.obs;
  RxBool orderAdded = false.obs;

  Rx<Orders> currentOrder = Orders().obs;

  Cart cart = Cart();
  FavUtils favUtils = FavUtils();

  RxBool isLoading = true.obs;


  @override
  void dispose() {
    super.dispose();
  }


  @override
  void onInit() {
    super.onInit();
    getInitialApisData();

    getMenu();
  }

  getInitialApisData() async {
    await appPreferences.isPreferenceReady;
    appPreferences.getIsLoggedIn().then((value) async {
      if(value==true){
        getOrderStatus();
        favUtils.getFavourites();
      }else{
        bottomBar.value = false;
      }
      loadCart();
    }).catchError((err) async {
      bottomBar.value = false;
      loadCart();
    });
  }

  void getOrderStatus(){
    getCurrentOrderContinious();
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
            Constants.menuItems = [];
            Constants.menuItems.addAll(menuModel.value.data?.items??[]);
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

    if(favUtils.productIds.contains(item.id)){
      isLiked.value = true;
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
          Container(
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${discountedPrice != 0 ? discountedPrice : price}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black, // Change this to the desired color
                ),
            
                // Conditionally show the original price if a discount is present
                if (discountedPrice != 0 && discountedPrice != price)
                  MyText(
                    title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${price}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                    cut: true, // Strikethrough for original price
                  ),
              ],
            ),
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
                                        favUtils.addOrRemoveFav(item.id);
                                        isLiked.value = !isLiked.value;
                                        if(onFavTap!= null){
                                          onFavTap();
                                        }

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
                                    MyText(title:  "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${checkForDiscountedPrice(item) != 0 ? checkForDiscountedPrice(item) : calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "} ",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                    checkForDiscountedPercentage(item)!= 0 ?MyText(title:  "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${calculatePrice(item)} ${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                                      cut: true,
                                    ): Offstage(),
                                    // RichText(
                                    //   text: TextSpan(
                                    //     children: [
                                    //       // Check if the prefix 'From' should be added
                                    //       // if (checkForMultipleValues(item))
                                    //         // TextSpan(
                                    //         //   text: '${'lbl_from'.tr}  ', // Prefix text
                                    //         //   style: TextStyle(
                                    //         //     fontSize: 16,
                                    //         //     fontWeight: FontWeight.w700,
                                    //         //     color: Colors.black, // Change this to the desired color
                                    //         //   ),
                                    //         // ),
                                    //
                                    //       // Display the price
                                    //       TextSpan(
                                    //         text: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${checkForDiscountedPrice(item) != 0 ? checkForDiscountedPrice(item) : calculatePrice(item)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "} ",
                                    //         style: TextStyle(
                                    //           fontSize: 15,
                                    //           fontWeight: FontWeight.w700,
                                    //           color: Colors.black, // Change this to the desired color
                                    //         ),
                                    //       ),
                                    //
                                    //       // Conditionally show the original price if a discount is present
                                    //       if (checkForDiscountedPrice(item) != 0   && checkForDiscountedPrice(item) != calculatePrice(item))
                                    //         TextSpan(
                                    //           text: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${calculatePrice(item)} ${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                                    //           style: TextStyle(
                                    //             fontSize: 14,
                                    //             fontWeight: FontWeight.w700,
                                    //             color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                                    //             decoration: TextDecoration.lineThrough, // Strikethrough for original price
                                    //           ),
                                    //         ),
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(width: getSize(10),),
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
                                          fontSize: 10,
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
                                  alignRight: Utils.checkIfArabicLocale() ? true : null,
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

  Future<void> getCurrentOrderContinious() async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.getCurrentOrders,
            onSuccess: (response) async {
              if(((response.data as List?)??[]).isNotEmpty){
                Orders? order = Orders.fromJson(response.data[0]);
                currentOrder.value = order;
                orderAdded.value = true;
                await Future.delayed(Duration(seconds: 10));
                getCurrentOrderContinious();
              }else{
                orderAdded.value = false;
              }

              return true;
            },
            onError: (error) {
              // BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader()
        );
      }
    });

  }
}
