import 'dart:async';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/user_model.dart';
import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:rexsa_cafe/app/data/utils/auth_utils/auth.dart';
import 'package:rexsa_cafe/app/data/utils/fav_utils/fav_utils.dart';
import 'package:rexsa_cafe/app/data/utils/helper_functions.dart';
import 'package:rexsa_cafe/app/data/utils/language_utils.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/data/widgets/otp_text_feild.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class
CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // final RxString selectedLanguage = 'English'.obs;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final languagePreference = LanguageUtils();

  final AppPreferences _appPreferences = AppPreferences();

  MainMenuController mainMenuController = Get.put(MainMenuController());

  RoundedLoadingButtonController loginController = RoundedLoadingButtonController();
  RoundedLoadingButtonController otpBtnController = RoundedLoadingButtonController();
  RoundedLoadingButtonController signupController = RoundedLoadingButtonController();

  MyAppAuth myAppAuth = MyAppAuth();
  FavUtils favUtils = FavUtils();

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

  @override
  void initState() {
    super.initState();
    // getLanguage();

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConstant.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Constants.isLoggedIn.value
              ? Offstage()
              : Container(
            margin: getMargin(top: 25),
                padding: getPadding(all: 16),
                child: MyText(
                            title: "lbl_hi_guest".tr,fontWeight: FontWeight.bold,
                  fontSize: 18,
                          ),
              ),
          !Constants.isLoggedIn.value ? SizedBox(height: getSize(15),) : SizedBox(
            height: getSize(150),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ColorConstant.white
              ),
              accountName: MyText(
                title: Constants.userModel?.customer?.name??"",
                fontSize: 18, fontWeight: FontWeight.bold,
                color: ColorConstant.black,
              ),
              accountEmail: MyText(
                title: Constants.userModel?.customer?.mobile??"",
                fontSize: 14,
                color: ColorConstant.black,
              ),
              // currentAccountPicture: CircleAvatar(
              //   backgroundColor: ColorConstant.yellow,
              //   child: Text(
              //     'S',
              //     style: TextStyle(fontSize: 24, color: Colors.white),
              //   ),
              // ),
            ),
          ),

          // Wallet and Loyalty Points Section
          !Constants.isLoggedIn.value ? Offstage() : customTile(icon: Icons.account_balance_wallet,title: "lbl_my_wallet".tr,showPrice: true,price: Constants.userModel?.customer?.balance??0),
          !Constants.isLoggedIn.value ? Offstage() : customTile(icon: Icons.loyalty,title: "lbl_loyalty_points".tr,showPrice: true,price: Constants.userModel?.customer?.points??0),

          // customTile(icon: Icons.language,title: "lbl_change_language".tr,showArrow: true),
          !Constants.isLoggedIn.value ? Offstage() :
          customTile(
              icon: Icons.language,
              title: "lbl_change_language".tr,
              showArrow: true,
              onTap: (){
                Get.back();
                Get.toNamed(Routes.LANGUAGE_SELECTION,arguments: {"from_menu" : true});
              }
          ),
          !Constants.isLoggedIn.value ? Offstage() :  customTile(
            icon: Icons.location_on_outlined,
            title: "lbl_my_addresses".tr,
            showArrow: true,
            onTap: (){
              Get.back();
              Get.toNamed(Routes.ADDRESSES);
            }
          ),
          !Constants.isLoggedIn.value ? Offstage() :  customTile(
            icon: Icons.receipt_long,
            title: "lbl_my_orders".tr,
            showArrow: true,
              onTap: (){
                Get.back();
                Get.toNamed(Routes.ORDERS);
              }
          ),
          !Constants.isLoggedIn.value ? Offstage() : customTile(
            icon: Icons.favorite_border,
            title: "lbl_my_favourites".tr,
            showArrow: true,
              onTap: (){
                Get.back();
                Get.toNamed(Routes.FAVOURITES)!.then((val){
                  favUtils.getFavourites();
                });
              }
          ),
          customTile(
            icon: Icons.support_agent,
            title: "lbl_support_center".tr,
            onTap: (){
              showSupportCenterBottomSheet(context);
            }
          ),
          !Constants.isLoggedIn.value ? customTile(
              icon: Icons.exit_to_app,
              title: "lbl_login".tr,
              onTap: (){
                Get.back();
                showLoginSheet();
              }
          ) : customTile(
            icon: Icons.exit_to_app,
            title: "lbl_logout".tr,
            onTap: (){
              showLogoutDialog(context);
            }
          ),
          !Constants.isLoggedIn.value ? Offstage() : customTile(
            icon: Icons.person_remove,
            title: "lbl_req_account_deletion".tr,
            onTap: (){
              showAccountDialog(context);
            }
          ),

        ],
      ),
    );
  }

  Widget customTile({required IconData icon,required String title,bool showPrice = false,num price = 0.00,bool showArrow = false,void Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: getPadding(bottom: 10,left: 15,right: 15,top: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: getSize(15),),
            MyText(
              title: title,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            Spacer(),
            showPrice ? Container(
              padding: getPadding(left: 8,right: 8,top: 4,bottom: 4),
              decoration: BoxDecoration(
                color: ColorConstant.yellow,
                borderRadius: BorderRadius.circular(getSize(5)),
              ),
              child: MyText(
                title:  Utils.checkIfArabicLocale() ? '$price ${'lbl_rs'.tr}' :
                '${"lbl_rs".tr} $price',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ) : Offstage(),
            showArrow ? Icon(Icons.chevron_right) : Offstage()
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          titlePadding: getPadding(top: 15,left: 15,right: 15,bottom: 15),
          contentPadding: getPadding(left: 16, right: 16,top: 10,bottom: 10),
          actionsPadding: getPadding(bottom: 8, right: 16),
          title: Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              title: 'lbl_warning'.tr,
              color: ColorConstant.textGrey,
            ),
          ),
          content: MyText(
            title: 'lbl_are_you_sure_to_logout'.tr,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: MyText(title: "lbl_no".tr,color: ColorConstant.red,),
                ),
                SizedBox(width: getSize(10)),
                TextButton(
                  onPressed: () {
                    Get.back();
                    Constants.isLoggedIn.value = false;
                    Constants.userModel = null;
                    _appPreferences.setIsLoggedIn(loggedIn:false);
                    _appPreferences.setUserData(data: "");
                    Get.offAllNamed(Routes.MAIN_MENU);

                  },
                  child: MyText(title: "lbl_yes".tr,color: ColorConstant.blue,),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  void showAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          titlePadding: getPadding(top: 15,left: 15,right: 15,bottom: 15),
          contentPadding: getPadding(left: 16, right: 16,top: 10,bottom: 10),
          actionsPadding: getPadding(bottom: 8, right: 16),
          title: Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              title: 'lbl_are_you_sure'.tr,
              color: ColorConstant.textGrey,
            ),
          ),
          content: MyText(
            title: 'lbl_once_you_confirm_delete_account'.tr,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: MyText(title: "lbl_no".tr,color: ColorConstant.red,),
                ),
                SizedBox(width: getSize(10)),
                TextButton(
                  onPressed: () {
                    logoutUser();

                  },
                  child: MyText(title: "lbl_yes".tr,color: ColorConstant.blue,),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  void showSupportCenterBottomSheet(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                 ImageConstant.mail,
                height: getSize(150),
              ),
              SizedBox(height: getSize(15)),
              MyText(
                title: "lbl_support_center".tr,
                  fontWeight: FontWeight.bold,
                  fontSize: Utils.checkIfArabicLocale()?16:18,
              ),
              SizedBox(height: getSize(10)),
              MyText(
                title:'lbl_for_queries'.tr,
                  color: ColorConstant.textGrey,
                  alignRight: Utils.checkIfArabicLocale(),
                  fontSize: Utils.checkIfArabicLocale()?12:14,
                center: true,
              ),
              SizedBox(height: getSize(20)),
              CustomButton(
                text: "customercare@rexsa.com",
                prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
                onTap: (){
                  final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'customercare@rexsa.com',
                      queryParameters: {
                        'subject': 'Support Request'
                      }
                  );
                  Utils.launchURL(emailUri);
                },
              ),
              SizedBox(height: getSize(10)),
              CustomButton(
                text: "021111636363",
                prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.call, color: Colors.black)),
                variant: ButtonVariant.OutlineGrey,
                fontStyle: ButtonFontStyle.Grey18,
                onTap: (){
                  Utils.launchURL(Uri.parse("tel: 021111636363"));
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void showLoginSheet() {
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
                                                    countDown();

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
                        mainMenuController.getInitialApisData();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      title: "otp_verification".tr,
                      fontWeight: FontWeight.bold,
                      fontSize:Utils.checkIfArabicLocale()?16: 18,
                    ),
                     Obx(() =>
                    sec.value != 0 ?SizedBox():
                     GestureDetector(
                          onTap: () {
                            onResend(context);
                          },
                          child: MyText(title: "resend".tr,
                                color: ColorConstant.blue,
                            fontWeight: FontWeight.w600,
                            
                              ),
                        ))
                  ],
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
                    margin: getPadding(left: getSize(0), right: getSize(0)),
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
                            textAlign: TextAlign.left))
                       :SizedBox()
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


  Future<void> logoutUser() async {
    await _appPreferences.isPreferenceReady;
    Get.back();
    Constants.isLoggedIn.value = false;
    Constants.userModel = null;
    _appPreferences.setIsLoggedIn(loggedIn: false);
    _appPreferences.setUserData(data: "");
    Get.offAllNamed(Routes.MAIN_MENU);
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
      mainMenuController.getInitialApisData();

    },
        onError: (){
          otpBtnController.stop();
        }
    );
  }
}
