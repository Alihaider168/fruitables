import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';

import 'package:get/get.dart';

import '../controllers/add_payment_controller.dart';

class AddPaymentView extends GetView<AddPaymentController> {
  const AddPaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "payment_options".tr,color: ColorConstant.white,fontSize: 22,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: controller.icons.length,
        separatorBuilder: (_,__){
          return Divider();
        },
        itemBuilder: (_,index){
          return ListTile(
            onTap: (){
              Get.back(result: controller.paymentTypes[index]);
            },
            leading: Icon(controller.icons[index]),
            title: MyText(
              title: controller.paymentTypes[index],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
