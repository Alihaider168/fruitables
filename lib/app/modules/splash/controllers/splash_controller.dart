import 'dart:convert';

import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/user_model.dart';
import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;
  bool reverse = false;
  final int splashDuration = 3;
  AppPreferences appPreferences = AppPreferences();

  @override
  void onInit() {
    initAnimation();
    isLoggedIn();
    animationController!.forward();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    isLoggedIn();
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

  Future<void> isLoggedIn() async {
    await appPreferences.isPreferenceReady;

    appPreferences.getIsLoggedIn().then((value) async {
      if(value==true){
        appPreferences.getUserData().then((profile) async {
          Constants.userModel  = UserModel.fromJson(jsonDecode(profile!));
          Constants.isLoggedIn.value = true;
          await Future.delayed(splashDuration.seconds);
          Get.offAllNamed(Routes.LANGUAGE_SELECTION);
        }).catchError((err) async {
          await Future.delayed(splashDuration.seconds);
          Get.offAllNamed(Routes.LANGUAGE_SELECTION);
        });

      }else{
        await Future.delayed(splashDuration.seconds);
        Get.offAllNamed(Routes.LANGUAGE_SELECTION);
      }
      // getUserDetail();

    }).catchError((err) async {
      // getUserDetail();
      await Future.delayed(splashDuration.seconds);
      Get.offAllNamed(Routes.LANGUAGE_SELECTION);
    });
  }


  Future<dynamic> getUserDetail() async {
    Utils.check().then((value) async {
      if (value) {

        await BaseClient.get(ApiUtils.getMyDetail,
          onSuccess: (response) async {
            User user = User.fromJson(response.data['customer']);
            Constants.userModel?.customer = user;
            await appPreferences.isPreferenceReady;
            appPreferences.setUserData(data: jsonEncode(response.data['customer']));
            return true;
          },
          onError: (error) {
            BaseClient.handleApiError(error);
            return false;
          },
          headers: Utils.getHeader(),
        );
      }
    });
  }
}
