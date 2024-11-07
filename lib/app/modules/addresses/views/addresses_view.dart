import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';

import 'package:get/get.dart';

import '../controllers/addresses_controller.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // lbl_my_addresses
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_my_addresses".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: Padding(
        padding: getPadding(
          top: 15,bottom: 15
        ),
        child: Obx(()=> ListView.separated(
            itemCount: controller.addresses.length,
            separatorBuilder: (_,__){
              return Divider();
            },
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Get.back(result: controller.addresses[index]);
                },
                child: Container(
                  padding: getPadding(left: 15,top: 10,bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyText(title: address,fontWeight: FontWeight.w500,),
                      ),
                      SizedBox(width: getSize(10),),
                      controller.fromCheckout ? Offstage() : IconButton(
                        onPressed: (){
                          controller.showDeleteAddressDialog(context,index);
                        },
                        icon: Icon(Icons.delete,color: ColorConstant.primaryPink,),
                      )
                    ],
                  ),
                ),
              );
            }
        )),
      ),
      bottomNavigationBar: Container(
          width: size.width,
          height: size.height*0.12,
          padding: getPadding(left: 16,right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSize(20)),
              topRight: Radius.circular(getSize(20)),
            ),
            boxShadow: [
              // Top shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, -4), // Move shadow upwards
              ),
              // Left shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(-4, 0), // Move shadow to the left
              ),
              // Right shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(4, 0), // Move shadow to the right
              ),
            ],
          ),
          child: Center(
            child: CustomButton(
              prefixWidget: Padding(
                padding: getPadding(right: 5),
                child: Icon(
                  Icons.add,color: ColorConstant.white,
                ),
              ),
              text: "lbl_add_address".tr,
            ),
          ),
        )
    );
  }
}
