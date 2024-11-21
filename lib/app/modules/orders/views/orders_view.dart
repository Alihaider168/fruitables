import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/widgets/noData.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        body: Obx(
          ()=> Skeletonizer(
            enabled: controller.isLoading.value,
            child: !controller.isLoading.value && controller.myOrders.isEmpty ?
            Container(
              height: Get.height,width: Get.width,
              child: Center(child: NoData(
                svgPath: 'assets/images/emptyCart.svg',
                name: "no_order_found".tr,
                message: "no_order_found_desc".tr,
              )),
            ): 
            Obx(()=>controller.isLoading.value?ListView.builder(
            itemCount: 3,
            padding: getPadding(all: 16),
            itemBuilder: (context, index) {
              print("calling");
              return PastOrderTile(
                imageUrl: "",
                title: "Test Branch",
                deliveryDate: DateTime.now().toString(),
                description: "testing description this is testing abcdef ghijkl sjb sncjhab",
                price: "00000",
                completedAt: DateTime.now().toString(),
                rating: 3,
                onReorder: (){
                  
                },
              );
            },
                  ) :ListView.builder(
            itemCount: controller.myOrders.length,
            padding: getPadding(all: 16),
            itemBuilder: (context, index) {
              final order = controller.myOrders[index];
              // return OrderCard(order: order);
              return GestureDetector(
                onTap: (){
                  controller.myOrders[index].branch;
                  // Get.toNamed(Routes.NEW_DETAIL,arguments: {'order': order});
                },
                child: PastOrderTile(
                  imageUrl: order.branch?.image?.key??"",
                  title: order.branch?.name??"",
                  deliveryDate: order.deliveredAt,
                  description:Utils.checkIfArabicLocale()?(order.products??[]).map((element)=> element.arabicName.toString()).join(", "): (order.products??[]).map((element)=> element.name.toString()).join(", "),
                  price: "${order.totalAmount??0}",
                  completedAt: order.completedAt,
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
                  )),
          ),
        )
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
          Get.toNamed(Routes.NEW_DETAIL,arguments: {'order': order});

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
  final String? deliveryDate;
  final String description;
  final String price;
  final double? rating;
  final String? completedAt;
  final void Function()? onReorder;


  PastOrderTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.deliveryDate,
    required this.description,
    required this.price,
    this.rating,
    this.completedAt,
    required this.onReorder,
  });

  final OrdersController controller = Get.put(OrdersController());
 

  @override
  Widget build(BuildContext context) {
      Locale? currentLocale = Get.locale;
      String month ='';
   String date='';
      String time='';

if(deliveryDate != null){
 DateTime stringDate =DateTime.parse(deliveryDate!);
 date =DateFormat('dd').format(stringDate);
 month = DateFormat('MMM').format(stringDate);
 time = DateFormat('HH:mm').format(stringDate);
 print(time);


}
    return Container(
      margin: getMargin(top: 8, bottom: 8),
      child: Column(
        children: [
          Container(
                  padding:getPadding(all: 14),

            decoration: BoxDecoration(
                    color: Colors.white,

              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              border: Border.all(color: Colors.grey.shade300, width: 1.5)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      url: Utils.getCompleteUrl(imageUrl),
                      height: getSize(75),
                      width: getSize(80),
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
                                                if(completedAt != null && deliveryDate != null)
                          SizedBox(height: getSize(4)),
                
                          if(completedAt != null && deliveryDate != null)
                           MyText(title:
                            "${"delivered_on".tr} $date $month $time",
                              fontSize: 12,
                              color: Colors.grey.shade700.withOpacity(0.8),
                          ),
                        
                          SizedBox(height: getSize(4)),
                          MyText(title:
                            description,
                              fontSize: 12,
                              color: Colors.grey.shade700.withOpacity(.8),
                            line: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        MyText(title:
                        "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}$price${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                          fontSize: 14,
                          fontWeight: FontWeight.bold ,
                          
                        ),
                
                          SizedBox(height: getSize(6)),
                          if(completedAt == null && deliveryDate == null)
                          AnimatedBuilder(
                            animation: controller.animation,
                            builder: (context, child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                
                                      width: size.width/7,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    Positioned(
                
                                      left: controller.animation.value,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                
                                        width: 50,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [ColorConstant.primaryPink1.withOpacity(.7), ColorConstant.primaryPink1.withOpacity(.8), ColorConstant.primaryPink1],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                         
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getSize(12)),
                InkWell(
                  onTap: (){
                    onReorder!();
                
                  },
                  child: Obx(
                    ()=> Container(
                      height: getSize(32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:controller.isLoading.value ?Colors.grey.shade300: ColorConstant.black,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      alignment: Alignment.center,
                    child: Text("reorder".tr,style: TextStyle(color: Colors.white, fontSize: getFontSize(14), fontWeight: FontWeight.bold), ),
                    ),
                  ),
                ),
              
               
                
              ],
              
            ),
          ),
           Container(

            padding: getPadding(top: 13, bottom: 13),
            decoration: BoxDecoration(
                                color: Colors.white,

                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),right: BorderSide(color: Colors.grey.shade300, width: 1.5),left: BorderSide(color: Colors.grey.shade300, width: 2))
            ),
          
            child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    
                    title:
                    "you_rated".tr,
                    fontWeight: FontWeight.w700,
                   fontSize: 11,                            color: Colors.grey.shade700.withOpacity(0.8)
            
            ,
            
                  ),
                  Padding(
                    padding: getPadding(right: 0, left: 3),
                    child: const Icon(Icons.star, color: Colors.orange, size: 16),
                  ),
                  MyText(title:
                    " $rating ",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
           )
        ],
      ),
    );
  }
}

