import 'package:flutter/cupertino.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class CartBottom extends StatelessWidget  {

  final controller = Get.put(MainMenuController());

  CartBottom({super.key,this.showCurrentOrder = false,this.order});

  final bool showCurrentOrder;
  final Orders? order;

  int index = 0;

  @override
  Widget build(BuildContext context) {

    if(order?.status == "pending"){
      index = 0;
    }
    if(order?.status == "preparing"){
      index = 1;
    }
    if(order?.status == "ready"){
      index = 2;
    }
    if(order?.status == "delivered"){
      index = 3;
    }

    return Obx(()=> Container(
      width: size.width,
      height: controller.bottomBar.value && showCurrentOrder ? size.height * 0.19 :size.height*0.12,
      padding: getPadding(left: 16,right: 16,bottom: 15,top: 15),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          showCurrentOrder ?
          GestureDetector(
            onTap: (){
              Get.toNamed(Routes.CURRENT_ORDER_DETAIL,arguments: {"order": order});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderStatusIndicator(currentIndex: index),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: getSize(10)),
                          MyText(
                            title: '${"order_number".tr}${order?.saleId}',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          SizedBox(height: getSize(3)),
                          MyText(
                            title: "${'your_order_being'.tr}${order?.status}",
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    MyText(
                      title: '20 - 35 ${"mins".tr}',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ): Spacer(),
          Spacer(),
          Obx(()=>  controller.bottomBar.value
              ? GestureDetector(
            onTap: ()=> Get.toNamed(Routes.CART),
            child: Container(
              width: size.width,
              // height: getSize(50),
              decoration: BoxDecoration(
                  color: ColorConstant.primaryPink,
                  borderRadius: BorderRadius.circular(getSize(5))
              ),
              padding: getPadding(left: 15,right: 15,top: 10,bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: getPadding(all: 8),
                    margin: Utils.checkIfArabicLocale() ? getMargin(left: 15) : getMargin(right: 10),
                    decoration: BoxDecoration(
                        color: ColorConstant.white,
                        shape: BoxShape.circle
                    ),
                    child: Obx(()=> MyText(
                      title: '${controller.cart.items.value.length}',
                      color: ColorConstant.primaryPink,
                    )),
                  ),
                  MyText(
                    title: "lbl_view_cart".tr,
                    fontSize: 18,
                    color: ColorConstant.white,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(()=> MyText(
                        title:
                        '${Utils.checkIfArabicLocale() ? "":"${'lbl_rs'.tr} "}${controller.cart.getTotalDiscountedPrice().toDouble()}${!Utils.checkIfArabicLocale() ? "":" ${'lbl_rs'.tr} "}',
                        fontSize: 14,
                        color: ColorConstant.white,
                        fontWeight: FontWeight.bold,
                      ),),
                      MyText(
                        title: 'price_exclusive_tax'.tr,
                        fontSize: 12,
                        color: ColorConstant.white,
                        // fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
              : Offstage())
        ],
      ),
    ));
  }

}

class OrderStatusIndicator extends StatefulWidget {
  final int currentIndex;

  const OrderStatusIndicator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _OrderStatusIndicatorState createState() => _OrderStatusIndicatorState();
}

class _OrderStatusIndicatorState extends State<OrderStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Repeats the animation indefinitely

    _animation = Tween<double>(begin: -50, end: 50).animate(_controller); // Move left to right
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          if (index < widget.currentIndex) {
            // Completed stage: pink color
            return _buildStatusContainer(ColorConstant.primaryPink);
          } else if (index == widget.currentIndex) {
            // Current stage: continuously animated pink container
            return _buildAnimatedContainer();
          } else {
            // Future stage: grey color
            return _buildStatusContainer(Colors.grey[300]!);
          }
        }),
      ),
    );
  }

  Widget _buildStatusContainer(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 5,
      width: size.width/8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildAnimatedContainer() {
    return AnimatedBuilder(
      animation: _animation,
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

                left: _animation.value,
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
    );
  }
}