import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';
import 'package:get/get.dart';

class OrderPlacedController extends GetxController {

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data!= null && data['id']!= null){
      getOrderDetail(data["id"]);
    }
    super.onInit();

  }

  Future<void> getOrderDetail(id) async {
    await Utils.check().then((value) async {
    if (value) {
      await BaseClient.get(ApiUtils.getOrderDetail(id),
          onSuccess: (response) async {
            print(response);

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
