import 'package:fruitables/app/data/widgets/custom_text_form_field.dart';

import '../../../data/core/app_export.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white.withOpacity(.95),
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_checkout".tr,color: ColorConstant.white,fontSize: 22,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),  // Custom border radius
                  ),

                  color: ColorConstant.white,
                  child: Container(
                    width: size.width,
                    padding: getPadding(all: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outlined,color: ColorConstant.primaryPink,),
                            SizedBox(width: getSize(5),),
                            MyText(
                              title: "customer_details".tr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: getSize(15),),
                        MyText(
                          title: "full_name".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: getSize(3),),
                        MyText(
                          title: "Ali Haider",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        SizedBox(height: getSize(10),),
                        MyText(
                          title: "phone_number".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: getSize(3),),
                        MyText(
                          title: "+923164260000",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        SizedBox(height: getSize(10),),
                        MyText(
                          title: "email".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: getSize(3),),
                        MyText(
                          title: "haideralihaider168@gmail.com",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        SizedBox(height: getSize(10),),
                        Constants.isDelivery.value ?
                        CustomTextFormField(
                          controller: controller.addressController,
                          labelText: "delivery_address".tr,
                          readOnly: true,
                          onTap: () async {
                            Get.toNamed(Routes.ADDRESSES,arguments: {Constants.paramCheckout : true})!.then((address){
                              if(address != null){
                                controller.addressController.text = address??"";
                              }
                            });

                          },
                        ) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              title: "pickup_from".tr,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: getSize(3),),
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Utils.checkIfArabicLocale() ? Alignment.centerRight : Alignment.centerLeft,
                                    child: MyText(
                                      title: Constants.selectedBranch?.address??"",
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstant.primaryPink,
                                    ),
                                  ),
                                ),
                                SizedBox(width: getSize(10),),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                   CustomSnackBar.showCustomToast(message: "Will be implemented soon");

                                  },
                                  child: Container(
                                    padding: getPadding(left: 15,right: 15,top: 5,bottom: 5),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.primaryPink,
                                        borderRadius: BorderRadius.circular(getSize(5))
                                    ),
                                    child: MyText(title: "show_on_map".tr,color: ColorConstant.white,fontSize: 12,),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: getSize(10),),
                        Divider(),
                        Obx(()=> controller.instructions.value
                            ?Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.notes,color: ColorConstant.primaryPink,),
                                SizedBox(width: getSize(5),),
                                MyText(
                                  title: "additional_notes".tr,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(height: getSize(10),),
                            CustomTextFormField(
                              controller: controller.instructionsController,
                              maxLines: 4,
                            ),
                          ],
                        )
                            :GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            controller.instructions.value = true;
                          },
                          child: Container(
                            padding: getPadding(top: 10,bottom: 10),
                            child:  MyText(title: "+ ${"add_instructions".tr}",),
                          ),
                        ),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getSize(20),),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),  // Custom border radius
                  ),

                  color: ColorConstant.white,
                  child: Container(
                    width: size.width,
                    padding: getPadding(all: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payment,color: ColorConstant.primaryPink,),
                            SizedBox(width: getSize(5),),
                            MyText(
                              title: "payment_method".tr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: getSize(15),),
                        Row(
                          children: [
                            Icon(Icons.card_giftcard,color: ColorConstant.primaryPink,),
                            SizedBox(width: getSize(10),),
                            Obx(()=> MyText(
                              title: controller.selectedMethod.value.isNotEmpty? controller.selectedMethod.value: "choose_payment_method".tr,
                              fontSize: 16,
                            )),
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                Get.toNamed(Routes.ADD_PAYMENT)!.then((payment){
                                  if(payment!= null){
                                    controller.selectedMethod.value = payment;
                                  }
                                });

                              },
                              child: Container(
                                padding: getPadding(left: 15,right: 15,top: 5,bottom: 5),
                                decoration: BoxDecoration(
                                  color: ColorConstant.primaryPink,
                                  borderRadius: BorderRadius.circular(getSize(5))
                                ),
                                child: MyText(title: "choose".tr,color: ColorConstant.white,),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getSize(20),),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),  // Custom border radius
                  ),

                  color: ColorConstant.white,
                  child: Container(
                    width: size.width,
                    padding: getPadding(all: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timelapse_sharp,color: ColorConstant.primaryPink,),
                            SizedBox(width: getSize(5),),
                            MyText(
                              title: !Constants.isDelivery.value ? "estimated_pickup_time".tr : "estimated_delivery_time".tr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: getSize(15),),
                        Row(
                          children: [
                            Icon(Icons.card_giftcard,color: ColorConstant.primaryPink,),
                            SizedBox(width: getSize(10),),
                            Obx(()=> MyText(
                              title: controller.selectedTime.value.isNotEmpty? controller.selectedTime.value: "asap".tr,
                              fontSize: 16,
                            )),
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                controller.showDeliveryTimePicker(context);

                              },
                              child: Container(
                                padding: getPadding(left: 15,right: 15,top: 5,bottom: 5),
                                decoration: BoxDecoration(
                                  color: ColorConstant.primaryPink,
                                  borderRadius: BorderRadius.circular(getSize(5))
                                ),
                                child: MyText(title: "choose".tr,color: ColorConstant.white,),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getSize(20),),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getSize(8)),  // Custom border radius
                  ),

                  color: ColorConstant.white,
                  child: Container(
                    width: size.width,
                    padding: getPadding(all: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow("lbl_subtotal".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTotalDiscountedPrice()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                        _buildSummaryRow("lbl_discount".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTotalDiscountForCart()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                        Constants.isDelivery.value ? _buildSummaryRow("lbl_delivery_fee".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${Constants.DELIVERY_FEES}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"): Offstage(),
                        _buildSummaryRow("${"lbl_tax".tr} (15.0%)", "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTax()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
                        _buildSummaryRow("lbl_grand_total".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + (Constants.isDelivery.value ? Constants.DELIVERY_FEES : 0)}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}", isBold: true),
                        // _buildSummaryRow("lbl_grand_total".tr, "${"lbl_rs".tr}  ${controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + Constants.DELIVERY_FEES}", isBold: true),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: size.width,
          height: size.height*0.11,
          padding: getPadding(left: 16,right: 16,top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSize(20)),
              topRight: Radius.circular(getSize(20)),
            ),
            boxShadow: [
              // Top shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, -4), // Move shadow upwards
              ),
              // Left shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(-4, 0), // Move shadow to the left
              ),
              // Right shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(4, 0), // Move shadow to the right
              ),
            ],
          ),
          child: Column(
            children: [
              // MyText(title: "Some text here", fontWeight: FontWeight.normal),
              SizedBox(height: getSize(10),),
              CustomButton(
                text: "confirm_order".tr,
                onTap: (){
                  if(controller.addressController.text.isNotEmpty){
                    if(controller.selectedMethod.value.isNotEmpty){
                      Get.toNamed(Routes.ORDER_PLACED);
                    }else{
                      CustomSnackBar.showCustomToast(message: "select_payment_method".tr);
                    }
                  }else{
                    CustomSnackBar.showCustomToast(message: "select_delivery_address".tr);
                  }
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title: label, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
          MyText(title: amount, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 15,),
        ],
      ),
    );
  }
}
