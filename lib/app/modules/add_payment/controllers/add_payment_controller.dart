import 'package:fruitables/app/data/core/app_export.dart';
import 'package:get/get.dart';

class AddPaymentController extends GetxController {
  final List<String> paymentTypes = [
    "cash_on_delivery".tr,
    "credit_debit_card".tr,
  ];
  final List<IconData> icons = [
    Icons.delivery_dining,
    Icons.credit_card,
  ];
}
