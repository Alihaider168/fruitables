import 'package:rexsa_cafe/app/data/utils/base/baseview_auth_screen.dart';
import 'package:rexsa_cafe/app/data/utils/image_constant.dart';

import '../../../data/core/app_export.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseviewAuthScreen(
      child:CustomImageView(
        imagePath: ImageConstant.sp,
        width: size.width,
        fit: BoxFit.fitWidth,
      )

      // Container(
      //     width: size.width,
      //     height: size.height,
      //     alignment: Alignment.center,
      //     child: GetBuilder<SplashController>(
      //       init: SplashController(),
      //       initState: (_) {},
      //       builder: (controller) {
      //         return Center(
      //             child: CustomImageView(
      //               imagePath: ImageConstant.splash,
      //               fit: BoxFit.fitWidth,
      //               width: this.controller.sizeAnimation?.value ?? 0 + 200,
      //               height: this.controller.sizeAnimation?.value ?? 0 + 200,
      //             ));
      //       },
      //     ))
    );
  }
}
