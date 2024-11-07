// ignore_for_file: constant_identifier_names

import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/city_model.dart';

class Constants {

  static const int otpLength = 4;
  static const int EMAIL_VALIDATION = 35;
  static const int NAME_VALIDATION = 20;
  static const int NAME_MIN_VALIDATION = 2;
  static const int PASSWORD_MIN_VALIDATION = 8;
  static const int PASSWORD_VALIDATION = 15;
  static const int PHONE_MIN_VALIDATION = 10;
  static const int PHONE_VALIDATION = 15;
  static const int MAX_INPUT_LIMIT = 30;
  static const int refreshDelay = 800;
  static const int MAX_IMAGE_SIZE = 3; // in Mbs
  static const int DELIVERY_FEES = 200; // in Mbs
  static const String paramCheckout = 'checkout'; // in Mbs

  static RxBool isLoggedIn = false.obs;

  static bool showToast = true;
  static bool showNoInternetToast = false;

  static const debounceDuration = Duration(milliseconds: 1000);

  static Cities? selectedCity;
  static Branches? selectedBranch;



}
