import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/custom_button.dart';
import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/location_selection_controller.dart';

class LocationSelectionView extends GetView<LocationSelectionController> {
  const LocationSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseviewAuthScreen(
        child:Stack(
          children: [
            Obx(() => GoogleMap(
              markers: {controller.currentMarker.value},
              circles: {controller.currentCircle.value},
              onMapCreated: (GoogleMapController controller1) {
                controller.mapController = controller1;
                },
              initialCameraPosition: CameraPosition(
                target: controller.currentPosition,
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: false,

            ),),
            Positioned(
                top: 50,left: Utils.checkIfArabicLocale() ? null : 16,right: Utils.checkIfArabicLocale() ? 16 : null,
                child: GestureDetector(
                  onTap: ()=> Get.back(),
                  child: Container(
                    padding: getPadding(left: Utils.checkIfArabicLocale() ?4: 12,right: Utils.checkIfArabicLocale() ? 12: 4,top: 12,bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(getSize(5))
                    ),
                    child: Icon(Icons.arrow_back_ios,size: getSize(18),),
                  ),
                )),

            Positioned(
              bottom: getSize(20),
              left: getSize(15),
              right: getSize(15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        controller.moveToCurrentLocation();
                      },
                      child: Container(
                        margin: getMargin(bottom: 10),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(getSize(50))
                        ),
                        padding: getPadding(left: 15,right: 15,top: 10,bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText(
                              title: "locate_me".tr,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: getSize(5),),
                            Icon(Icons.my_location,size: getSize(18),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(getSize(15))
                    ),
                    padding: getPadding(all: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(()=> MyText(
                          title: !Constants.isDelivery.value ? "which_outlet_would_you_pickup_from".tr : "lbl_please_select_location".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          onTap:(){
                            if(controller.cityModel?.cities != null){
                              controller.showCitySheet(context);
                            }else{
                              CustomSnackBar.showCustomToast(message: "lbl_no_cities_available".tr);
                            }
                          },
                          controller: controller.cityController,
                          labelText: "lbl_city_region".tr,
                          hintText: "lbl_select_your_city".tr,
                          readOnly: true,
                          suffix: Icon(Icons.keyboard_arrow_down),
                        ),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          onTap:(){
                              controller.showCustomBottomSheet(context);
                          },
                          controller: controller.regionController,
                          labelText: Utils.checkIfArabicLocale() ? "branch".tr:"lbl_area_sub_region".tr,
                          hintText: Utils.checkIfArabicLocale() ? "branch".tr:"lbl_select_your_area".tr,
                          readOnly: true,
                          suffix: Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getSize(20),),
                  CustomButton(
                    onTap: (){
                      if(controller.cityController.text.isNotEmpty && controller.regionController.text.isNotEmpty){
                        Constants.selectedCity = controller.selectedCityModel;
                        Constants.selectedBranch = controller.selectedRegionModel;
                        Get.offAllNamed(Routes.MAIN_MENU);
                      }
                    },
                    text: "lbl_confirm_location".tr,
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}
