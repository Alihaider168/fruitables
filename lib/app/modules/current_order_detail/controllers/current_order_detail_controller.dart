import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:get/get.dart';

class CurrentOrderDetailController extends GetxController {
  Orders? order;

  int index = 0;

  @override
  void onInit() {
    var data= Get.arguments;
    if(data!= null && data['order']!= null){
      order =  data['order'];
      if(order?.status == "pending"){
        index = 0;
      }
      if(order?.status == "preparing"){
        index = 1;
      }
      if(order?.status == "ready"){
        index = 2;
      }
    }
    super.onInit();
  }

}
