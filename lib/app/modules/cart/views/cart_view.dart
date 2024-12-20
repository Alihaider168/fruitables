import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/utils/cart/cart.dart';
import 'package:rexsa_cafe/app/modules/vouchers/view/vouchers.dart';

import '../controllers/cart_controller.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController controller = Get.put(CartController());
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
        title: MyText(title: "lbl_cart".tr,color: ColorConstant.white,fontSize: 22,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDeliveryInfo(),
            _buildCartItemsList(),
            _buildSummarySection(),
          ],
        ),
      ),
        bottomNavigationBar: Container(
          width: size.width,
          height: size.height*0.12,
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
              _buildSummaryRow("lbl_total".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${
                  controller.useWallet.value && controller.usePoints.value
                      ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()+controller.getWalletAmount()))
                      :controller.usePoints.value
                      ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()))
                      :controller.useWallet.value
                      ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getWalletAmount()))
                      : getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()))}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}", isBold: true),
              CustomButton(
                text: "lbl_proceed_to_checkout".tr,
                onTap: (){
                  Get.toNamed(Routes.CHECKOUT,arguments: {
                    "usedPointsBalance" : controller.usePoints.value ? controller.usedPointsBalance : null,
                    "usedWalletBalance" : controller.useWallet.value ? controller.usedWalletBalance : null,
                    "voucher":controller.menuController.selectedVoucher.value

                  });
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      color: ColorConstant.grayBackground.withOpacity(.5),
      margin: getMargin(bottom: 10),
      padding: getPadding(left: 16,right: 16,top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                title: !Constants.isDelivery.value ? "pickup_from".tr :"lbl_deliver_to".tr,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorConstant.textGrey,
              ),
              MyText(
                title: Constants.selectedBranch?.address??"",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.LOCATION_SELECTION);
            },
            child: MyText(title: "lbl_change".tr,
              color: ColorConstant.primaryPink,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: getMargin(left: Utils.checkIfArabicLocale() ? null :16,bottom: 5,right: Utils.checkIfArabicLocale()? 16 : null),
          child: MyText(title: "items".tr,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.menuController.cart.items.length,
          itemBuilder: (context, i) {
            final item = controller.menuController.cart.items[i];
            return _buildCartItem(item: item,index: i);
          },
        ),
      ],
    );


  }

  Widget _buildCartItem({required CartItem item,required int index}) {
    return Container(
      margin: getMargin(bottom: 16),
      child: Padding(
        padding: getPadding(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: [
            CustomImageView(
              url: Utils.getCompleteUrl(item.item.image?.key),
              width: getSize(70),
              height: getSize(70),
              fit: BoxFit.contain,
            ),
            SizedBox(width: getSize(10),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Utils.checkIfArabicLocale() ? Alignment.centerRight: Alignment.centerLeft,
                          child: MyText(
                            title: (Utils.checkIfArabicLocale() ? item.item.name ?? "" : item.item.englishName ?? ""),
                            color: ColorConstant.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(width: getSize(10),),
                      MyText(
                        title: "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.checkPricesForCheckout(item.item, item.size) * item.quantity}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}",
                        color: ColorConstant.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: controller.menuController.checkForMultipleValues(item.item) ? Align(
                          alignment: Utils.checkIfArabicLocale() ? Alignment.centerRight: Alignment.centerLeft,
                          child: MyText(
                            title: "${"lbl_size".tr}: ${item.size}",
                            color: ColorConstant.black,
                            fontSize: 12,
                          ),
                        ) : Offstage(),
                      ),
                      SizedBox(width: getSize(10),),
                      Container(
                        padding: getPadding(left: 5,right: 5),
                        margin: getMargin(top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getSize(5)),
                            border: Border.all(color: ColorConstant.grayBorder.withOpacity(.7))
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.menuController.cart.removeItem(index);
                                controller.menuController.loadCart();
                                setState(() {

                                });
                              },
                              child: Icon(Icons.remove,color: ColorConstant.primaryPink,size: getSize(20),),
                            ),
                            Container(
                              padding: getPadding(left: 5,right: 5),
                              child: MyText(
                                title: item.quantity.toString(),
                              ),
                            ), // Quantity
                            GestureDetector(
                              onTap: () {
                                controller.menuController.cart.addItem(item.item, item.size, 1);
                                controller.menuController.loadCart();
                                setState((){});
                              },
                              child: Icon(Icons.add,color: ColorConstant.primaryPink,size: getSize(20),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      margin: getMargin(all: 16),
      padding: getPadding(all: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.grayBorder.withOpacity(.5),width: 0.5),
        borderRadius: BorderRadius.circular(getSize(5)),
        color: ColorConstant.opacBlackColor.withOpacity(.05)
      ),
      child: Column(
        children: [
          !Constants.isLoggedIn.value ? Offstage() :Constants.userModel!.customer!.balance! <= 0?SizedBox(): Container(
            height: getSize(25),
            child:
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(title: "${"lbl_use_wallet".tr}: ${"lbl_rs".tr} ${(Constants.userModel?.customer?.balance??0.00).toStringAsFixed(2)}",fontSize:Utils.checkIfArabicLocale()?12: 12,),
                Obx(()=> Transform.scale(
                    scale: 0.7,
                  child: Switch(
                    value: controller.useWallet.value,
                    onChanged: (value) {
                      if((Constants.userModel?.customer?.balance??0) <= 0){
                        controller.useWallet.value = false;
                      }else{
                        controller.useWallet.value = value;
                      }
                    },
                    activeColor: ColorConstant.primaryPink,
                    inactiveTrackColor: ColorConstant.grayBackground,
                  ),
                ),)
              ],
            ),
          ),
          !Constants.isLoggedIn.value ? Offstage() : SizedBox(height: getSize(5),),
          !Constants.isLoggedIn.value ? Offstage() :Constants.userModel!.customer!.points! <= 0?SizedBox(): Container(
            height: getSize(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(title: "${"lbl_use_points".tr}: ${"lbl_rs".tr} ${(Constants.userModel?.customer?.points??0.00).toStringAsFixed(2)}",fontSize: Utils.checkIfArabicLocale()?12: 12,),
                Obx(() => Transform.scale(
                  scale: 0.7, 
                  child: Switch(
                    value: controller.usePoints.value,
                    onChanged: (value) {
            if ((Constants.userModel?.customer?.points ?? 0) <= 0) {
              controller.usePoints.value = false;
            } else {
              controller.usePoints.value = value;
            }
                    },
                    activeColor: ColorConstant.primaryPink,
                    inactiveTrackColor: ColorConstant.grayBackground,
                  ),
                )),
            
              ],
            ),
          ),
          Obx(()=>controller.menuController.selectedVoucher.value !=null?
          Padding(
            padding: getPadding(top:8.0,bottom: 8),
            child: showVoucherCard(controller.menuController.selectedVoucher.value!,         controller.useWallet.value && controller.usePoints.value? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()+controller.getWalletAmount()))
                  :controller.usePoints.value
                  ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()))
                  :controller.useWallet.value
                  ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getWalletAmount()))
                  :
              getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax())), (){
                setState(() {
                  print("heheeheh");
                });
              }),
          ):
          
          InkWell(
            onTap: (){
              if(Constants.isLoggedIn.value ){
                controller.showVouchersSheet(context);
              }else{
                controller.menuController.showLoginSheet(context);
              }


            },
            child: Container(
              decoration: BoxDecoration(color:Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
              height: getSize(40),
                          margin: getMargin(top: 22, bottom: 12),
            
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CircleAvatar(
                  radius: getSize(12),
                  backgroundColor: Colors.black,
                                 child: Icon(Icons.add,color: ColorConstant.white,size: 20,)
            
                ),
                SizedBox(width: getSize(10)),
                Obx(()=> MyText(title: Constants.isLoggedIn.value ? "lbl_apply_promo".tr : "login_to_apply_promo".tr,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,))
              ],),
            ),
          ),),
          // CustomButton(
          //   margin: getMargin(top: 10),
          //   text: Constants.isLoggedIn.value ? "lbl_apply_promo".tr : "login_to_apply_promo".tr,
          //   prefixWidget: Container(
          //     padding: getPadding(right: 10),
          //     child: Icon(Icons.add,color: ColorConstant.white,
          //     ),
          //   ),
          //   onTap: (){
          //     if(!Constants.isLoggedIn.value){
          //       controller.menuController.showLoginSheet(context);
          //     }
          //   },
          // ),
          Divider(),
          SizedBox(height: getSize(0)),
          _buildSummaryRow("lbl_subtotal".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTotalDiscountedPrice()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
          _buildSummaryRow("lbl_discount".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTotalDiscountForCart()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
          // Constants.isDelivery.value ? _buildSummaryRow("lbl_delivery_fee".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${Constants.DELIVERY_FEES}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}") : Offstage(),
          _buildSummaryRow("${"lbl_tax".tr} (15.0%)", "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTax()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
          Obx(()=> controller.useWallet.value ? _buildSummaryRow("from_wallet".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}-${controller.getWalletAmount()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}") : Offstage()),
          Obx(()=> controller.usePoints.value ? _buildSummaryRow("from_points".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}-${controller.getPointsAmount()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}") : Offstage()),
          // Utils.checkForWalletAndPoints(
          //     controller.usePoints.value,
          //     controller.useWallet.value,
          //     controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + (Constants.isDelivery.value ?Constants.DELIVERY_FEES : 0)
          // ) ? Offstage() :
          // _buildSummaryRow("${"lbl_tax".tr}", "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.menuController.cart.getTax()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}"),
          Divider(),
          Obx(()=> _buildSummaryRow(controller.useWallet.value || controller.usePoints.value ? "payable_amount".tr:"lbl_grand_total".tr, "${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${
              controller.useWallet.value && controller.usePoints.value
                  ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()+controller.getWalletAmount()))
                  :controller.usePoints.value
                  ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getPointsAmount()))
                  :controller.useWallet.value
                  ? getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()) - (controller.getWalletAmount()))
                  :
              getFinalPriceWithVoucher(Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax()))}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}", isBold: true)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title: label, fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize:Utils.checkIfArabicLocale()?12 :12,),
          MyText(title: Utils.formatNumberWithText(amount), fontWeight: isBold ? FontWeight.bold : FontWeight.normal,fontSize: 12,),
        ],
      ),
    );
  }


  // num getWalletAmount(){
  //   return (Constants.userModel?.customer?.balance??0) < Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax())
  //       ? (Constants.userModel?.customer?.balance??0)
  //       : Utils.getNewCheckoutPrice(controller.menuController.cart.getTotalDiscountedPrice(), controller.menuController.cart.getTax());
  // }

  num getFinalPriceWithVoucher(num amt){
    if(controller.menuController.selectedVoucher.value != null){
      if(controller.menuController.selectedVoucher.value!.type != 'percentage'){
        return amt -(controller.menuController.selectedVoucher.value!.discount??0);
      }else{
        return amt - (amt*(controller.menuController.selectedVoucher.value!.discount??0)/100);
      }

    }else{
      return amt;
    }
  }



}