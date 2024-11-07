import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/modules/category_detail/views/category_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/favourites_controller.dart';

class FavouritesView extends GetView<FavouritesController> {
  const FavouritesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_my_favourites".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body:Obx(()=> ListView.builder(
        itemCount: controller.initialList.length,
        itemBuilder: (context, index) {
          final item = controller.initialList[index];

          return ItemWidget(
            item: item,fromFav: true,

          );
        },
      )),
    );
  }
}
