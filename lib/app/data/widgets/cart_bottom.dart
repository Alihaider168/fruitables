import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';

class CartBottom extends StatelessWidget  {

  final controller = Get.put(MainMenuController());

  CartBottom({super.key,this.showCurrentOrder = false});

  final bool showCurrentOrder;

  @override
  Widget build(BuildContext context) {
    return
      showCurrentOrder ?
    GestureDetector(
      onTap: (){
        Get.toNamed(Routes.CURRENT_ORDER_DETAIL);
      },
      child: Container(
        // height: getSize(100),
        padding: getPadding(right: 12, left: 12, top: 17, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(getSize(15)),topRight: Radius.circular(getSize(15))),
          boxShadow:const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                         
                                                 MyText(
                            title: '12345',
                              fontWeight: FontWeight.w600,
                              fontSize: getFontSize(16),
                          ),
                           ],
                         ),
                         Icon(Icons.keyboard_arrow_down, size: getSize(25),color: ColorConstant.black,)
                       ],
                     ),
                                                                                                    SizedBox(height: getSize(7)),


                  
            Container(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OrderStatusIndicator(currentIndex: 1),
                ],
              )),
              SizedBox(height: getSize(10)),
          

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${'Preparing'.tr}\n${'your_order_being_prepared'.tr}',
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
          ],
        ),
      ),
    ):
      Obx(()=>  controller.bottomBar.value
        ? Container(
      width: size.width,
      height: size.height*0.12,
      padding: getPadding(left: 16,right: 16),
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
      child: Center(
        child: GestureDetector(
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
        ),
      ),
    )
        : Offstage());
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