import 'package:get/get.dart';

import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/location_selection/bindings/location_selection_binding.dart';
import '../modules/location_selection/views/location_selection_view.dart';
import '../modules/main_menu/bindings/main_menu_binding.dart';
import '../modules/main_menu/views/main_menu_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION_SELECTION,
      page: () => const LocationSelectionView(),
      binding: LocationSelectionBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_MENU,
      page: () =>  const MainMenuView(),
      binding: MainMenuBinding(),
    ),
  ];
}
