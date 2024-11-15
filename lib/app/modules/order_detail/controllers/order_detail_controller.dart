import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/order_detail/views/order_detail_view.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  Orders? order;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data != null && data['order']!= null){
      order = data['order'];
    }
    super.onInit();

  }

}
