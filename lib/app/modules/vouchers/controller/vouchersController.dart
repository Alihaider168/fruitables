import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/data/utils/api_utils.dart';
import 'package:rexsa_cafe/app/data/utils/utils.dart';
import 'package:rexsa_cafe/app/services/base_client.dart';

class VoucherController extends GetxController {
  var currentTab = 0.obs;
  RxBool isLoading = false.obs;
  
  final List<String> tabs = ['Current', 'Past'];
  
 RxList<VoucherModel> vouchers = <VoucherModel>[].obs;
  RxList<VoucherModel> usedVouchers = <VoucherModel>[].obs;




  void getVouchers({final void Function(String?)? onSuccess}){

    Utils.check().then((value) async {
      isLoading.value = true;
      if (value) {
        isLoading.value = true;
        await BaseClient.get(ApiUtils.getVouchers,
            onSuccess: (response) async {
                      isLoading.value = false;
                      vouchers.value = (response.data['vouchers'] as List<dynamic>)
    .map((e) => VoucherModel.fromMap(e as Map<String, dynamic>))
    .toList();               
              return true;
            },
            onError: (error) {
                      isLoading.value = false;
                      print(error.message);

              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader()
        );
      }
    });
  }

    void getUsedVouchers({final void Function(String?)? onSuccess}){

    Utils.check().then((value) async {
      isLoading.value = true;
      if (value) {
        isLoading.value = true;
        await BaseClient.get(ApiUtils.getUsedVouchers,
            onSuccess: (response) async {
                      isLoading.value = false;
                      print(response.data);
                      usedVouchers.value = (response.data['usedVouchers'] as List<dynamic>)
    .map((e) => VoucherModel.fromMap(e as Map<String, dynamic>))
    .toList();               
              return true;
            },
            onError: (error) {
                      isLoading.value = false;

              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader()
        );
      }
    });
  }
}
