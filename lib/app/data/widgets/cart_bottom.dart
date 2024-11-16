import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class CartBottom extends StatelessWidget  {

  final controller = Get.put(MainMenuController());

  CartBottom({super.key,this.showCurrentOrder = false,this.order,required this.ordersLength});

  final bool showCurrentOrder;
  final Orders? order;
  final int ordersLength;

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
      height: controller.bottomBar.value && showCurrentOrder ? size.height * 0.21 :size.height*0.13,
      padding: getPadding(left: 16,right: 16,bottom: 10,top: 15),
      alignment: Alignment.center,
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          showCurrentOrder ?
          Column(
                    mainAxisAlignment: MainAxisAlignment.center,

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: getSize(8)),
          
                      Container(
                        width: getSize(13),
                        height: getSize(13),
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryPink1,
          
                            borderRadius:BorderRadius.circular(12)
                        ),
                      ),
                      SizedBox(width: getSize(14)),
          
                      InkWell(
                        onTap: (){
                                        Get.toNamed(Routes.CURRENT_ORDER_DETAIL,arguments: {"order": order});
                      
                        },
                        child: MyText(
                          title: "${order?.saleId}",
                          fontWeight: FontWeight.w600,
                          fontSize: getFontSize(16),
                        ),
                      ),
                    ],
                  ),
                    if(ordersLength >0)
                            InkWell(
                              onTap: (){
                                              Get.toNamed(Routes.ORDERS);

                              },
                              child: MyText(
                                                      title: " +$ordersLength",
                                                      fontWeight: FontWeight.w600,
                                                      color: ColorConstant.blue,
                                                      fontSize: getFontSize(16),
                                                    ),
                            ),
                            if(ordersLength <=0)
                  
                  Icon(Icons.keyboard_arrow_down, size: getSize(25),color: ColorConstant.black,)
                ],
              ),
              SizedBox(height: getSize(6)),
              Row(
                children: [
                  OrderStatusIndicator(currentIndex: index),
                ],
              ),
              SizedBox(height: getSize(9)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${  index == 0? 'pending'.tr:  index ==1?"preparing".tr:'ready'.tr}\n${'your_order_being'.tr}${order?.status}',
                      style: TextStyle( color: Colors.grey[700],
                        height: 1.2,
                        fontSize: 14,),
          
                      softWrap: true,
          
                    ),
                  ),
                  MyText(
                    title: 'view_details'.tr,
                    fontWeight: FontWeight.w600,
          
                    fontSize: 13,
                  ),
                ],
              ),
                              SizedBox(height: getSize(5)),
          
            ],
          ): Spacer(),
          // Spacer(),
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
              margin: getMargin(bottom: 14),
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