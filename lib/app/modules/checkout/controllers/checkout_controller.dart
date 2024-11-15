import 'dart:async';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/models/user_model.dart';
import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:rexsa_cafe/app/data/utils/auth_utils/auth.dart';
import 'package:rexsa_cafe/app/data/utils/helper_functions.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/data/widgets/otp_text_feild.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:intl/intl.dart' as intl;

import '../../../data/core/app_export.dart';

class CheckoutController extends GetxController {
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
    resendOtpBool.value = false;
    debugPrint("${sec.value}");
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value != 0) {
        sec.value = sec.value - 1;
      } else {
        timer.cancel();
        resendOtpBool.value = true;
      }
    });
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




  MainMenuController menuController = Get.put(MainMenuController());
  RxBool instructions = false.obs;

  RoundedLoadingButtonController checkoutController = RoundedLoadingButtonController();

  TextEditingController addressController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  RxString selectedMethod = "".obs;
  RxString selectedTime = "".obs;

  RxInt selectedDayIndex = 0.obs;
  RxInt selectedHourIndex = 0.obs;
  RxInt selectedMinuteIndex = 0.obs;

  List<String> days = [
    "today".tr,
    intl.DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 1))),
    intl.DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 2))),
  ];

  List<int> getHours() {
    if (selectedDayIndex.value == 0) {
      return List.generate(24 - DateTime.now().hour, (index) => DateTime.now().hour + index);
    } else {
      return List.generate(24, (index) => index);
    }
  }

  List<int> getMinutes() {
    if (selectedDayIndex.value == 0 && selectedHourIndex.value == 0) {
      int startingMinute = (DateTime.now().minute ~/ 10 + 1) * 10;
      return List.generate((60 - startingMinute) ~/ 10, (index) => startingMinute + index * 10);
    } else {
      return List.generate(6, (index) => index * 10); // Minutes in increments of 10
    }
  }

  void showDeliveryTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: getPadding(all: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()=> Get.back(),
                    child: MyText(title: "cancel".tr,
                      color: ColorConstant.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      selectedTime.value = "${days[selectedDayIndex.value]}, ${(getHours()[selectedHourIndex.value]).toString().padLeft(2, '0')}:${getMinutes()[selectedMinuteIndex.value].toString().padLeft(2, '0')}";
                      Get.back();
                    },
                    child: MyText(title: "lbl_done".tr,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.blue,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    // Day picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedDayIndex.value = index;
                          selectedHourIndex.value = 0;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: days.length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedDayIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              days[index],
                                fontSize: 18,
                                color: index == selectedDayIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      ),
                    ),
                    // Hour picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedHourIndex.value = index;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getHours().length,
                          builder: (context, index) {
                            return Obx(()=>  Container(
                              color: index == selectedHourIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getHours()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedHourIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                    // Minute picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedMinuteIndex.value = index;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getMinutes().length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedMinuteIndex.value? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getMinutes()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedMinuteIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<dynamic> addOrder() async {
    await menuController.cart.loadCartFromPreferences();
    Utils.check().then((value) async {
      if (value) {
        checkoutController.start();
        List<Map<String, dynamic>> products = [];

        for(int i=0;i<menuController.cart.items.length;i++){
          final cItem = menuController.cart.items[i];
          products.add({
            "productId": cItem.item.id,
            "name":  Utils.checkIfArabicLocale() ? cItem.item.name : cItem.item.englishName,
            "size": cItem.size,
            "quantity": cItem.quantity,
            "price": menuController.cart.getPrice(cItem)
          });
        }



        await BaseClient.post(ApiUtils.addOrder,
            onSuccess: (response) async {
          checkoutController.stop();
              print(response);
              CustomSnackBar.showCustomToast(message: "order_created".tr);
              Get.back();
          Get.toNamed(Routes.ORDER_PLACED,arguments: {"order":Orders.fromJson(response.data)});
          menuController.cart.clearCart();
          menuController.bottomBar.value = false;
              return true;
            },
            onError: (error) {
              checkoutController.stop();
              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader(),
            data: {
              "branch": Constants.selectedBranch?.id,
              "pickupTime": Constants.isDelivery.value ? null : selectedTime.value,
              "totalAmount": menuController.cart.getTotalDiscountedPrice() + menuController.cart.getTax() + (Constants.isDelivery.value ? Constants.DELIVERY_FEES : 0),
              "tax": menuController.cart.getTax(),
              "type" : Constants.isDelivery.value ? "delivery" : "pickup",
              "address": addressController.text,
              "instructions" : instructionsController.text,
              "discount": menuController.cart.getTotalDiscountForCart(),
              "products": products
            });
      }
    });
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
                  // prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
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
                  // prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
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
                        menuController.getInitialApisData();
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
                  title: "${"we_sent_otp_to_email".tr} ${phoneController.text}",
                  fontSize:Utils.checkIfArabicLocale()?12: 14,
                  alignRight: Utils.checkIfArabicLocale(),
                  color: ColorConstant.textGrey,
                ),
                SizedBox(height: getSize(20)),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    margin: getPadding(left: getSize(20), right: getSize(20)),
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
      menuController.getInitialApisData();

    },
        onError: (){
          otpBtnController.stop();
        }
    );
  }

}
