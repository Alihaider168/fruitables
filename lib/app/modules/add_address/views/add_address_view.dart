import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/custom_button.dart';
import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/add_address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});
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
                top: 50,left: Utils.checkIfUrduLocale() ? null : 16,right: Utils.checkIfUrduLocale() ? 16 : null,
                child: GestureDetector(
                  onTap: ()=> Get.back(),
                  child: Container(
                    padding: getPadding(left: Utils.checkIfUrduLocale() ?4: 12,right: Utils.checkIfUrduLocale() ? 12: 4,top: 12,bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(getSize(5))
                    ),
                    child: Icon(Icons.arrow_back_ios),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: getSize(5),),
                            Icon(Icons.my_location)
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
                        MyText(
                          title: "new_address".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          controller: controller.addressController,
                          labelText: "address".tr,
                          hintText: "address".tr,
                        ),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          controller: controller.regionController,
                          labelText: "lbl_area_sub_region".tr,
                          hintText: "lbl_select_your_area".tr,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getSize(20),),
                  CustomButton(
                    onTap: (){
                      if(controller.addressController.text.isNotEmpty && controller.regionController.text.isNotEmpty){
                        Get.back(result: controller.addressController.text);
                      }
                    },
                    text: "save_address".tr,
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}
