import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/utils/helper_functions.dart';
import 'package:fruitables/app/data/utils/language_utils.dart';
import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';
import 'package:fruitables/app/data/widgets/otp_text_feild.dart';

class
CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final RxString selectedLanguage = 'English'.obs;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final languagePreference = LanguageUtils();

  @override
  void initState() {
    super.initState();
    getLanguage();

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
              : Padding(
                padding: getPadding(all: 16),
                child: MyText(
                            title: "lbl_hi_guest".tr,fontWeight: FontWeight.bold,
                  fontSize: 18,
                          ),
              ),
          !Constants.isLoggedIn.value ? SizedBox(height: getSize(30),) : SizedBox(
            height: getSize(150),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ColorConstant.white
              ),
              accountName: MyText(
                title: 'Syed Ali Haider',
                fontSize: 18, fontWeight: FontWeight.bold,
                color: ColorConstant.black,
              ),
              accountEmail: MyText(
                title: '+923076497552',
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
          !Constants.isLoggedIn.value ? Offstage() : customTile(icon: Icons.account_balance_wallet,title: "lbl_my_wallet".tr,showPrice: true,price: 0.00),
          !Constants.isLoggedIn.value ? Offstage() : customTile(icon: Icons.loyalty,title: "lbl_loyalty_points".tr,showPrice: true,price: 0.00),

          // customTile(icon: Icons.language,title: "lbl_change_language".tr,showArrow: true),
          !Constants.isLoggedIn.value ? Offstage() : Container(
            padding: getPadding(bottom: 10,left: 15,right: 15,top: 10),
            child: Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: getSize(15),),
                MyText(
                  title: "lbl_change_language".tr,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                Spacer(),
                Obx(() => DropdownButton<String>(
                  value: selectedLanguage.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedLanguage.value = newValue;
                      _changeLanguage(newValue);
                    }
                  },
                  items: <String>['English', 'اردو']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: MyText(title: value),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),

          // Menu Items
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
                Get.toNamed(Routes.FAVOURITES);
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
                showLoginSheet(context);
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
                title: '${"lbl_rs".tr} $price',
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

  void _changeLanguage(String languageCode) async{
    selectedLanguage.value = languageCode;
    if (languageCode == 'English') {
      Get.updateLocale(Locale('en', 'US'));
    } else if (languageCode == 'اردو') {
      Get.updateLocale(Locale('ur', 'PK'));
    }
    Get.back();
    await languagePreference.saveLanguage(languageCode);
  }

  void getLanguage() async {
    selectedLanguage.value = (await languagePreference.getLanguage())??"English";
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
                    Get.back();
                    Constants.isLoggedIn.value = false;
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


  void showSupportCenterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.splash,
                height: getSize(150),
              ),
              SizedBox(height: getSize(15)),
              MyText(
                title: "lbl_support_center".tr,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
              ),
              SizedBox(height: getSize(10)),
              MyText(
                title:'lbl_for_queries'.tr,
                  color: ColorConstant.textGrey,
                  fontSize: 14,
                center: true,
              ),
              SizedBox(height: getSize(20)),
              CustomButton(
                text: "customercare@odpakistan.com",
                prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
                onTap: (){
                  final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'customercare@odpakistan.com',
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


  void showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.splash,
                  height: getSize(150),
                ),
                SizedBox(height: getSize(15)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    title: "enter_email".tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    title: "you_will_receive_6_digit_otp".tr,
                    fontSize: 14,
                    color: ColorConstant.textGrey,
                  ),
                ),
                SizedBox(height: getSize(10)),
                CustomTextFormField(
                  labelText: "email".tr,
                  controller: emailController,
                  validator: (val){
                    return HelperFunction.emailValidate(val??"");
                  },
                ),
                SizedBox(height: getSize(20)),
                CustomButton(
                  text: "send_email".tr,
                  prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      Get.back();
                      showOtpSheet(context);
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
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.splash,
                  height: getSize(150),
                ),
                SizedBox(height: getSize(15)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    title: "otp_verification".tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    title: "${"we_sent_otp_to_email".tr}\n${emailController.text}",
                    fontSize: 14,
                    color: ColorConstant.textGrey,
                  ),
                ),
                SizedBox(height: getSize(20)),
                Container(
                  margin: getPadding(left: getSize(20), right: getSize(20)),
                  child: OtpTextField(
                    //semanticsLabel: SemanticsLabel.LAB_OTP_FIELD,
                    controller: otpController,
                    onChanged: (a) {
                      if (a.length == Constants.otpLength) {
                        Get.back();
                        Constants.isLoggedIn.value = true;
                      }
                    },
                    onComplete: (a) {
                      if (a.length == Constants.otpLength) {

                      }
                    },
                    validator: (value) {
                      return HelperFunction.otpValidate(value!);
                    },
                  ),
                ),
                SizedBox(height: getSize(20)),
                CustomButton(
                  text: "verify".tr,
                  onTap: (){
                    Get.back();
                    Constants.isLoggedIn.value = true;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
