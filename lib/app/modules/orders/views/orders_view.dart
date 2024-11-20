import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
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
        padding: getPadding(top: 12, bottom: 12, right: 8, left: 8),
        itemBuilder: (context, index) {
          final order = controller.myOrders[index];
          String day = DateFormat('dd').format(DateTime.parse(order.createdAt.toString()));
                    String month = DateFormat('MM').format(DateTime.parse(order.createdAt.toString()));
          String year = DateFormat('yyyy').format(DateTime.parse(order.createdAt.toString()));

print(day);

          return OrderCard(order: order, day: day,month: month,year: year,);
        },
      )))
    );
  }
}

class OrderCard extends StatelessWidget {
  final Orders order;
  final String day;
  final String month;
  final String year;

  const OrderCard({super.key, required this.order, required this.day, required this.month, required this.year});

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
        margin: getMargin(bottom: 12),
        child: Padding(
          padding: getPadding(all: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title:
                    "#${order.saleId}",
                    fontSize: 14, fontWeight: FontWeight.bold,
                  ),
                  Row(
                    children: [
                      Utils.checkIfArabicLocale()?
                        MyText(title:
                      "${"$year-$month-$day"}",
                                          fontSize: getSize(12),

                        color: ColorConstant.textGrey,
                      ):
                      MyText(title:
                      "${"$day-$month-$year"}",
                                          fontSize: getSize(12),

                        color: ColorConstant.textGrey,
                      ),
                      MyText(title:
                 " ${ DateFormat("hh:mm a").format(DateTime.parse(order.createdAt??""))} ",
                    color: ColorConstant.textGrey,
                    fontSize: getSize(12),
                  ),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: getSize(8)),
              MyText(title:
                "${(order.status??" ").capitalizeFirst}",
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
              // SizedBox(height: getSize(8)),
              MyText(title:
                "${"instructions".tr}: ${(order.instructions??"").isNotEmpty ? (order.instructions) :("none".tr)}",
                  color:ColorConstant.primaryPink,
                fontSize: 12,
              ),
              // SizedBox(height: getSize(8)),
              MyText(title:
                "${"items".tr}: ${(order.products??[]).length}",
                  color:ColorConstant.primaryPink,
                fontSize: 12,
              ),
              // SizedBox(height: getSize(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title:
                    "lbl_total".tr,
                    fontSize: getFontSize(12),
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
