import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';

class NewDetailController extends GetxController {
  Orders? order;
  @override
  void onInit() {
    var data = Get.arguments;
    if(data != null && data['order']!=null){
      order = data['order'];
    }
    super.onInit();
  }

}
