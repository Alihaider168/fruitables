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

    Utils.setUIOverlay();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppLocalization(),
        // locale: Get.deviceLocale,
        locale: widget.language!= null && widget.language == 'arabic' ? const Locale('ar', 'SA'):const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        title: 'Rexsa Cafe',
        initialBinding: InitialBindings(),
        // showSemanticsDebugger: true,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black.withOpacity(0.3), // Adjust opacity as needed
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
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

