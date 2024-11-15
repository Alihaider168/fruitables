import 'package:flutter/material.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/modules/category_detail/views/category_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});
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
        title: MyText(title: "lbl_search_products".tr,fontWeight: FontWeight.bold,fontSize: 22,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: Padding(
        padding: getPadding(all: 16),
        child: Column(
          children: [
            SizedBox(height: getSize(5),),
            CustomTextFormField(
              labelText: "lbl_search".tr,
              textInputAction: TextInputAction.done,
              onChanged: (value){
                controller.onChanged(value);
              },
            ),
            SizedBox(height: getSize(15),),
            Expanded(
              child: Obx(()=> ListView.builder(
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];

                  return ItemWidget(item: item);
                },
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(()=> CartBottom(showCurrentOrder :controller.mainMenuController.orderAdded.value,order: controller.mainMenuController.currentOrder.value,)),
    );
  }
}
