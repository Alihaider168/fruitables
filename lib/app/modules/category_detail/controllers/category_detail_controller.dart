import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../data/core/app_export.dart';
import 'dart:async';

class CategoryDetailController extends GetxController {
  Rx<MenuModel> menuModel = MenuModel().obs;
  var selectedCategoryIndex = 0.obs;
  bool isRTL = Utils.checkIfUrduLocale(); // Determine RTL once for efficiency


  MainMenuController mainMenuController = Get.put(MainMenuController());

  final ScrollController scrollController = ScrollController();

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
        // centerSelectedHorizontalItem(data['category']);
        // scrollToCategory
      }

      // Initialize if not done yet
      if (!isInit) {
        isInit = true;
        if (data != null && data['category'] != null) {
          await Future.delayed(Duration(microseconds: 10));
          scrollToCategory(data['category']);
          // centerSelectedHorizontalItem(data['category']);
        }
      }
    });

    // Listen for changes to the selected index to center the horizontal item
    ever(selectedCategoryIndex, (index) {
      centerSelectedHorizontalItem(index);
    });
  }

  void scrollToCategory(int index) {
    double alignment = isRTL? 0.4: 0.33;

    print("Scrolling to index: $index with alignment: $alignment (RTL: $isRTL)");
      itemScrollController.jumpTo(index: index,alignment: alignment);
    // itemScrollController.scrollTo(
    //   index: index,
    //   alignment: alignment,
    //   duration: const Duration(milliseconds: 50),
    //   curve: Curves.easeInOut,
    // );
  }

  void centerSelectedHorizontalItem(int index) {
    double alignment = isRTL? 0.4:0.33;

    print("Centering to index: $index with alignment: $alignment (RTL: $isRTL)");
    horizontalItemScrollController.jumpTo(index: index,alignment: alignment);
    // horizontalItemScrollController.scrollTo(
    //   index: index,
    //   alignment: alignment,
    //   duration: Duration(milliseconds: 50),
    //   curve: Curves.easeInOut,
    // );
    selectedCategoryIndex.value = index;
  }

  void onVerticalScroll(int firstVisibleIndex) {
    if (selectedCategoryIndex.value != firstVisibleIndex) {
      selectedCategoryIndex.value = firstVisibleIndex;
    }
  }

  onTapItemChange(int index){
    double alignment = isRTL? 0.4:0.33;
    horizontalItemScrollController.scrollTo(
      index: index,
      alignment: alignment,
      duration: Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
    itemScrollController.scrollTo(
      index: index,
      alignment: alignment,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
    selectedCategoryIndex.value = index;
  }
}



