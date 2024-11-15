import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  
  RxList<Orders> myOrders = <Orders>[].obs;


  @override
  void onInit() {
    getOrders();
    super.onInit();
  }


  void getOrders({final void Function(String?)? onSuccess}){
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.getOrders,
            onSuccess: (response) async {
              print(response);
              OrdersModel orderModel = OrdersModel.fromJson(response.data);
              myOrders.value.clear();
              myOrders.value.addAll(orderModel.orders??[]);
              if(onSuccess!= null && myOrders.isNotEmpty && (myOrders[0].status != "delivered" || myOrders[0].status != "cancelled")){
                onSuccess(myOrders[0].id);
              }
              myOrders.refresh();
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader()
        );
      }
    });
  }
  
}
