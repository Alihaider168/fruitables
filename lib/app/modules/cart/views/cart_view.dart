import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/data/utils/cart/cart.dart';
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
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Padding(
      padding: getPadding(all: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                title: "lbl_deliver_to".tr,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstant.textGrey,
              ),
              MyText(
                title: Constants.selectedBranch?.address??"",
                fontSize: 16,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    return Padding(
      padding: getPadding(left: 16,right: 16),
      child:ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.menuController.cart.items.length,
        itemBuilder: (context, i) {
          final item = controller.menuController.cart.items[i];
          return _buildCartItem(item: item,index: i);
        },
      ),
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
              url: item.item.image,
              width: getSize(70),
              height: getSize(70),
              fit: BoxFit.cover,
            ),
            SizedBox(width: getSize(10),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title: Utils.checkIfUrduLocale() ? item.item.name ?? "" : item.item.englishName ?? "",
                    color: ColorConstant.black,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.menuController.checkForMultipleValues(item.item) ? MyText(
                            title: "${"lbl_size".tr}: ${item.size}",
                            color: ColorConstant.black,
                            fontSize: 14,
                          ) : Offstage(),
                          MyText(
                            title: "${"lbl_rs".tr} ${controller.menuController.checkPricesForCheckout(item.item, item.size) * item.quantity}",
                            color: ColorConstant.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ))
                    ],
                  ),

                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.menuController.cart.removeItem(index);
                    setState(() {

                    });
                  },
                  icon: Icon(Icons.remove,color: ColorConstant.primaryPink,),
                ),
                MyText(title: item.quantity.toString()), // Quantity
                IconButton(
                  onPressed: () {
                    controller.menuController.cart.addItem(item.item, item.size, 1);
                    setState((){});
                  },
                  icon: Icon(Icons.add,color: ColorConstant.primaryPink,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(title: "${"lbl_use_wallet".tr}: ${"lbl_rs".tr} 0.00"),
              Obx(()=> Switch(
                value: controller.useWallet.value,
                onChanged: (value) {
                  controller.useWallet.value = value;
                },
                activeColor: ColorConstant.primaryPink,
                inactiveTrackColor: ColorConstant.grayBackground,
              ),)
            ],
          ),
          CustomButton(
            text: "lbl_apply_promo".tr,
            prefixWidget: Container(
              padding: getPadding(right: 10),
              child: Icon(Icons.add,color: ColorConstant.white,
              ),
            ),
          ),
          SizedBox(height: getSize(16)),
          _buildSummaryRow("lbl_subtotal".tr, "${"lbl_rs".tr} ${controller.menuController.cart.getTotalDiscountedPrice()}"),
          _buildSummaryRow("lbl_delivery_fee".tr, "${"lbl_rs".tr} ${Constants.DELIVERY_FEES}"),
          _buildSummaryRow("${"lbl_tax".tr} (15.0%)", "${"lbl_rs".tr} ${controller.menuController.cart.getTax()}"),
          Divider(),
          _buildSummaryRow("lbl_grand_total".tr, "${"lbl_rs".tr}  ${controller.menuController.cart.getTotalDiscountedPrice() + controller.menuController.cart.getTax() + Constants.DELIVERY_FEES}", isBold: true),
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
          MyText(title: label, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          MyText(title: amount, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: CustomButton(
        text: "lbl_proceed_to_checkout".tr,
        onTap: (){
          Get.toNamed(Routes.CHECKOUT);
        },
      ),
    );
  }
}