import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../data/core/app_export.dart';
import 'dart:async';

class CategoryDetailController extends GetxController {
  Rx<MenuModel> menuModel = MenuModel().obs;
  var selectedCategoryIndex = 0.obs;

  MainMenuController mainMenuController = Get.put(MainMenuController());

  final ScrollController scrollController = ScrollController();
  final double itemWidth = 150; // Adjust this based on your item width

  bool isInit = false;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemScrollController horizontalItemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void onInit() {
    var data = Get.arguments;
    super.onInit();
    menuModel.value = mainMenuController.menuModel.value;

    // Listen to vertical scroll
    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisible = positions.first.index;
        onVerticalScroll(firstVisible);
      }

      // Initialize if not done yet
      if (!isInit) {
        isInit = true;
        if (data != null && data['category'] != null) {
          await Future.delayed(300.milliseconds);
          scrollToCategory(data['category']);
          centerSelectedHorizontalItem(data['category']);
        }
      }
    });

    // Listen for changes to the selected index to center the horizontal item
    ever(selectedCategoryIndex, (index) {
      centerSelectedHorizontalItem(index);
    });
  }

  void scrollToCategory(int index) {
    selectedCategoryIndex.value = index;
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void onVerticalScroll(int firstVisibleIndex) {
    selectedCategoryIndex.value = firstVisibleIndex;
  }

  void centerSelectedHorizontalItem(int index) {
    horizontalItemScrollController.scrollTo(
      index: index,
      alignment: 0.3, // Center alignment for the selected item
      duration: Duration(milliseconds: 1), // Smooth transition duration
      curve: Curves.easeInOut,
    );
  }
}



