import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/orders_model.dart';
import 'package:fruitables/app/data/widgets/custom_round_button.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckoutController extends GetxController {
  MainMenuController menuController = Get.put(MainMenuController());
  RxBool instructions = false.obs;

  RoundedLoadingButtonController checkoutController = RoundedLoadingButtonController();

  TextEditingController addressController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  RxString selectedMethod = "".obs;
  RxString selectedTime = "".obs;

  RxInt selectedDayIndex = 0.obs;
  RxInt selectedHourIndex = 0.obs;
  RxInt selectedMinuteIndex = 0.obs;

  List<String> days = [
    "today".tr,
    DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 1))),
    DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 2))),
  ];

  List<int> getHours() {
    if (selectedDayIndex.value == 0) {
      return List.generate(24 - DateTime.now().hour, (index) => DateTime.now().hour + index);
    } else {
      return List.generate(24, (index) => index);
    }
  }

  List<int> getMinutes() {
    if (selectedDayIndex.value == 0 && selectedHourIndex.value == 0) {
      int startingMinute = (DateTime.now().minute ~/ 10 + 1) * 10;
      return List.generate((60 - startingMinute) ~/ 10, (index) => startingMinute + index * 10);
    } else {
      return List.generate(6, (index) => index * 10); // Minutes in increments of 10
    }
  }

  void showDeliveryTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: getPadding(all: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()=> Get.back(),
                    child: MyText(title: "cancel".tr,
                      color: ColorConstant.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      selectedTime.value = "${days[selectedDayIndex.value]}, ${(getHours()[selectedHourIndex.value]).toString().padLeft(2, '0')}:${getMinutes()[selectedMinuteIndex.value].toString().padLeft(2, '0')}";
                      Get.back();
                    },
                    child: MyText(title: "lbl_done".tr,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.blue,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    // Day picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedDayIndex.value = index;
                          selectedHourIndex.value = 0;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: days.length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedDayIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              days[index],
                                fontSize: 18,
                                color: index == selectedDayIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      ),
                    ),
                    // Hour picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedHourIndex.value = index;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getHours().length,
                          builder: (context, index) {
                            return Obx(()=>  Container(
                              color: index == selectedHourIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getHours()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedHourIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                    // Minute picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedMinuteIndex.value = index;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getMinutes().length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedMinuteIndex.value? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getMinutes()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedMinuteIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<dynamic> addOrder() async {
    await menuController.cart.loadCartFromPreferences();
    Utils.check().then((value) async {
      if (value) {
        checkoutController.start();
        List<Map<String, dynamic>> products = [];

        for(int i=0;i<menuController.cart.items.length;i++){
          final cItem = menuController.cart.items[i];
          products.add({
            "productId": cItem.item.id,
            "name":  Utils.checkIfArabicLocale() ? cItem.item.name : cItem.item.englishName,
            "size": cItem.size,
            "quantity": cItem.quantity,
            "price": menuController.cart.getPrice(cItem)
          });
        }



        await BaseClient.post(ApiUtils.addOrder,
            onSuccess: (response) async {
          checkoutController.stop();
              print(response);
              CustomSnackBar.showCustomToast(message: "order_created".tr);
              Get.back();
          Get.toNamed(Routes.ORDER_PLACED,arguments: {"order":Orders.fromJson(response.data)});
          menuController.cart.clearCart();
              return true;
            },
            onError: (error) {
              checkoutController.stop();
              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader(),
            data: {
              "branch": Constants.selectedBranch?.id,
              "tax": menuController.cart.getTax(),
              "discount": menuController.cart.getTotalDiscountForCart(),
              "products": products
            });
      }
    });
  }

}
