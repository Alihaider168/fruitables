import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/modules/location_selection/controllers/location_selection_controller.dart';

import 'package:get/get.dart';

import '../controllers/language_selection_controller.dart';

class LanguageSelectionView extends GetView<LanguageSelectionController> {
  const LanguageSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    Utils.hideKeyboard(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,     // White icons on status bar
      systemNavigationBarColor: Colors.white,        // Black navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFf0f8ff),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: getPadding(left: 25,right: 25,bottom: 30),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.splash,
                  height: getSize(180),
                ),
                SizedBox(height: getSize(10),),
                const MyText(title: "Welcome to Nahdi",fontWeight: FontWeight.bold,fontSize: 20,),
                const MyText(title: "مرحبًا بكم في النهدي",fontWeight: FontWeight.bold,fontSize: 20,),
                SizedBox(height: getSize(15),),
                // Spacer(),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     MyText(title: "Country",fontWeight: FontWeight.bold,fontSize: 15,),
                //     MyText(title: "دولة",fontWeight: FontWeight.bold,fontSize: 15,),
                //   ],
                // ),
                // SizedBox(height: getSize(8),),
                // Obx(()=> mainWidget(
                //   isSelected: controller.selectedCountry.value == 0,
                //   title: "Saudi Arabia - السعودية",
                //   image: ImageConstant.saudia,
                //   index: 0,
                //   groupValue: controller.selectedCountry.value,
                //   onTap: (){
                //     controller.selectedCountry.value = 0;
                //   }
                // )),
                SizedBox(height: getSize(20),),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(title: "Language",fontWeight: FontWeight.bold,fontSize: 15,),
                    MyText(title: "لغة",fontWeight: FontWeight.bold,fontSize: 15,),
                  ],
                ),
                SizedBox(height: getSize(8),),
                Obx(()=> mainWidget(
                    isSelected: controller.selectedLanguage.value == 0,
                    title: "العربية",
                    index: 0,
                    groupValue: controller.selectedLanguage.value,
                    onTap: (){
                      controller.selectedLanguage.value = 0;
                    }
                )),
                SizedBox(height: getSize(10),),
                Obx(()=> mainWidget(
                    isSelected: controller.selectedLanguage.value == 1,
                    title: "English",
                    index: 1,
                    groupValue: controller.selectedLanguage.value,
                    onTap: (){
                      controller.selectedLanguage.value = 1;
                    }
                )),
                SizedBox(height: getSize(20),),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(title: "Preference",fontWeight: FontWeight.bold,fontSize: 15,),
                    MyText(title: "ترجیح",fontWeight: FontWeight.bold,fontSize: 15,),
                  ],
                ),
                SizedBox(height: getSize(8),),
                Obx(()=> mainWidget(
                  image: ImageConstant.delivery,
                    isSelected: controller.selectedPreference.value == 0,
                    title: "Delivery - ترسیل",
                    index: 0,
                    groupValue: controller.selectedPreference.value,
                    onTap: (){
                      controller.selectedPreference.value = 0;
                    }
                )),
                SizedBox(height: getSize(10),),
                Obx(()=> mainWidget(
                  image: ImageConstant.pickup,
                    isSelected: controller.selectedPreference.value == 1,
                    title: "Pickup - پک اپ",
                    index: 1,
                    groupValue: controller.selectedPreference.value,
                    onTap: (){
                      controller.selectedPreference.value = 1;
                    }
                )),
                Spacer(),

                SizedBox(height: getSize(20),),
                CustomButton(
                  onTap: (){
                    Constants.isDelivery.value = (controller.selectedPreference.value == 0);
                    if(controller.fromMenu){
                      Get.back();
                    }else{
                      Get.toNamed(Routes.LOCATION_SELECTION,);
                    }
                    if (controller.selectedLanguage.value == 1) {
                      Get.updateLocale(const Locale('en', 'US'));
                    } else if (controller.selectedLanguage.value == 0) {
                      Get.updateLocale(const Locale('ur', 'PK'));
                    }
                    Future.delayed(1.seconds,(){
                      Utils.setUIOverlay();
                    });

                  },
                  text: "Confirm تأكيد",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainWidget({
    bool isSelected = false,
    String? image,
    required String title,
    required int index,
    required int groupValue,
    void Function()? onTap,
  }){

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(getSize(10)),
            border: Border.all(color: isSelected ? ColorConstant.primaryPink : Colors.transparent)
        ),
        padding: getPadding(right: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Radio<int>(
                value: index,
                activeColor: ColorConstant.primaryPink,
                groupValue: groupValue,
                onChanged: (value) {
                  onTap!();
                },
              ),
              image == null
                  ? const Offstage()
                  : Container(
                decoration: BoxDecoration(
                    color: ColorConstant.grayBackground,
                    shape: BoxShape.circle
                ),
                margin: getMargin(right: 15),
                padding: getPadding(all: 5),
                child: CustomImageView(
                  svgPath: image,
                  color: ColorConstant.primaryPink,
                  height: getSize(24),
                  width: getSize(24),
                ),
              ),
              // CustomImageView(
              //   imagePath: ImageConstant.saudia,
              //   height: getSize(30),
              //   fit: BoxFit.fitHeight,
              //   margin: getMargin(right: 10),
              // ),
              MyText(title: title,fontSize: 15,fontWeight: FontWeight.w600,),
            ],
          ),
        ),
      ),
    );
  }
}
