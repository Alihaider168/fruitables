import 'package:fruitables/app/data/core/app_export.dart';
import 'package:get/get.dart';

class AddressesController extends GetxController {

  RxList<String> addresses = [
    "Haji Pura Rd, Fatehgarh, Sialkot, Punjab, Pakistan",
    "FGGC+9JV, Haji Pura Rd, near Mughal-E-Azam Marriage Hall, Boghra, Sialkot, Punjab, Pakistan"
  ].obs;

  bool fromCheckout = false;

  @override
  void onInit() {
    var data = Get.arguments;
    if(data!= null && data[Constants.paramCheckout]!= null){
      fromCheckout = data[Constants.paramCheckout];
    }
    getAddresses();
    super.onInit();
  }


  void getAddresses(){
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.addresses,
            onSuccess: (response) async {
              print(response);

              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              return false;
            },
          headers: {}
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
                  onPressed: () {
                    Get.back();
                    addresses.removeAt(index);
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
