import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/data/widgets/noData.dart';
import 'package:rexsa_cafe/app/modules/category_detail/views/category_detail_view.dart';

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
        padding: getPadding(top: 16,bottom: 16),
        child: Column(
          children: [
            SizedBox(height: getSize(5),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: CustomTextFormField(
                labelText: "lbl_search".tr,
                textInputAction: TextInputAction.done,
                onChanged: (value){
                  controller.onChanged(value);
                },
              ),
            ),
            SizedBox(height: getSize(10),),
            Expanded(
              child: Obx(()=>controller.searchText.value == ''?NoData(
                svgPath: 'assets/images/search.svg',
                name: "search_your_desire".tr,
                message: "you_can_search_using".tr,
              ):controller.searchText.value != '' && controller.filteredItems.isEmpty?NoData(
                svgPath: 'assets/images/no_product.svg',
                name: "no_product_matched".tr,
                message: "you_can_search_using".tr,
              ): ListView.builder(
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
      // bottomNavigationBar: Obx(()=>  !controller.mainMenuController.bottomBar.value  && !controller.mainMenuController.orderAdded.value? Offstage() : CartBottom(showCurrentOrder :controller.mainMenuController.orderAdded.value,order: controller.mainMenuController.currentOrder.value, ordersLength: controller.mainMenuController.ordersLenght.value -1,)),
    );
  }
}
