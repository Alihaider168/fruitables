import 'package:fruitables/app/modules/order_detail/views/order_detail_view.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final Order order = Order(
    id: "5RM4-59HG6",
    orderNumber: "15523392",
    date: DateTime(2024, 11, 4, 18, 9),
    status: "confirmed".tr,
    address: "street turbine مظفرپور گممن سیالکوٹ،\nMuzaffarpur, Sialkot",
    paymentMethod: "cash_on_delivery".tr,
    items: [
      OrderItem(
        name: "Tortilla Wrap",
        quantity: 1,
        price: 740.0,
        sauces: ["Barbeque Sauce", "Mushroom Sauce"],
      ),
      OrderItem(
        name: "Regular Fries",
        quantity: 1,
        price: 260.0,
      ),
    ],
    deliveryFee: 120.0,
    discount: 30.0,
  );
}
