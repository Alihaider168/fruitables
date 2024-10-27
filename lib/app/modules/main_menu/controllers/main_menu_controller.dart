import 'package:fruitables/app/data/core/app_export.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainMenuController extends GetxController {

  var selectedCategoryIndex = 0.obs;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void scrollToCategory(int index) {
    selectedCategoryIndex.value = index;
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onVerticalScroll(int firstVisibleIndex) {
    selectedCategoryIndex.value = firstVisibleIndex;
  }
  final List<String> categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Meat',
    'Seafood',
    'Snacks',
    'Beverages',
    'Frozen',
  ];

  // Each category will have multiple items
  final Map<String, List<String>> categoryItems = {
    'Fruits': ['Apple', 'Banana', 'Orange', 'Mango'],
    'Vegetables': ['Tomato', 'Potato', 'Carrot', 'Broccoli'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter'],
    'Bakery': ['Bread', 'Croissant', 'Donut', 'Bagel'],
    'Meat': ['Chicken', 'Beef', 'Lamb', 'Pork'],
    'Seafood': ['Salmon', 'Shrimp', 'Crab', 'Tuna'],
    'Snacks': ['Chips', 'Cookies', 'Popcorn', 'Nuts'],
    'Beverages': ['Juice', 'Soda', 'Coffee', 'Tea'],
    'Frozen': ['Pizza', 'Ice Cream', 'Frozen Vegetables', 'Frozen Fish'],
  };

  // Controllers
  final ItemScrollController verticalScrollController = ItemScrollController();
  final ScrollController horizontalScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisible = positions.first.index;
        onVerticalScroll(firstVisible);
      }
    });
  }
}
