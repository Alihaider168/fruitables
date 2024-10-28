import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/custom_button.dart';
import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';

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
                controller.isInitialized = true;
              },
              initialCameraPosition: CameraPosition(
                target: controller.currentPosition,
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
            ),),

            Positioned(
              bottom: getSize(20),
              left: getSize(15),
              right: getSize(15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(getSize(15))
                    ),
                    padding: getPadding(all: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          title: "lbl_please_select_location".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          onTap:(){
                            if(controller.cityModel?.data?.cities != null){
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
                          labelText: "lbl_area_sub_region".tr,
                          hintText: "lbl_select_your_area".tr,
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
