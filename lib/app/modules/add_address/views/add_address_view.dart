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
              myLocationEnabled: true,
            ),),
            Positioned(
              top: 50,left: 16,
                child: GestureDetector(
                  onTap: ()=> Get.back(),
                  child: Container(
                    padding: getPadding(left: 12,right: 6,top: 12,bottom: 12),
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
