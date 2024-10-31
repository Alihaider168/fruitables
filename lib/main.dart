import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/localization/app_localization.dart';
import 'package:fruitables/app/data/utils/initial_bindings.dart';
import 'package:fruitables/app/data/utils/language_utils.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

// void main() {
//   runApp(
//     GetMaterialApp(
//       title: "Application",
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final languagePreference = LanguageUtils();
  String? language = await languagePreference.getLanguage();


  runApp(MyApp(language: language));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.language});

  final String? language;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final AppPreferences _appPreferences = AppPreferences();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      // Dark color for the status bar
      statusBarIconBrightness: Brightness.light,
      // White icons on the status bar
      statusBarBrightness:
      Brightness.dark, // For iOS: sets status bar text and icons to light
    ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppLocalization(),
        // locale: Get.deviceLocale,
        locale: widget.language!= null && widget.language == 'اردو' ? const Locale('ur', 'PK'):const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        title: 'Fruitables',
        initialBinding: InitialBindings(),
        // showSemanticsDebugger: true,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: ColorConstant.primaryPink,
          ),
          scaffoldBackgroundColor: ColorConstant.white,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!);
        });
  }
}

