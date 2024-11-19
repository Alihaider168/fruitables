import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_drawer.dart';
import 'package:rexsa_cafe/app/data/widgets/noData.dart';
import 'package:rexsa_cafe/app/data/widgets/skeleton.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_my_orders".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
        body: Obx(()=>controller.isLoading.value? Skeleton(height: Get.height,width: Get.width,):controller.myOrders.isEmpty ?
        Container(
          height: Get.height,width: Get.width,
          child: Center(child: NoData(
            svgPath: 'assets/images/emptyCart.svg',
            name: "no_order_found".tr,
            message: "no_order_found_desc".tr,
          )),
        ):

      Obx(()=> ListView.builder(
        itemCount: controller.myOrders.length,
        padding: getPadding(all: 16),
        itemBuilder: (context, index) {
          final order = controller.myOrders[index];
          // return OrderCard(order: order);
          return GestureDetector(
            onTap: (){
              Get.toNamed(Routes.NEW_DETAIL,arguments: {'order': order});
            },
            child: PastOrderTile(
              imageUrl: order.branch?.image??"",
              title: order.branch?.name??"",
              deliveryDate: order.deliveredAt??"",
              description: (order.products??[]).map((element)=> element.name.toString()).join(", "),
              price: "${order.totalAmount??0}",
              rating: 3,
              onReorder: (){
                for(int i=0;i<(order.products??[]).length;i++){
                  final item = (order.products??[])[i];

                  Items? foundItem = (controller.menuController.menuModel.value.data?.items??[]).firstWhere(
                        (test) => test.id == item.id || test.id == item.productId,
                  );
                  if(foundItem != null){
                    controller.menuController.addItemsToCart(
                      foundItem,
                      size: item.size??'bottle',
                      quantity: item.quantity??1
                    );
                    controller.menuController.loadCart();
                    controller.menuController.bottomBar.value = true;
                  }

                }
                controller.menuController.loadCart();
                Get.toNamed(Routes.CART);
              },
            ),
          );
        },
      )))
    );
  }
}



class OrderCard extends StatelessWidget {
  final Orders order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(order.products![0].name);
        print(order.products![0].arabicName);
        if(order.status == 'delivered' || order.status == 'cancelled'){
          Get.toNamed(Routes.ORDER_PLACED,arguments: {'order': order});
        }else{
          Get.toNamed(Routes.CURRENT_ORDER_DETAIL,arguments: {'order': order});
        }

      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: getMargin(bottom: 16),
        child: Padding(
          padding: getPadding(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title:
                    "${"order".tr} #${order.saleId}",
                    fontSize: 14, fontWeight: FontWeight.bold,
                  ),
                  MyText(title:
                  DateFormat("d MMM, yy").format(DateTime.parse(order.createdAt??"")),
                    color: ColorConstant.textGrey,
                  ),
                ],
              ),
              SizedBox(height: getSize(8)),
              MyText(title:
                "${"status".tr}: ${(order.status??" ").capitalizeFirst}",
                  color: order.status == "completed"
                      ? ColorConstant.green
                      : order.status == "cancelled"
                      ? ColorConstant.red
                      : order.status == "ready"
                      ? ColorConstant.primaryPink1
                      : ColorConstant.primaryPink,
                  fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              SizedBox(height: getSize(8)),
              MyText(title:
                "${"instructions".tr}: ${(order.instructions??"").isNotEmpty ? (order.instructions) :("none".tr)}",
                  color:ColorConstant.primaryPink,
                fontSize: 12,
              ),
              SizedBox(height: getSize(8)),
              MyText(title:
                "${"items".tr}: ${(order.products??[]).length}",
                  color:ColorConstant.primaryPink,
                fontSize: 12,
              ),
              SizedBox(height: getSize(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title:
                    "lbl_total".tr,
                    color: ColorConstant.textGrey,
                  ),
                  MyText(title:
                    "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${order.totalAmount??0.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                    fontSize: 14, fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PastOrderTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String deliveryDate;
  final String description;
  final String price;
  final double? rating;
  final void Function()? onReorder;

  const PastOrderTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.deliveryDate,
    required this.description,
    required this.price,
    this.rating,
    required this.onReorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstant.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(8))),
      margin: getMargin(top: 8,bottom: 8,),
      child: Padding(
        padding: getPadding(all: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  url: Utils.getCompleteUrl(imageUrl),
                  height: getSize(60),
                  width: getSize(60),
                  fit: BoxFit.cover,
                  radius: getSize(8),
                ),
                SizedBox(width: getSize(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(title:
                        title,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: getSize(4)),
                      MyText(title:
                        "${"delivered_on".tr} ${deliveryDate}",
                          fontSize: 12,
                          color: Colors.grey,
                      ),
                      SizedBox(height: getSize(4)),
                      MyText(title:
                        description,
                          fontSize: 12,
                          color: Colors.grey,
                        line: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                MyText(title:
                "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}$price${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                  fontSize: 14,
                  fontWeight: FontWeight.bold ,
                ),
              ],
            ),
            SizedBox(height: getSize(12)),
            CustomButton(
              onTap: (){
                onReorder!();
              },
              text: "reorder".tr,
            ),
            if (rating != null) SizedBox(height: getSize(8)),
            if (rating != null) Divider(),
            if (rating != null) SizedBox(height: getSize(8)),
            if (rating != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    title:
                    "you_rated".tr,
                   fontSize: 12, color: Colors.grey,
                  ),
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  MyText(title:
                    "$rating",
                    fontSize: 12,
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }
}

