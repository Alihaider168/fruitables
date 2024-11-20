import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {


  // 07: 00 am
  static String timeFormator(date) {
    var time = TimeOfDay.fromDateTime(date);
    return '${time.hourOfPeriod < 10 ? '0${time.hourOfPeriod}' : time.hourOfPeriod} : ${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.period.name}';
  }

  static String formatTimestamp(String? utcTimestamp) {
    // Parse the UTC timestamp
    DateTime utcDateTime;

    if(utcTimestamp == null){
      utcDateTime = DateTime.now();
    }else{
      utcDateTime = DateTime.parse(utcTimestamp);
    }

    // Convert UTC to local time (adjust according to your timezone if needed)
    DateTime localDateTime = utcDateTime.toLocal();

    // Format the date and time
    String formattedDate = DateFormat('d MMM HH:mm').format(localDateTime);

    return formattedDate;
  }


  static void hideKeyboard(context) {
    FocusScope.of(context).unfocus();
  }

  // static void showToast(String body,bool error){
  //   CustomToast().showToast(body, error);
  // }

  // static String getMonth(date){
  //   DateTime dt = DateTime.parse(date);
  //   String formattedDate = DateFormat('dd MMM').format(dt);
  //   return formattedDate;
  // }
  //

  static String? otpValidate(String value) {
    if (value.isEmpty) {
      return "otp_required".tr;
    } else if (value.length < 4) {
      return "enter_valid_otp".tr;
    }
    return null;
  }

  static Uint8List convertFileToBytes(String path) {
    return Uint8List.fromList(File(path).readAsBytesSync());
  }

  String timeAgoSinceDate({bool numericDates = true, required String dateStr}) {
    DateTime dateParam =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").parseUtc(dateStr);
    //2022-12-13T08:43:00.000+00:00

    DateTime date = dateParam.toLocal();
    final date2 = DateTime.now().toLocal();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds <= 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes <= 1) {
      return (numericDates) ? '1 min ago' : 'A min ago';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours <= 1) {
      return (numericDates) ? '1h ago' : 'An hour ago';
    } else if (difference.inHours <= 60) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays <= 1) {
      return (numericDates) ? '1d ago' : 'Yesterday';
    } else if (difference.inDays <= 6) {
      return '${difference.inDays}d ago';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return (numericDates) ? '1w ago' : 'Last week';
    } else if ((difference.inDays / 7).ceil() <= 4) {
      return '${(difference.inDays / 7).ceil()}w ago';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 30).ceil() <= 30) {
      return '${(difference.inDays / 30).ceil()} months ago';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }

  // static Future<List<File>?> mediaPicker({
  //   ImageSource imageSource = ImageSource.gallery,
  //   PickType pickType = PickType.image,
  //   int count = 1,
  //   CropAspectRatio? cropAspectRatio = CropAspectRatio.custom,
  //   required BuildContext context,
  // }) async {
  //   var permissionResult = (imageSource == ImageSource.camera)
  //       ? await MediaPermissionHandler.requestCameraPermission()
  //       : await MediaPermissionHandler.requestGalleryPermission();
  //
  //   List<Media>? media = [];
  //
  //   if (permissionResult) {
  //     if (imageSource == ImageSource.gallery) {
  //       media = await ImagesPicker.pick(
  //         count: count,
  //         pickType: pickType,
  //         quality: 0.5,
  //         maxSize: 100,
  //         maxTime: 300,
  //         cropOpt: CropOption(
  //           aspectRatio: cropAspectRatio,
  //         ),
  //       );
  //     } else if (imageSource == ImageSource.camera) {
  //       media = await ImagesPicker.openCamera(
  //         pickType: pickType,
  //         quality: 0.5,
  //         maxSize: 100,
  //         maxTime: 300,
  //         cropOpt: CropOption(
  //           aspectRatio: cropAspectRatio,
  //         ),
  //       );
  //     }
  //     if (media != null && media.isNotEmpty) {
  //       // print("Media length ${media.length}");
  //       return media.map((e) => File(e.path)).toList();
  //     } else {
  //       // print('Image not selected');
  //       return null;
  //     }
  //   } else {
  //     AppSettings.openAppSettings();
  //     return null;
  //   }
  // }

  // static void deeplinkNavigation(Uri deepLink, {bool fromSplash = false}) {
  //   print("Deep link url ${deepLink.path}");
  //
  //   switch (deepLink.path) {
  //     case "/product":
  //       {
  //         var productId = deepLink.queryParameters[AppConstants.productId];
  //         print("Navigating according to deeplink product id: $productId");
  //         Get.toNamed(AppRoutes.productDetailsScreen, arguments: {AppConstants.productId: productId, AppConstants.fromSplash: fromSplash});
  //         break;
  //       }
  //     case "/service":
  //       {
  //         var serviceId = deepLink.queryParameters[AppConstants.serviceId];
  //         print("Navigating according to deeplink service id: $serviceId ");
  //         Get.toNamed(AppRoutes.serviceDetailScreen, arguments: {"service_details": ServiceData()});
  //         break;
  //       }
  //     case "/promoteEvent":
  //       {
  //         var promoteEventId = deepLink.queryParameters[AppConstants.promoteEventId];
  //         print("Navigating according to deeplink promote event id $promoteEventId ");
  //         Get.toNamed(AppRoutes.eventDetailsScreen, arguments: {AppConstants.promoteEventId: promoteEventId, AppConstants.fromSplash: fromSplash});
  //         break;
  //       }
  //     case "/liveEvent":
  //       {
  //         var liveEventId = deepLink.queryParameters[AppConstants.liveEventId];
  //         print("Navigating according to deeplink $liveEventId");
  //         // Get.toNamed(AppRoutes.productDetailsScreen, arguments: ProductData(id: int.parse(productId!)));
  //         break;
  //       }
  //     case "/liveGroup":
  //       {
  //         var liveGroupId = deepLink.queryParameters[AppConstants.liveGroupId];
  //         print("Navigating according to deeplink $liveGroupId");
  //         Get.toNamed(AppRoutes.groupDetailScreen, arguments: {AppConstants.liveGroupId: liveGroupId, AppConstants.fromSplash: fromSplash});
  //         break;
  //       }
  //
  //     case "/reel":
  //       {
  //         var reelId = deepLink.queryParameters[AppConstants.reelId];
  //         print("Navigating according to deeplink $reelId ");
  //         Get.toNamed(AppRoutes.specificReelPage, arguments: {AppConstants.reelId: reelId, AppConstants.fromSplash: fromSplash});
  //       }
  //     // case "/product":{
  //     //   var productId = deepLink.queryParameters[AppConstants.productId];
  //     //   print("Navigating according to deeplink $productId ");
  //     //   Get.toNamed(AppRoutes.productDetailsScreen, arguments: ProductData(id: int.parse(productId!)));
  //     //   break;
  //     // }
  //   }
  // }

  // static Future<List<File>?> mediaPicker({
  //   ImageSource imageSource = ImageSource.gallery,
  //   PickType pickType = PickType.image,
  //   int count = 1,
  //   CropAspectRatio? cropAspectRatio = CropAspectRatio.custom,
  //   required BuildContext context,
  // }) async {
  //   var permissionResult = (imageSource == ImageSource.camera)
  //       ? await MediaPermissionHandler.requestCameraPermission()
  //       : await MediaPermissionHandler.requestGalleryPermission();
  //
  //   List<Media>? media = [];
  //
  //   if (permissionResult) {
  //     if (imageSource == ImageSource.gallery) {
  //       media = await ImagesPicker.pick(
  //         count: count,
  //         pickType: pickType,
  //         quality: 0.5,
  //         maxSize: 100,
  //         maxTime: 300,
  //         cropOpt: CropOption(
  //           aspectRatio: cropAspectRatio,
  //         ),
  //       );
  //     } else if (imageSource == ImageSource.camera) {
  //       media = await ImagesPicker.openCamera(
  //         pickType: pickType,
  //         quality: 0.5,
  //         maxSize: 100,
  //         maxTime: 300,
  //         cropOpt: CropOption(
  //           aspectRatio: cropAspectRatio,
  //         ),
  //       );
  //     }
  //     if (media != null && media.isNotEmpty) {
  //       print("Media length ${media.length}");
  //       return media.map((e) => File(e.path)).toList();
  //     } else {
  //       print('Image not selected');
  //     }
  //   } else {
  //     showPermissionDialog(context);
  //   }
  // }

  // static Future<Uri?> createDynamicLink(String link) async {
  //   print("Link ------> $link");
  //   try {
  //     final dynamicLinkParams = DynamicLinkParameters(
  //       uriPrefix: "https://efashionbook.page.link",
  //       link: Uri.parse(link),
  //       androidParameters: AndroidParameters(packageName: "com.app.efbapp.efb_app"),
  //       iosParameters: IOSParameters(bundleId: "com.app.efbapp.efbApp"),
  //     );
  //
  //     var url = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //
  //     return url.shortUrl;
  //     // return await dynamicLinks.buildLink(dynamicLinkParams);
  //   } catch (e) {
  //     print("Error generating dynamic link: $e");
  //     return null;
  //   }
  // }

  // static CardType getCardTypeFrmNumber(String input) {
  //   CardType cardType;
  //   if (input.startsWith(RegExp(
  //       r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
  //     cardType = CardType.MasterCard;
  //   } else if (input.startsWith(RegExp(r'[4]'))) {
  //     cardType = CardType.Visa;
  //   } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
  //     cardType = CardType.Verve;
  //   } else if (input.length <= 8) {
  //     cardType = CardType.Others;
  //   } else {
  //     cardType = CardType.Invalid;
  //   }
  //   return cardType;
  // }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static String getFormattedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  static String getFormattedDateNew(String? date) {
    DateTime dateTime;
    if (date == null) {
      dateTime = DateTime.now();
    } else {
      dateTime = DateTime.parse(date);
    }
    String formattedDate = DateFormat("dd MMMM yyyy").format(dateTime);
    return formattedDate;
  }

  static String getFormattedDateWithHoursAndMinutes(String? date) {
    DateTime dateTime;
    if (date == null) {
      dateTime = DateTime.now();
    } else {
      dateTime = DateTime.parse(date);
    }
    String formattedDate =
        DateFormat("dd MMMM yyyy, HH:mm").format(dateTime.toLocal());
    return formattedDate;
  }

  static void showNoInternet() {
    // if(Constants.showNoInternetToast){
    //   Constants.showNoInternetToast = false;
    //   CustomSnackBar.showCustomErrorToast(message: "msg_no_internet".tr);
    // }
  }

  static bool checkIfArabicLocale() {
    // Get the current locale
    Locale? currentLocale = Get.locale;

    // Check if the current locale is Urdu
    if (currentLocale != null && currentLocale.languageCode == 'ar') {
      return true;
    } else {
     return false;
    }
  }

  static setUIOverlay(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:  ColorConstant.blackShaded, // Semi-transparent black
      statusBarIconBrightness: Brightness.light,     // White icons on status bar
      systemNavigationBarColor: Colors.black,        // Black navigation bar color
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  static Future<void> launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomSnackBar.showCustomErrorToast(message: 'Could not open ${url.scheme} app');
    }
  }

  static String getCompleteUrl(String? url){
    return "https://pub-7fa3ae0aa90f4d319e741b9fa2015658.r2.dev/${url??""}";
  }


  static Map<String, dynamic>? getHeader(){
    return Constants.isLoggedIn.value ? {"Authorization": "Bearer ${Constants.userModel?.token}"}: null;
  }


  static String formatNumberWithText(String input) {
    // Extract the number part and format it
    RegExp regex = RegExp(r'\d+(\.\d+)?');
    Match? match = regex.firstMatch(input);

    if (match != null) {
      String numberPart = match.group(0)!;
      double number = double.parse(numberPart);
      String formattedNumber = number.toStringAsFixed(2);

      // Replace the original number with the formatted one
      return input.replaceFirst(numberPart, formattedNumber);
    }

    // If no number is found, return the input as it is
    return input;
  }


  static num getNewCheckoutPrice(num totalDiscountedPrice,num tax){
    return totalDiscountedPrice + tax + (Constants.isDelivery.value ?Constants.DELIVERY_FEES : 0);
  }

}
