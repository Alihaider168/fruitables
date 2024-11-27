import 'dart:async';
import 'dart:convert';

import 'package:flutter_svg/svg.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/models/user_model.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:rexsa_cafe/app/data/utils/auth_utils/auth.dart';
import 'package:rexsa_cafe/app/data/utils/cart/cart.dart';
import 'package:rexsa_cafe/app/data/utils/fav_utils/fav_utils.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/data/widgets/otp_text_feild.dart';
import 'package:rexsa_cafe/app/modules/reviews/views/reviews.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/utils/helper_functions.dart';

class MainMenuController extends GetxController {

  Orders? currentOrderForReview;

  bool sheetShown = false;
  Rxn<VoucherModel> selectedVoucher = Rxn<VoucherModel>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<MenuModel> menuModel = MenuModel().obs;
  RxBool bottomBar = false.obs;
  AppPreferences appPreferences = AppPreferences();
  RxBool showAllCategories = false.obs;
  RxBool orderAdded = false.obs;

  Rx<Orders> currentOrder = Orders().obs;
  RxInt ordersLenght = 0.obs;

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
    loadOrders();
    // _scheduleBackgroundTask();
    getMenu();
  }

  getInitialApisData() async {
    await appPreferences.isPreferenceReady;
    appPreferences.getIsLoggedIn().then((value) async {
      if(value==true){
        getOrderStatus();
        getUserDetail();
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

List<Items?>  getProductsIds(List<String> products){
     return Constants.menuItems.where((item) {
      return products.contains(item?.id);
    }).toList();
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
            if((menuModel.value.data?.popups??[]).isNotEmpty){
              showStartingImages(menuModel.value.data?.popups??[]);
            }
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

  void addItemsToCart(Items item, {String size = 'small',num quantity = 1}){
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
            child: Container(
              height: getSize(30),
              child: GestureDetector(
                onTap: (){
                  selectedSize.value = value;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin:getMargin(right: 5),
                      width: getSize(15)
                      ,
                      child: Obx(()=> Radio<String>(
                        value: value,
                        activeColor: ColorConstant.primaryPink,
                        groupValue: selectedSize.value,
                        onChanged: (value) {
                          selectedSize.value = value!;
                        },
                      ),),
                    ),
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
                decoration: BoxDecoration(
                  color: ColorConstant.white,
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
                                        if(Constants.isLoggedIn.value){
                                          favUtils.addOrRemoveFav(item.id);
                                          isLiked.value = !isLiked.value;
                                          if(onFavTap!= null){
                                            onFavTap();
                                          }
                                        }else{
                                          showLoginSheet(context);
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
                                   if(item.calories != 0)
                                  //                               Column(
                                  //                                 children: [
                                                                    SizedBox(height: getSize(10),),
                                  //                                   Divider(),
                                  //                                SizedBox(height: getSize(7),),

                                  //                                 ],
                                  //                               ),
                                    if(item.calories != 0)
                           
 Row(
  crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              
                                             CustomImageView(imagePath: ImageConstant.fire, height: getSize(20),),
                                             SizedBox(width: getSize(5)),

                                                                                              Padding(
                                              padding: getPadding(top: 5),
                                                                                                child: MyText(title: "calories".tr, fontSize: 14,
                                  color: ColorConstant.black,),
                                                                                              ),
                                                                                                                                           SizedBox(width: getSize(5)),

       Padding(
                                              padding: getPadding(top: 5),
         child: MyText(title: item.calories.toString(), fontSize: 14,
                                  color: ColorConstant.black,),
       ),

                                
                                            ],
                                          ),
                                SizedBox(height: getSize(15),),
                                Divider(),
                                if( checkForMultipleValues(item) )
                                SizedBox(height: getSize(15),),
                                checkForMultipleValues(item) ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      
                                          Row(
                                            children: [
                                              MyText(title: "variation".tr,fontWeight: FontWeight.bold,),
                                                                                              MyText(title: "*".tr,fontWeight: FontWeight.bold,color: Colors.red,),
                                
                                            ],
                                          ),
                                          MyText(title: "select_option".tr,fontSize: 12,),
                                      
                                    
                                    Column(children: [
                                      ((item.smallPrice??0) == 0)? Offstage() :getCheckbox(title: " ${'lbl_small'.tr} ",value: 'small',price: item.smallPrice??0,discountedPrice: item.mobileSmall??0),
                                                                        ((item.mediumPrice??0) == 0)? Offstage() :getCheckbox(title: " ${'lbl_medium'.tr} ",value: 'medium',price: item.mediumPrice??0,discountedPrice: item.mobileMedium??0),
                                                                        ((item.largePrice??0) == 0)? Offstage() :getCheckbox(title: " ${'lbl_large'.tr} ",value: 'large',price: item.largePrice??0,discountedPrice: item.mobileLarge??0),
                                                                        ((item.bottlePrice??0) == 0)? Offstage() :getCheckbox(title: " ${'lbl_bottle'.tr} ",value: 'bottle',price: item.largePrice??0,discountedPrice: item.mobileLarge??0),
                                                                     
                                    ],) ],
                                ): Offstage(),
                            

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


  Future<dynamic> getUserDetail() async {
    Utils.check().then((value) async {
      if (value) {

        await BaseClient.get(ApiUtils.getMyDetail,
          onSuccess: (response) async {
            User user = User.fromJson(response.data['customer']);
            Constants.userModel?.customer = user;
            await appPreferences.isPreferenceReady;
            appPreferences.setUserData(data: jsonEncode(Constants.userModel?.toJson()));
            appPreferences.setIsLoggedIn(loggedIn: true);
            return true;
          },
          onError: (error) {
            BaseClient.handleApiError(error);
            return false;
          },
          headers: Utils.getHeader(),
        );
      }
    });
  }

  Future<void> getCurrentOrderContinious() async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.getCurrentOrders,
            onSuccess: (response) async {
              if(((response.data as List?)??[]).isNotEmpty){
                ordersLenght.value = response.data.length;

                
                Orders? order = Orders.fromJson(response.data[ordersLenght.value -1]);
                currentOrder.value = order;
                orderAdded.value = true;



                List<Orders> po = [];
                for(var item in response.data){
                  po.add(Orders.fromJson(item));
                }
                if(Utils.checkIfAnyOrderCompleted(po, currentOrderForReview) && !sheetShown){
                  // sheetShown = true;
                  removeOrder();
                if(currentOrderForReview !=null){
                                    Get.to(()=>ReviewsScreen(order: currentOrderForReview!));

                }else{
                  print("currentOrderForReview is null");
                }
                }

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



  final AppPreferences _appPreferences = AppPreferences();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  RoundedLoadingButtonController loginController = RoundedLoadingButtonController();
  RoundedLoadingButtonController otpBtnController = RoundedLoadingButtonController();
  RoundedLoadingButtonController signupController = RoundedLoadingButtonController();

  MyAppAuth myAppAuth = MyAppAuth();

  RxInt min = 00.obs;
  RxInt sec = 60.obs;
  RxBool resendOtpBool = true.obs;

  void countDown() {
    print("function starts");
    resendOtpBool.value = false;
    debugPrint("${sec.value}");
    startTimer();

}
  void startTimer() {
  if (sec.value != 0) {
    sec.value = sec.value - 1;
    print("sec ${sec.value}");
    Future.delayed(const Duration(seconds: 1), startTimer);
  } else {
    resendOtpBool.value = true;
    print("Timer finished");
  }
    // sec.value = 60;
  }

  onResend(context) async {
    if (sec.value == 00) {
      myAppAuth.sendOTP(phoneController.text);
      CustomSnackBar.showCustomToast(message:
      "${"we_sent_otp_to_email".tr} ${phoneController.text}".tr,);
      min.value = 00;
      sec.value = 60;
      countDown();
    }
  }




  void showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstant.white,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(ImageConstant.online,
                      height: getSize(150),

                    )
                  // (
                  //   imagePath: ImageConstant.online,
                  //   height: getSize(200),
                  // ),
                ),
                SizedBox(height: getSize(20)),
                MyText(
                  title: "phone_number".tr,
                  alignRight:  Utils.checkIfArabicLocale(),
                  fontWeight: FontWeight.bold,
                  fontSize: Utils.checkIfArabicLocale()?18: 16,
                ),
                MyText(
                  title: "you_will_receive_6_digit_otp".tr,
                  fontSize: Utils.checkIfArabicLocale()?12:14,
                  alignRight:  Utils.checkIfArabicLocale(),
                  color: ColorConstant.textGrey,
                ),
                SizedBox(height: getSize(20)),
                CustomTextFormField(

                  hintText: 'enter_phone_number'.tr,
                  // labelText: "enter_phone_number".tr,
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                  validator: (val){
                    return HelperFunction.validateEmailOrPhone(val??"");
                  },
                ),
                SizedBox(height: getSize(20)),
                CustomButton(

                  text: "lbl_login".tr,
                  controller: loginController,
                  // prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: ColorConstant.white)),
                  onTap: () async {
                    if(_formKey.currentState!.validate()){

                      loginController.start();
                      myAppAuth.sendOTP(phoneController.text,onSuccess: (response){
                        loginController.stop();
                        Get.back();
                        if(response["isExist"]== null || response["isExist"] == false ){
                          countDown();


                          showSignupSheet(context);
                        }else{
                          showOtpSheet(context);
                                                    countDown();

                        }

                      },
                          onError: (){
                            loginController.stop();
                          }
                      );

                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSignupSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstant.white,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: _formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    ImageConstant.terms,
                    height: getSize(120),
                  ),
                ),
                SizedBox(height: getSize(20)),
                CustomTextFormField(
                  hintText: "enter_username".tr,
                  // labelText: "enter_username".tr,
                  controller: nameController,
                  textInputType: TextInputType.name,
                  validator: (val){
                    return HelperFunction.stringValidate(val??"");
                  },
                ),
                SizedBox(height: getSize(15),),
                CustomTextFormField(
                  hintText:"enter_phone_number".tr ,
                  // labelText: "enter_phone_number".tr,
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                  readOnly: true,
                  validator: (val){
                    return HelperFunction.validateEmailOrPhone(val??"");
                  },
                ),
                SizedBox(height: getSize(15),),
                CustomTextFormField(
                  // labelText: "enter_email".tr,
                  hintText: "enter_email".tr ,
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  validator: (val){
                    return HelperFunction.emailValidate(val??'');
                  },
                ),
                SizedBox(height: getSize(15),),
                CustomTextFormField(
                  hintText:"enter_otp1".tr ,
                  // labelText: "enter_otp1".tr,
                  controller: otpController,
                  textInputType: TextInputType.number,
                  validator: (val){
                    return HelperFunction.stringValidate(val??"");
                  },
                ),
                SizedBox(height: getSize(20)),
                CustomButton(
                  text: "signup".tr,
                  controller: signupController,
                  // prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: ColorConstant.white)),
                  onTap: () async {
                    if(_formKey2.currentState!.validate()){
                      signupController.start();
                      myAppAuth.signup(nameController.text,emailController.text,phoneController.text,otpController.text,onSuccess: (response) async {
                        signupController.stop();
                        Get.back();
                        Constants.isLoggedIn.value = true;
                        Constants.userModel = UserModel.fromJson(response);
                        await _appPreferences.isPreferenceReady;
                        _appPreferences.setUserData(data: jsonEncode(response));
                        _appPreferences.setIsLoggedIn(loggedIn: true);
                        getInitialApisData();
                      },
                          onError: (){
                            signupController.stop();
                          }
                      );

                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void showOtpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstant.white,
      builder: (BuildContext ctx) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(ctx).viewInsets.bottom + 50),
          child: Form(
            key: _formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    ImageConstant.messageSent,
                    height: getSize(120),
        
                  ),
                ),
                SizedBox(height: getSize(20)),
                MyText(
                  title: "otp_verification".tr,
                  fontWeight: FontWeight.bold,
                  fontSize:Utils.checkIfArabicLocale()?16: 18,
                ),
                MyText(
                  title: "${"we_sent_otp_to_email".tr} \n${phoneController.text}",
                  fontSize:Utils.checkIfArabicLocale()?12: 14,
                  alignRight: Utils.checkIfArabicLocale(),
                  color: ColorConstant.textGrey,
                ),
                SizedBox(height: getSize(20)),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: OtpTextField(
                    //semanticsLabel: SemanticsLabel.LAB_OTP_FIELD,
                    controller: otpController,
                    onChanged: (a) {
                      if (a.length == Constants.otpLength) {
                        callVerifyOtp();
                      }
                    },
                    onComplete: (a) {
                      if (a.length == Constants.otpLength) {
                          
                      }
                    },
                    // validator: (value) {
                    //   return HelperFunction.otpValidate(value!);
                    // },
                  ),
                ),
                SizedBox(height: getSize(10)),
                Padding(
                    padding: getPadding(top: 10, bottom: 10),
                    child: Obx(() =>
                    sec.value != 0 ?
                    Obx(()=> RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "msg_didn_t_get_code".tr,style: TextStyle(
                              color: ColorConstant.black
                          )),
                          TextSpan(
                              text: "${sec.value} ${"seconds".tr}",
                              style: TextStyle(
                                color: ColorConstant.primaryPink,
                              ))
                        ]),
                        textAlign: TextAlign.left)):
                    GestureDetector(
                      onTap: () {
                        onResend(context);
                      },
                      child: MyText(title: "resend".tr,
                        color: ColorConstant.primaryPink,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    )),
                SizedBox(height: getSize(20)),
                CustomButton(
                  text: "verify".tr,
                  controller: otpBtnController,
                  onTap: (){
                    if(otpController.text.length == 6){
                      callVerifyOtp();
                    }else {
                      CustomSnackBar.showCustomErrorToast(message: "enter_valid_otp".tr);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void  callVerifyOtp(){
    otpBtnController.start();
    myAppAuth.login( phoneController.text, otpController.text,onSuccess: (response) async {
      otpBtnController.stop();
      Get.back();
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      Constants.isLoggedIn.value = true;
      Constants.userModel = UserModel.fromJson(response);
      await _appPreferences.isPreferenceReady;
      _appPreferences.setUserData(data: jsonEncode(response));
      _appPreferences.setIsLoggedIn(loggedIn: true);
      getInitialApisData();

    },
        onError: (){
          otpBtnController.stop();
        }
    );
  }



  Future<void> loadOrders() async {
    currentOrderForReview = Orders.fromJson(jsonDecode(await appPreferences.getCurrentOrder()??""));
  }

  Future<void> removeOrder() async {
    // Save lists to SharedPreferences
    appPreferences.removeValue(AppPreferences.prefCurrentOrder);

  }




showStartingImages(List<Banners> list) {
  final PageController pageController = PageController();
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getSize(15)),
      ),
      child: SizedBox(
        height: getSize(450),
        width: size.width - getSize(70),
        child: Column(
          children: [
            // Banner images with left-right scrolling
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    
                    controller: pageController,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: CustomImageView(
                          url: Utils.getCompleteUrl(
                              list[index].image?.key ?? ""),
                          fit: BoxFit.fill,
                          height: getSize(300),
                          width: size.width - 60,
                          radius: getSize(15),
                          margin: getMargin(bottom: 10),
                        ),
                      );
                    },
                  ),
                 
                  Positioned(
                    top: getSize(12),
                    right: getSize(12),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstant.black.withOpacity(0.6),
                        ),
                        padding: getPadding(all: 4),
                        child: Icon(
                          Icons.close,
                          color: ColorConstant.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Dot Indicator
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (pageController.hasClients) {
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Icon(
                        Icons.chevron_left_outlined,
                        color: ColorConstant.white,
                        size: 24,
                        weight: 5,
                        
                      ),
                    ),
                                      SizedBox(width: getSize(10)),

                  SmoothPageIndicator(
                    controller: pageController,
                    count: list.length,
                    
                    effect: WormEffect(
                      paintStyle: PaintingStyle.stroke,
                      dotColor: Colors.white,
                      strokeWidth: 1.5,
                      activeDotColor: Colors.white,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                  SizedBox(width: getSize(10)),
                  GestureDetector(
                      onTap: () {
                        if (pageController.hasClients) {
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Icon(
                        Icons.chevron_right_outlined,
                        color: ColorConstant.white,
                        size: 24,
                                                weight: 5,

                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

}