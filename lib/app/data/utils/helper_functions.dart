// ignore_for_file: constant_identifier_names
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:intl/intl.dart';

class HelperFunction {
  static String? emailValidate(String val) {
    if (val.isEmpty) {
      return 'email_cannot_be_empty'.tr;
    } else if (val.isEmail == false) {
      return 'invalid_email'.tr;
    } else {
      return stringValidateWithMaxAndMinLimit(
          val, Constants.EMAIL_VALIDATION, 1,
          fieldName: "lbl_email_address2".tr);
    }
  }

  static String maskString(String input) {
    if (input.length <= 4) {
      return input; // No need to mask if the string is too short
    }

    String firstLetter = input[0];
    String lastThreeLetters = input.substring(input.length - 3);
    String maskedSection = '*' *
        (input.length -
            4); // Mask everything except the first and last three characters

    return firstLetter + maskedSection + lastThreeLetters;
  }

  static String? validateEmailOrPhone(String? value) {
    // Regular expression for email validation
    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    // Improved regular expression for phone number validation
    const String phonePattern =
        r'^\+?(\d{1,3})?[-. ]?(\(?\d{1,4}\)?)?[-. ]?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$';

    if (value == null || value.isEmpty) {
      return 'Please enter email or phone number';
    }

    // Check if the value matches email or phone pattern
    bool isValidEmail = RegExp(emailPattern).hasMatch(value);
    bool isValidPhone = RegExp(phonePattern).hasMatch(value);

    if (!isValidEmail && !isValidPhone) {
      return 'Please enter a valid email or phone number';
    }

    return null;
  }


  static String? stringValidate(val, {fieldName}) {
    if (val.isEmpty || val == '') {
      return '${fieldName ?? 'field'.tr} ${'cannot_be_empty'.tr}';
    }
    if (val.toString().trim().isEmpty) {
      return '${fieldName ?? 'field'.tr} ${'msg_invalid_input'.tr}';
    } else {
      return null;
    }
  }

  static String? urlValidate(String val, {fieldName}) {
    // RegExp regex = RegExp(r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",caseSensitive: false);
    RegExp regex = RegExp(
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
        caseSensitive: false);
    if (val.isEmpty || val == '') {
      return '${fieldName ?? 'field'.tr} ${'cannot_be_empty'.tr}';
    }
    if (!regex.hasMatch(val)) {
      return 'msg_url'.tr;
    } else {
      return null;
    }
  }



  static String convertDateIntoTicketFormat({DateTime? date}) {
    return DateFormat('EEEE, MMMM dd | hh:mm a').format(date??DateTime.now());
  }



  // static String? validateNumber(PhoneNumber str) {
  //   // Pattern pattern =
  //   //     r'^(?:[+0]9)?[0-9]{10}$/';
  //   // RegExp regex = RegExp(pattern.toString());
  //   // if (!regex.hasMatch(str.number)){
  //   //   return "invalid_phone_number".tr;
  //   // }
  //
  //   // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  //   RegExp regExp = RegExp(r'^\d+\?\d*');
  //   if (!regExp.hasMatch(str.number)) {
  //     return 'Please enter valid mobile number';
  //   }
  //
  //   if(str.number.length < 10){
  //     return "invalid_phone_number".tr;
  //   }
  //   try{
  //      double.parse(str.number);
  //      return stringValidateWithMaxAndMinLimit(str.number, Constants.PHONE_VALIDATION, Constants.PHONE_MIN_VALIDATION);
  //   } on FormatException {
  //     return "invalid_phone_number".tr;
  //   }
  //   // finally {
  //   //   return true;
  //   // }
  // }
  //
  // static String? confirmPassword(String value, String passwordValue, String label) {
  //   if (value.isEmpty) {
  //     return "$label ${"is_required".tr}";
  //   }
  //   if (value != passwordValue) {
  //     return "the_password_confirmation_does_not_match".tr;
  //   } else {
  //     return null;
  //   }
  // }

  static String? stringValidateWithLImit(val, limit, {fieldName}) {
    if (val.isEmpty || val == '') {
      return '${fieldName ?? 'field'.tr} ${'cannot_be_empty'.tr}';
    } else if (val.toString().length > limit) {
      return 'character_limit_exceeded'.tr;
    } else {
      return null;
    }
  }

  static String? stringValidateWithMaxAndMinLimit(val, maxlimit, minlimit,
      {fieldName}) {
    if (val.toString().trim().isEmpty || val == '') {
      return '${fieldName ?? 'field'.tr} ${'cannot_be_empty'.tr}';
    } else if (val.toString().trim().length > maxlimit) {
      // return 'character_limit_exceeded'.tr;
      return 'character_limit_must_be_between'.tr +
          minlimit.toString() +
          'and'.tr +
          maxlimit.toString();
    } else if (val.toString().trim().length < minlimit) {
      return 'character_limit_must_be_between'.tr +
          minlimit.toString() +
          'and'.tr +
          maxlimit.toString();
    } else {
      return null;
    }
  }

  // static String? passwordValidate(String value,
  //     {bool isCurrentPassword = false})
  // {
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //
  //   if (value.isEmpty || value == "") {
  //     return "password_cannot_be_empty".tr;
  //   }
  //   if (value.length < 8 && !isCurrentPassword) {
  //     return "password_is_really_short".tr;
  //   }
  //   if (!regex.hasMatch(value) && !isCurrentPassword) {
  //     return "msg_must_contain".tr;
  //   } else {
  //     return isCurrentPassword
  //         ? null
  //         : stringValidateWithMaxAndMinLimit(value,
  //             Constants.PASSWORD_VALIDATION, Constants.PASSWORD_MIN_VALIDATION,
  //             fieldName: "lbl_password".tr);
  //   }
  // }

  // static String? confirmPasswordValidate(String value, String confirmValue) {
  //   // print(value);
  //   // print(confirmValue);
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   if (value.isEmpty || value == "") {
  //     return "con_password_cannot_be_empty".tr;
  //   } else if (value.length < 8) {
  //     return "con_password_is_really_short".tr;
  //   } else if (value != confirmValue) {
  //     return "msg_password_same".tr;
  //   } else if (!regex.hasMatch(confirmValue)) {
  //     return "msg_must_contain".tr;
  //   } else {
  //     return stringValidateWithMaxAndMinLimit(value,
  //         Constants.PASSWORD_VALIDATION, Constants.PASSWORD_MIN_VALIDATION,
  //         fieldName: "lbl_password".tr);
  //   }
  // }

  static bool showPassword(bool value) {
    if (value == true) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateGoogleUrl(String value) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    if (value.isEmpty ||
        value.contains('google.com') &&
            Uri.parse(value).hasAbsolutePath == true &&
            urlRegExp.hasMatch(value)) {
      return null;
    } else {
      return 'valid_url_msg'.tr;
    }
  }

  static String? validatefacebookUrl(String value) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    if (value.isEmpty ||
        value.contains('facebook.com') &&
            Uri.parse(value).hasAbsolutePath == true &&
            urlRegExp.hasMatch(value)) {
      return null;
    } else {
      return 'valid_url_msg'.tr;
    }
  }

  // static Future<void> clearLocalStorage() async {
  //   SharedPreferences storage = await SharedPreferences.getInstance();
  //   storage.clear();
  // }

  static String dateParse(String date) {
    try {
      DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(date, true)
          .toLocal();
      String formattedDate = DateFormat('MMM dd').format(dateTime);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }

  static String dateParseInEdit(String date) {
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date, true).toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  static String formatUTCTimeReceived(String time) {
    try {
      DateTime tempDate = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(tempDate.toLocal());
    } catch (e) {
      return "";
    }
  }

  static String convertTo24HoursTime(String time) {
    try {
      DateTime tempDate = DateFormat("hh:mm a").parse(time);
      return DateFormat("HH:mm").format(tempDate.toLocal());
    } catch (e) {
      return "";
    }
  }

  static String convertToDate(DateTime date) {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);
      return formatted;
    } catch (e) {
      return "";
    }
  }

  static const double FULL_SCREEN_SIZE = 100.0;
  static const int EMAIL_VALIDATION = 255;

//  Forms padding
  static const double FORM_PADDING = 10.0;
  static const double FORM_PADDING2 = 15.0;

//  Screens padding
  static const double SCREENS_SIDE_PADDING = 15.0;

  // static navigateFromNotification(ExtraPayload payload, bool fromSplash) async {
  //   // switch (payload.type) {
  //   //   case Constants.USER_DASHBOARD_NAVIGATION:
  //   //     Constants.isUserAgent = false;
  //   //     // Get.offAllNamed(Routes.USER_DASHBOARD);
  //   //     Property? property = await getThisProperty(payload.refId);
  //   //     Get.toNamed(Routes.REEL_SPECIFIC, arguments: {Constants.paramPayload : property, Constants.fromSplash: fromSplash});
  //   //     break;
  //   //   case Constants.PRICE_REDUCED_NAVIGATION:
  //   //     Constants.isUserAgent = false;
  //   //     Property? property = await getThisProperty(payload.refId);
  //   //     Get.toNamed(Routes.REEL_SPECIFIC, arguments: {Constants.paramPayload : property, Constants.fromSplash: fromSplash});
  //   //     break;
  //   //
  //   //   case Constants.ZIP_CODE_NAVIGATION :
  //   //     Constants.isUserAgent = true;
  //   //     Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 0,Constants.paramName : 'lbl_zip_codes'.tr});
  //   //     break;
  //   //
  //   //   case Constants.ACTIVE_AD_NAVIGATION:
  //   //     Constants.isUserAgent = true;
  //   //     Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 2,Constants.paramName : 'lbl_ads'.tr});
  //   //     break;
  //
  //   // case Constants.AGENT_DASHBOARD_ZIP_NAVIGATION:
  //   //   Constants.isUserAgent = true;
  //   //   Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 0,Constants.paramName : 'lbl_zip_codes'.tr});
  //   //   break;
  //
  //   // case Constants.AGENT_DASHBOARD_AD_NAVIGATION:
  //   //   Constants.isUserAgent = true;
  //   //   Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 2,Constants.paramName : 'lbl_ads'.tr});
  //   //   break;
  //
  //   //   case Constants.BUY_ZIP_NAVIGATION:
  //   //     Constants.isUserAgent = true;
  //   //     Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 0,Constants.paramName : 'lbl_zip_codes'.tr});
  //   //     // Get.toNamed(Routes.ADD_ZIP_CODES,arguments: {Constants.fromSplash: fromSplash});
  //   //     break;
  //   //
  //   //   case Constants.BUY_AD_NAVIGATION:
  //   //     Constants.isUserAgent = true;
  //   //     Get.offAllNamed(Routes.AGENT_DASHBOARD,arguments: {Constants.paramIndex : 2,Constants.paramName : 'lbl_ads'.tr});
  //   //     break;
  //   //
  //   //   default:
  //   //     break;
  //   // }
  // }
}
