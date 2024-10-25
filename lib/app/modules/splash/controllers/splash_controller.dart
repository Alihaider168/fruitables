import 'package:fruitables/app/data/core/app_export.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;
  bool reverse = false;
  final int splashDuration = 3;

  @override
  void onInit() {
    initAnimation();
    animationController!.forward();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getRoute();
  }

  void initAnimation() {
    animationController = AnimationController(
      duration: Duration(seconds: splashDuration),
      vsync: this,
    );
    sizeAnimation = Tween<double>(begin: 50, end: 300).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    )..addListener(() {
      update();
    });
  }

  Future<void> getRoute() async {
    // await appPreferences.isPreferenceReady;

    // appPreferences.getIsLoggedIn().then((value) async {
    //   if(value==null || !value){
    //     await Future.delayed(splashDuration.seconds);
    //     Get.offAndToNamed(Routes.GET_STARTED);
    //   }
    //   else {
    //
    //     appPreferences.getUserData().then((profile) async {
    //       SignupModel data  = SignupModel.fromJson(jsonDecode(profile!));
    //       String tkn = await appPreferences.getAccessToken()??"";
    //       BaseClient.addToken(tkn);
    //       debugPrint("Bearer token : ${data.accessToken??""}");
    //
    //       var hasNotification = appPreferences.getAppPreferences().getHasNotification();
    //       var payload = await appPreferences.getAppPreferences().getPayload();
    //       appPreferences.setHasNotification(hasNotification: false);
    //       await Future.delayed(splashDuration.seconds);
    //
    //       print("=========== $hasNotification ======= ${payload?.toJson()}");
    //       //CustomToast().showToast("=========== $hasNotification ======= ${payload?.toJson()}", true, Get.context);
    //
    //       if (hasNotification && payload != null) {
    //         HelperFunction.navigateFromNotification(payload, true);
    //       } else {
    //         if(!(data.user?.additionalFields?[Constants.paramCoachingShown]??false)){
    //           if (!Get.isRegistered<AccountSetupController>()) {
    //             Get.put(AccountSetupController());
    //           }
    //           Get.find<AccountSetupController>().profileData = data.obs;
    //           Get.find<AccountSetupController>().setData();
    //           Get.toNamed(Routes.ACCOUNT_SETUP);
    //         }else{
    //           if((data.user?.role?.roleId) == Constants.agentString){
    //             // Get.offAllNamed(Routes.AGENT_DASHBOARD);
    //             Constants.isUserAgent = true;
    //           }else{
    //             Get.offAllNamed(Routes.USER_DASHBOARD);
    //             Constants.isUserAgent = false;
    //           }
    //         }
    //       }
    //     });
    //
    //     FlutterAppBadger.isAppBadgeSupported().then((value) async {
    //       if (value) {
    //         FlutterAppBadger.removeBadge();
    //       }
    //     });
    //   }
    // }).catchError((err) async {
    await Future.delayed(splashDuration.seconds);
    Get.offAndToNamed(Routes.GET_STARTED);
    // Get.offAndToNamed(Routes.USER_DASHBOARD);
    // });
  }
}
