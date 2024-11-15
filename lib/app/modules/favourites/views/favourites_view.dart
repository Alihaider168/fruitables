import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/widgets/noData.dart';
import 'package:fruitables/app/modules/category_detail/views/category_detail_view.dart';

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
      body:Obx(()=>controller.initialList.isEmpty?Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Center(

          child: NoData(
            svgPath: "assets/images/appreciate.svg",
            message: "lbl_no_fav_description".tr,
            name: "lbl_no_favorite".tr,

          ),
        ),
      ): ListView.builder(
        itemCount: controller.initialList.length,
        itemBuilder: (context, index) {
          final item = controller.initialList[index];

          return ItemWidget(
            item: item??Items(),fromFav: true,
            onFavTap: (){
              Get.back();
              controller.initialList.removeAt(index);
              controller.initialList.refresh();
            },

          );
        },
      )),
    );
  }
}
