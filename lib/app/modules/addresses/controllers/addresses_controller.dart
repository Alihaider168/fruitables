import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/address_model.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:get/get.dart';

class AddressesController extends GetxController {

  RxList<Addresses> addresses = <Addresses>[].obs;
  RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  bool fromCheckout = false;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data!= null && data[Constants.paramCheckout]!= null){
      fromCheckout = data[Constants.paramCheckout];
    }
    getAddresses();
    // addAddress();
    super.onInit();
  }


  void getAddresses(){
    Utils.check().then((value) async {
      if (value) {
        btnController.start();
        await BaseClient.get(ApiUtils.addresses,
            onSuccess: (response) async {
              btnController.stop();
              print(response);
              AddressModel addressModel = AddressModel.fromJson(response.data);
              addresses.value.clear();
              addresses.value.addAll(addressModel.addresses??[]);
              addresses.refresh();
              return true;
            },
            onError: (error) {
              btnController.stop();
              BaseClient.handleApiError(error);
              return false;
            },
          headers: Utils.getHeader()
        );
      }
    });
  }


  Future<void> deleteAddress(String? id,int index) async {
    await Utils.check().then((value) async {
      if (value) {
        await BaseClient.delete(ApiUtils.deleteAddress(id),
            onSuccess: (response) async {
              print(response);
              Get.back();
              addresses.removeAt(index);
              CustomSnackBar.showCustomToast(message: response.data['message']);
              getAddresses();
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

  void addAddress({String? label,String? street,String? floor,String? address,}){
    Utils.check().then((value) async {
      if (value) {
        btnController.start();
        await BaseClient.post(ApiUtils.addresses,
            onSuccess: (response) async {
              print(response);
              btnController.stop();
              CustomSnackBar.showCustomToast(message: response.data['message']);
              getAddresses();

              return true;
            },
            onError: (error) {
              btnController.stop();
              BaseClient.handleApiError(error);
              return false;
            },
            data: {
              "label": label,
              "street": street,
              "floor": floor,
              "address": address
            },
          headers: Utils.getHeader()
        );
      }
    });
  }

  void showDeleteAddressDialog(BuildContext context,int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          titlePadding: getPadding(top: 15,left: 15,right: 15,bottom: 15),
          contentPadding: getPadding(left: 16, right: 16,top: 10,bottom: 10),
          actionsPadding: getPadding(bottom: 8, right: 16),
          title: Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              title: 'lbl_delete_address'.tr,
              color: ColorConstant.textGrey,
            ),
          ),
          content: MyText(
            title: 'lbl_are_you_sure_to_delete_address'.tr,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: MyText(title: "lbl_no".tr,color: ColorConstant.red,),
                ),
                SizedBox(width: getSize(10)),
                TextButton(
                  onPressed: () async {
                    await deleteAddress(addresses[index].id,index);

                  },
                  child: MyText(title: "lbl_yes".tr,color: ColorConstant.blue,),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
