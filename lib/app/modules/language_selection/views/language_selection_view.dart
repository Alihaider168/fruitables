import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/utils/language_utils.dart';

import '../controllers/language_selection_controller.dart';

class LanguageSelectionView extends GetView<LanguageSelectionController> {
  const LanguageSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    Utils.hideKeyboard(context);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor:  ColorConstant.blackShaded,
      statusBarIconBrightness: Brightness.light,     // White icons on status bar
      systemNavigationBarColor: Colors.white,        // Black navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      // backgroundColor: Colors.orange.shade400.withOpacity(0.5),
      
      // backgroundColor: const Color(0xFFf0f8ff),
      body: Container(
      color:  Colors.grey.shade200,
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: getPadding(left: 25,right: 25,bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: getSize(120),),
        
                  CustomImageView(
                    imagePath: ImageConstant.logo2,
                    height: getSize(40),
                  ),
                  SizedBox(height: getSize(20),),
                  const MyText(title: "Welcome to Rexsa Cafe",fontWeight: FontWeight.bold,fontSize: 20,),
                  const MyText(title: "مرحبًا بكم في ريكسا كافيه",fontWeight: FontWeight.bold,fontSize: 20,),
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
                      title: "Delivery - توصيل",
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
                      title: "Pickup - استلام من الفرع",
                      index: 1,
                      groupValue: controller.selectedPreference.value,
                      onTap: (){
                        controller.selectedPreference.value = 1;
                      }
                  )),
                  Spacer(),
        
                  SizedBox(height: getSize(20),),
                  CustomButton(
                    onTap: () async {
                      Constants.isDelivery.value = (controller.selectedPreference.value == 0);
                      if(controller.fromMenu){
                        Get.back();
                      }else{
                        Get.toNamed(Routes.LOCATION_SELECTION,);
                      }
                      if (controller.selectedLanguage.value == 1) {
                        Get.updateLocale(const Locale('en', 'US'));
                      } else if (controller.selectedLanguage.value == 0) {
                        Get.updateLocale(const Locale('ar', 'SA'));
                      }
        
                      Future.delayed(1.seconds,(){
                        Utils.setUIOverlay();
                      });
                      LanguageUtils languagePreference = LanguageUtils();
                      await languagePreference.saveLanguage("arabic");
                    },
                    text: "Confirm تأكيد",
                  )
                ],
              ),
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
                  color: ColorConstant.primaryPink1,
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
