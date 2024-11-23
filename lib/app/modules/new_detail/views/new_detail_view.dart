import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/modules/reviews/views/reviews.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/new_detail_controller.dart';



class NewDetailView extends GetView<NewDetailController> {
  const NewDetailView({super.key});



  @override
  Widget build(BuildContext context) {
    RxBool loading = true.obs;
   
  Future.delayed(Duration(seconds: 3

  ),(){
    loading.value = false;
    
  });
      Locale? currentLocale = Get.locale;


          final NewDetailController controller = Get.put(NewDetailController());
            String timeD =controller.order!.deliveredAt != null? DateFormat('HH:mm a').format(DateTime.parse(controller.order!.deliveredAt.toString())):'';
          String yearD= controller.order!.deliveredAt != null?DateFormat('yyyy').format(DateTime.parse(controller.order!.deliveredAt.toString())):'';
          String monthD=controller.order!.deliveredAt != null?DateFormat('MMM').format(DateTime.parse(controller.order!.deliveredAt.toString())):"";
          String dayD= controller.order!.deliveredAt != null?DateFormat('dd').format(DateTime.parse(controller.order!.deliveredAt.toString())):'';
          String timeC = DateFormat('HH:mm a').format(DateTime.parse(controller.order!.createdAt.toString()));
          String yearC=DateFormat('yyyy').format(DateTime.parse(controller.order!.createdAt.toString()));
          String monthC=DateFormat('MMM').format(DateTime.parse(controller.order!.createdAt.toString()));
          String dayC=DateFormat('dd').format(DateTime.parse(controller.order!.createdAt.toString()));




    return WillPopScope(
      onWillPop: () async {
        if(controller.fromOrder){
          Get.offAllNamed(Routes.MAIN_MENU);
        }else{
          Get.back();
        }
        Get.delete<NewDetailController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Image
                      Obx(
                        ()=> Skeletonizer(
                          enabled: loading.value,
                          child: Container(
                            height: getSize(200),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                NetworkImage(Utils.getCompleteUrl(controller.order?.branch?.image?.key),


                                ), // Replace with your image
                                fit: BoxFit.cover,
                              ),
                              color: Colors.grey.shade200
                            ),
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: getPadding(left: 16,top: 10, right: 16,),
                                  child: GestureDetector(
                                    onTap: (){
                                      if(controller.fromOrder){
                                        Get.offAllNamed(Routes.MAIN_MENU);
                                      }else{
                                        Get.back();
                                      }
                                        Get.delete<NewDetailController>();
                                    },
                                    child: CircleAvatar(
                                      radius: getSize(17),
                                      backgroundColor: ColorConstant.white,
                                      child: Icon(Icons.arrow_back),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                 showSupportCenterBottomSheet(context);

                                  },
                                  child: Container(
                                    margin: getMargin(right: 16,top: 10, left: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: ColorConstant.textGrey),
                                      borderRadius: BorderRadius.circular(getSize(10))
                                    ),
                                    padding: getPadding(top: 4,bottom: 4,left: 8,right: 8),
                                    child: MyText(title: "help".tr, fontSize: getFontSize(12),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [

                          // Order Information
                          Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                        padding: getPadding(left: 16,right: 16,top: 16,bottom: 20),
                              child: Column(
                                children: [
                                  MyText(
                                    title: "${"order_number".tr}${controller.order?.saleId}",
                                    fontWeight: FontWeight.bold, fontSize: 16,
                                  ),
                                   SizedBox(height: getSize(10)),
                              !((controller.order?.status == "delivered" )) ?
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                        MyText(
                                title: "${'your_order_being'.tr}${controller.order?.status == 'pending'?'pending'.tr : controller.order?.status == 'preparing'?'preparing'.tr:'ready'.tr}",
                                color: ColorConstant.textGrey,
                                fontSize: 12,
                              ),
                                                                    SizedBox(height: getSize(5),),

                                   AnimatedBuilder(
                                          animation: controller.animation,
                                          builder: (context, child) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5),

                                                    width: getSize(110),
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
                                                      width: getSize(80),
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
                                        ),

                                 ],
                               ):
                               InkWell(
                                onTap: ()async{
                                   if(controller.order?.reviews?['rating'] == null){
                                                        Get.to(()=>ReviewsScreen(order: controller.order!));

                                   }
                                },
                                 child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     MyText(
                                                       title:
                                                     controller.order?.reviews?['rating'] == null?  "add_review".tr:"you_rated".tr,
                                                       fontWeight: FontWeight.w700,
                                                      fontSize: 11,
                                                       color:controller.order?.reviews?['rating'] == null ?ColorConstant.blue :Colors.grey.shade700.withOpacity(0.8),

                                                     ),
                                                       if( controller.order?.reviews?['rating'] != null)
                                                     Padding(
                                                       padding: getPadding(right: 2, left: 2),
                                                       child: const Icon(Icons.star, color: Colors.orange, size: 16),
                                                     ),
                                                     if( controller.order?.reviews?['rating'] != null)
                                                     MyText(title:

                                                      "${controller.order?.reviews?['rating']}" ,
                                                       fontSize: 12,
                                                       fontWeight: FontWeight.w700,
                                                     ),
                                                   ],
                                                 ),
                               ),


                              // MyText(
                              //   title: controller.order?.type == "delivery" && controller.order?.deliveredAt != null? "${"delivered_on".tr} ${Utils.formatTimestamp(controller.order?.completedAt)}" : controller.order?.type != "delivery" && controller.order?.completedAt != null ?"${"picked_on".tr} ${Utils.formatTimestamp(controller.order?.completedAt)}":"",
                              //   color: ColorConstant.textGrey,
                              //   fontSize: 13,
                              // ),
                              SizedBox(height: getSize(25),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Column(
                                     children: [
                                       Icon(Icons.store, color: Colors.black),
                                         DottedLine(
                                                direction: Axis.vertical,
                                                lineLength: getSize(40),
                                                lineThickness: 2,
                                                dashLength: 5,
                                                dashColor: Colors.grey,
                                              ),
                                                                               Icon(Icons.watch_later_outlined, color: Colors.black),

                                                                       if(controller.order?.status == "delivered" )

                                         DottedLine(
                                                direction: Axis.vertical,
                                                lineLength: getSize(40),
                                                lineThickness: 2,
                                                dashLength: 5,
                                                dashColor: Colors.grey,
                                              ),
                                                                              if(controller.order?.status == "delivered" )

                                        Icon(Icons.delivery_dining, color: Colors.black),

                                     ],
                                   ),
                                                            SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [ MyText(
                                        title:"lbl_order_from".tr,
                                        fontSize: 11, color: Colors.grey.shade600.withOpacity(0.9),
                                      ),
                                      MyText(
                                    title: Utils.checkIfArabicLocale() ? controller.order?.branch?.name??"" : controller.order?.branch?.englishName??"",
                                     fontSize: 12,
                                     fontWeight: FontWeight.w600,
                                  ),],),
                                                                  SizedBox(height: getSize(19),),

                                       Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [ MyText(
                                        title:"created_at".tr,
                                        fontSize: 11, color: Colors.grey.shade600.withOpacity(0.9),
                                      ),
                                      MyText(
                                        title:Utils.checkIfArabicLocale()?"$timeC" "$yearC $dayC $monthC":"$dayC $monthC $yearC $timeC"
                                      ,
                                      alignRight: Utils.checkIfArabicLocale(),                                                                            fontSize: 12,
                                                                           fontWeight: FontWeight.w600,
                                                                        ),],),
                                  if(controller.order?.status == "delivered" )
                                SizedBox(height: getSize(19),),
                                                                if(controller.order?.status == "delivered" )

                                    Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,


                                      children: [ MyText(
                                        title:"delivered_on".tr,
                                        fontSize: 11, color: Colors.grey.shade600.withOpacity(0.9),
                                      ),
                                      MyText(
                                        title:Utils.checkIfArabicLocale()?"$timeD" "$yearD $dayD $monthD":"$dayD $monthD $yearD $timeD"
              ,                                     fontSize: 12,
                                     fontWeight: FontWeight.w600,
                                  ),],)

                                    ],
                                  ),
                                ],

                                                            ),
                                ],
                              ),
                            ),
                          ),





                          // Delivery Information
                        SizedBox(height: getSize(18)),
                          ListView.builder(
                            padding: getPadding(right: 16, left: 16),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (controller.order?.products??[]).length,
                            itemBuilder: (_,index){
                              final product = (controller.order?.products??[])[index];
                              return Row(
                                children: [
                                  // MyText(
                                  //   title:  Utils.checkIfArabicLocale()?"x${(product.quantity??0)}":"${(product.quantity??0)}x",
                                  //   fontWeight: FontWeight.bold,
                                  //   alignRight: Utils.checkIfArabicLocale(),
                                  //   fontSize: 14,
                                  // ),
                                  // SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text(
                                         "${Utils.checkIfArabicLocale()?"x${(product.quantity??0)}":"${(product.quantity??0)}x"} ${Utils.checkIfArabicLocale() ? product.arabicName :product.name}",

                                        style: TextStyle(
                                          fontSize: getFontSize(14),


                                        fontWeight: FontWeight.w600,
                                        ),

                                      ),
                                      if(product.size != null && product.size !='')
                                      Text(
                                         "${"lbl_size".tr} : ${product.size =='large'?"lbl_large".tr:product.size =='medium'?"lbl_medium".tr:"lbl_small".tr}",
                                    style: TextStyle(
                                          fontSize: 14,
                                        color: ColorConstant.textGrey,

                                        fontWeight: FontWeight.w400,
                                    ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  MyText(
                                    title: '${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(product.price??0) * (product.quantity??0)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}',
                                    fontSize: 14,
                                  ),
                                ],
                              );
                            },
                          ),
                          // Item List



                          // Pricing Details
                          Padding(
                                   padding: getPadding(left: 16,right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  SizedBox(height: 10 ),
                          Divider(color: Colors.grey.shade300),
                                _buildTotalRow("lbl_subtotal".tr, (controller.order?.totalAmount??0)-(controller.order?.tax??0) - (controller.order?.discount??0) -((controller.order?.type??"") == "delivery" ? Constants.DELIVERY_FEES : 0)),
                                _buildTotalRow("lbl_discount".tr, (controller.order?.discount??0).toDouble(), isDiscount: true),
                                (controller.order?.type??"") == "delivery" ? _buildTotalRow("lbl_delivery_fee".tr, Constants.DELIVERY_FEES) : Offstage(),
                                _buildTotalRow("${"lbl_tax".tr} (15.0%)",controller.order?.tax??0),

                                SizedBox(height: getSize(12)),
                                _buildTotalRow("lbl_total".tr,controller.order?.totalAmount??0,isBold: true, color: Colors.black, fontSize: 15),
                                            Divider(color: Colors.grey.shade300,height: 30,),

                              ],
                            ),
                          ),


                          // Payment Method
                          // ignore: avoid_unnecessary_containers
                          Container(
                            alignment: Utils.checkIfArabicLocale()?Alignment.centerRight:Alignment.centerLeft,
                              padding: getPadding(right: 16, left: 16),
                              child: MyText(
                                title: "paid_with".tr,
                                color: ColorConstant.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),

                          ),
                          SizedBox(height: getSize(8)),
                          Padding(
                            padding: getPadding(right: 16, left: 16),
                            child: Column(
                              children: [
                                if(controller.order?.payableAmount != 0)
                                Padding(
                                      padding:getPadding(top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        controller.order?.paymentMethod == 'cod'?
                                        Icons.delivery_dining:Icons.credit_card, color: ColorConstant.textGrey),
                                      SizedBox(width: getSize(8)),
                                      MyText(
                                        title: controller.order?.paymentMethod == 'cod'?  "cash_on_delivery".tr :
                                          "credit_debit_card".tr,
                                        fontSize: 14,
                                      ),
                                      Spacer(),
                                      MyText(title:
                                      "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${(controller.order?.payableAmount??0).toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),

                                 (  (controller.order?.usedWalletBallance ??"")!= "" && controller.order?.usedWalletBallance != 0 )?
                                    Padding(

                                      padding:getPadding(top: 8, bottom: 8),
                                      child: Row(
                                                                        children: [
                                      Icon(Icons.account_balance_wallet, color: ColorConstant.textGrey),
                                      SizedBox(width: getSize(8)),
                                      MyText(
                                        title:
                                          "from_wallet".tr,
                                       fontSize: 14,
                                      ),
                                      Spacer(),
                                      MyText(title:"${(controller.order?.usedWalletBallance??0).toStringAsFixed(2)}",
                                        fontSize: 14,

                                      ),
                                                                        ],
                                                                      ),
                                    ) : Offstage(),
                                ((controller.order?.usedPointsBalance ??"")!= "" && controller.order?.usedPointsBalance != 0)?

                                      Padding(
                                      padding:getPadding(top: 8, bottom: 8),
                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.loyalty, color: ColorConstant.textGrey),
                                                                            SizedBox(width: getSize(8)),
                                                                            MyText(
                                        title:
                                          "from_points".tr,
                                                                       fontSize: 14,
                                                                            ),
                                                                            Spacer(),
                                                                            MyText(title:"${(controller.order?.usedPointsBalance??0).toStringAsFixed(2)}",
                                        fontSize: 14,

                                                                            ),
                                                                          ],
                                                                        ),
                                      )
                                 : Offstage(),


                                SizedBox(height: getSize(10)),
                                Divider(color: Colors.grey.shade300),
                                  ],
                            ),
                          ),
                          SizedBox(height: getSize(20)),

                        ],
                      ),


                    ],
                  ),
                ),
              ),
                Padding(
                  padding: getPadding(right: 12, left: 12, bottom: 12, top: 12),
                  child: CustomButton(
                        text: "reorder".tr,
                        onTap: (){
                          for(int i=0;i<(controller.order?.products??[]).length;i++){
                            final item = (controller.order?.products??[])[i];

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
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, num amount,
      {bool isDiscount= false,bool isBold = false, double fontSize = 13,Color color =const Color.fromARGB(255, 114, 114, 114)})
  {
    return Padding(
      padding: getPadding(top: 4,bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title:
          label,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
             color: color,
          ),
          Container(
            padding: getPadding(top: 2, bottom: 2, left: 4, right: 4),
                  decoration:isDiscount? BoxDecoration(borderRadius: BorderRadius.circular(8),color:  Color(0xFF3BB925).withOpacity(0.2)):null,

            child: MyText(title:
            "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${amount.toStringAsFixed(2)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
              fontSize: fontSize,
              fontWeight:isDiscount?FontWeight.w600: isBold ? FontWeight.bold : FontWeight.normal,
              color:isDiscount?Color(0xFF3BB925): color,
            ),
          ),
        ],
      ),
    );
  }
  
}
  void showSupportCenterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstant.white,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                 ImageConstant.mail,
                height: getSize(150),
              ),
              SizedBox(height: getSize(15)),
              MyText(
                title: "lbl_support_center".tr,
                  fontWeight: FontWeight.bold,
                  fontSize: Utils.checkIfArabicLocale()?16:18,
              ),
              SizedBox(height: getSize(10)),
              MyText(
                title:'lbl_for_queries'.tr,
                  color: ColorConstant.textGrey,
                  alignRight: Utils.checkIfArabicLocale(),
                  fontSize: Utils.checkIfArabicLocale()?12:14,
                center: true,
              ),
              SizedBox(height: getSize(20)),
              CustomButton(
                text: "customercare@rexsa.com",
                prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: Colors.white)),
                onTap: (){
                  final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'customercare@rexsa.com',
                      queryParameters: {
                        'subject': 'Support Request'
                      }
                  );
                  Utils.launchURL(emailUri);
                },
              ),
              SizedBox(height: getSize(10)),
              CustomButton(
                text: "021111636363",
                prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.call, color: Colors.black)),
                variant: ButtonVariant.OutlineGrey,
                fontStyle: ButtonFontStyle.Grey18,
                onTap: (){
                  Utils.launchURL(Uri.parse("tel: 021111636363"));
                },
              ),
            ],
          ),
        );
      },
    );
  }
