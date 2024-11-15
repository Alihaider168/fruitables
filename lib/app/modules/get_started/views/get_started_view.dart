import 'package:rexsa_cafe/app/data/widgets/custom_get_started_button.dart';
import '../../../data/core/app_export.dart';
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseviewAuthScreen(
        child:Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: size.width,
                  height: size.height*0.65,
                  alignment: Alignment.center,
                  child: Center(
                      child: CustomImageView(
                        imagePath: ImageConstant.splash,
                        fit: BoxFit.fitWidth,
                        margin: getMargin(all: 50),
                      ))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                width: size.width,
                height: size.height*0.45,
                padding: getPadding(all: 20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      title: "lbl_welcome_to_fruitables".tr,
                      fontSize: 20,
                      color: ColorConstant.black,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: getSize(5),),
                    MyText(
                      title: "lbl_please_select_order_type".tr,
                      fontSize: 16,
                      color: ColorConstant.black,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: getSize(30),),
                    CustomGetStartedButton(
                      image: ImageConstant.delivery,
                      title: "lbl_delivery".tr,
                      onTap: (){
                        Get.toNamed(Routes.LOCATION_SELECTION);
                      },
                    ),
                    SizedBox(height: getSize(15),),
                    CustomGetStartedButton(
                      image: ImageConstant.pickup,
                      title: "lbl_pickup".tr,
                      onTap: (){
                        Get.toNamed(Routes.LOCATION_SELECTION,arguments: {"from_pickup" : true});
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
