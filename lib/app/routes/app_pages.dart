import 'package:get/get.dart';

import '../modules/add_address/bindings/add_address_binding.dart';
import '../modules/add_address/views/add_address_view.dart';
import '../modules/add_payment/bindings/add_payment_binding.dart';
import '../modules/add_payment/views/add_payment_view.dart';
import '../modules/addresses/bindings/addresses_binding.dart';
import '../modules/addresses/views/addresses_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category_detail/bindings/category_detail_binding.dart';
import '../modules/category_detail/views/category_detail_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/current_order_detail/bindings/current_order_detail_binding.dart';
import '../modules/current_order_detail/views/current_order_detail_view.dart';
import '../modules/favourites/bindings/favourites_binding.dart';
import '../modules/favourites/views/favourites_view.dart';
import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/language_selection/bindings/language_selection_binding.dart';
import '../modules/language_selection/views/language_selection_view.dart';
import '../modules/location_selection/bindings/location_selection_binding.dart';
import '../modules/location_selection/views/location_selection_view.dart';
import '../modules/main_menu/bindings/main_menu_binding.dart';
import '../modules/main_menu/views/main_menu_view.dart';
import '../modules/order_detail/bindings/order_detail_binding.dart';
import '../modules/order_detail/views/order_detail_view.dart';
import '../modules/order_placed/bindings/order_placed_binding.dart';
import '../modules/order_placed/views/order_placed_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
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
      page: () => const MainMenuView(),
      binding: MainMenuBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_DETAIL,
      page: () => const CategoryDetailView(),
      binding: CategoryDetailBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESSES,
      page: () => const AddressesView(),
      binding: AddressesBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.FAVOURITES,
      page: () => const FavouritesView(),
      binding: FavouritesBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => const AddAddressView(),
      binding: AddAddressBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PAYMENT,
      page: () => const AddPaymentView(),
      binding: AddPaymentBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_PLACED,
      page: () => const OrderPlacedView(),
      binding: OrderPlacedBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SELECTION,
      page: () => const LanguageSelectionView(),
      binding: LanguageSelectionBinding(),
    ),
    GetPage(
      name: _Paths.CURRENT_ORDER_DETAIL,
      page: () => const CurrentOrderDetailView(),
      binding: CurrentOrderDetailBinding(),
    ),
  ];
}
