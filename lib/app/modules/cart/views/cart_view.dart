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
              Text("Use Wallet: Rs. 0.00"),
              Switch(value: false, onChanged: (value) {}),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text("Apply Promo"),
            style: ElevatedButton.styleFrom(
              // primary: Colors.pinkAccent,
              // onPrimary: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildSummaryRow("Subtotal", "Rs. 18,754.00"),
          _buildSummaryRow("Delivery Fee", "Rs. 200.00"),
          _buildSummaryRow("TAX (15.0%)", "Rs. 2,867.54"),
          Divider(),
          _buildSummaryRow("Grand Total", "Rs. 21,821.55", isBold: true),
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
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(amount, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Rs. 21,821.55", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text("Proceed to Checkout"),
            style: ElevatedButton.styleFrom(
              // primary: Colors.pink,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}