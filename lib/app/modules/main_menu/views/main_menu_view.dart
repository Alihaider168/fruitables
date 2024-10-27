import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/main_menu_controller.dart';

class MainMenuView extends GetView<MainMenuController> {
  const MainMenuView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainMenuView'),
        centerTitle: true,
      ),
      body:Column(
        children: [
          // Horizontal ListView for categories
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                return Obx(()=> GestureDetector(
                  onTap: () => controller.scrollToCategory(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: controller.selectedCategoryIndex.value == index
                          ? Colors.pink
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        controller.categories[index],
                        style: TextStyle(
                          color: controller.selectedCategoryIndex.value == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ));
              },
            ),
          ),
          const SizedBox(height: 10),
          // Vertical ListView for category items
          Expanded(
            child: ScrollablePositionedList.builder(
              itemCount: controller.categories.length,
              itemScrollController: controller.itemScrollController,
              itemPositionsListener: controller.itemPositionsListener,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                final items = controller.categoryItems[category] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[300],
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Items of the category
                    ...items.map((item) => ListTile(
                      title: Text(item),
                    )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}