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
              onTap: (LatLng latlng){
                controller.moveToNewLocation(latlng);
              },
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
                        MyText(
                          title: "new_address".tr,
                          fontSize: 14,
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
                          controller: controller.streetController,
                          labelText: "street".tr,
                          hintText: "street".tr,
                        ),
                        SizedBox(height: getSize(15),),
                        CustomTextFormField(
                          controller: controller.floorController,
                          labelText: "floor".tr,
                          hintText: "floor".tr,
                        ),
                        SizedBox(height: getSize(15),),
                        SizedBox(
                          height: getSize(60),
                          child: ListView.separated(
                            itemCount: controller.labels.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_,__){
                              return SizedBox(width: getSize(15),);
                            },
                            itemBuilder: (_,index){
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  controller.selectedLabel.value = index;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(()=> Container(
                                      margin: getMargin(bottom: 3),
                                      padding: getPadding(all: 8),
                                      decoration: BoxDecoration(
                                        color: controller.selectedLabel.value == index ? ColorConstant.grayBackground : ColorConstant.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorConstant.grayBorder)
                                      ),
                                      child: CustomImageView(
                                        imagePath: controller.labelImages[index],
                                        height: getSize(20),
                                        width: getSize(20),
                                      ),
                                    ),),
                                    MyText(
                                      title: controller.labels[index].tr,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getSize(20),),
                  CustomButton(
                    onTap: (){
                      if(controller.addressController.text.isNotEmpty
                          && controller.selectedLabel.value != -1
                      ){
                        Get.back(result: {
                          "address" :controller.addressController.text,
                          "street" : controller.streetController.text,
                          "floor" : controller.floorController.text,
                          "label" : controller.labels[controller.selectedLabel.value],
                        });
                      }else{
                        CustomSnackBar.showCustomErrorToast(message: "add_address_amd_select_label".tr);
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

  Widget labelWidget(String image,String title,{bool isSelected = false}){

    return Container(

    );
  }
}
