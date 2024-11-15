import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/noData.dart';
import 'package:intl/intl.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_my_orders".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body:controller.orders.isEmpty? Container(height: Get.height,width: Get.width,
      child: Center(child: NoData(
        svgPath: 'assets/images/emptyCart.svg',
        name: "no_order_found".tr,
        message: "no_order_found_desc".tr,
      ))): ListView.builder(
        itemCount: controller.orders.length,
        padding: getPadding(all: 16),
        itemBuilder: (context, index) {
          final order = controller.orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ORDER_DETAIL,arguments: {'status': order.status});
      },
      child: Card(
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
                    "${"order".tr} #${order.id}",
                    fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                  MyText(title:
                    DateFormat('MMM d, yyyy').format(order.date),
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: getSize(8)),
              MyText(title:
                "${"status".tr}: ${order.status}",
                  color: order.status == "delivered".tr
                      ? Colors.green
                      : order.status == "cancelled".tr
                      ? Colors.red
                      : Colors.orange,
                  fontWeight: FontWeight.bold,
              ),
              SizedBox(height: getSize(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title:
                    "lbl_total".tr,
                    color: Colors.grey,
                  ),
                  MyText(title:
                    "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${order.total.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                    fontSize: 16, fontWeight: FontWeight.bold,
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

// Order Model
class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
  });
}

