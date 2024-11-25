import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/data/utils/helper_functions.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_text_form_field.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class CartController extends GetxController {
  MainMenuController menuController = Get.put(MainMenuController());

  RxBool useWallet = false.obs;
  RxBool usePoints = false.obs;

  num? usedPointsBalance;
  num? usedWalletBalance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final TextEditingController voucherCodeController = TextEditingController();
        RoundedLoadingButtonController btnController = RoundedLoadingButtonController();




  @override
  void onInit() {
    super.onInit();
  }

  num getWalletAmount() {
    num walletBalance = Constants.userModel?.customer?.balance ?? 0;
    num totalCheckoutPrice = Utils.getNewCheckoutPrice(
      menuController.cart.getTotalDiscountedPrice(),
      menuController.cart.getTax(),
    );

    // Use the lesser of wallet balance or total checkout price
    usedWalletBalance = walletBalance < totalCheckoutPrice ? walletBalance : totalCheckoutPrice;
    return walletBalance < totalCheckoutPrice ? walletBalance : totalCheckoutPrice;
  }

  num getPointsAmount() {
    num walletBalance = Constants.userModel?.customer?.balance ?? 0;
    num pointsBalance = Constants.userModel?.customer?.points ?? 0;
    num totalCheckoutPrice = Utils.getNewCheckoutPrice(
      menuController.cart.getTotalDiscountedPrice(),
      menuController.cart.getTax(),
    );

    // If wallet is being used and can fully cover the total
    if (useWallet.value && walletBalance >= totalCheckoutPrice) {
      usedPointsBalance = 0; // No need to use points
      return 0; // No need to use points
    }

    // If wallet is being used but cannot fully cover the total
    if (useWallet.value && walletBalance < totalCheckoutPrice) {
      num remainingAmount = totalCheckoutPrice - walletBalance;

      // Use the lesser of remaining amount or points balance
      usedPointsBalance =  pointsBalance < remainingAmount ? pointsBalance : remainingAmount;
      return pointsBalance < remainingAmount ? pointsBalance : remainingAmount;
    }

    // If wallet is not being used, use points to cover as much of the total as possible
    usedPointsBalance =  pointsBalance < totalCheckoutPrice ? pointsBalance : totalCheckoutPrice;
    return pointsBalance < totalCheckoutPrice ? pointsBalance : totalCheckoutPrice;
  }


  void showVouchersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(getSize(20))),
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstant.white,
      builder: (BuildContext context) {
        return Padding(
          padding: getPadding(left: 20,right: 20, top: 30,bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: 
                    Icon(Icons.card_giftcard,size: getSize(100),),
                    // child: SvgPicture.asset(ImageConstant.online,
                    //   height: getSize(150),

                    ),
                  // (
                  //   imagePath: ImageConstant.online,
                  //   height: getSize(200),
                  // ),
                //),
                SizedBox(height: getSize(20)),
                MyText(
                  title: "voucherCode".tr,
                  alignRight:  Utils.checkIfArabicLocale(),
                  fontWeight: FontWeight.w600,
                  fontSize: Utils.checkIfArabicLocale()?16: 14,
                ),
                                SizedBox(height: getSize(10)),
                CustomTextFormField(

                  hintText: 'voucherCode'.tr,
                  controller: voucherCodeController,
                  textInputType: TextInputType.text,
                  validator: (val){
                    return HelperFunction.stringValidate(val??"");
                  },
                ),
                SizedBox(height: getSize(40)),
                CustomButton(
                  text: "confirmed".tr,
                  controller: btnController,
                  // prefixWidget: Padding(padding: getPadding(right: 5),child: Icon(Icons.email, color: ColorConstant.white)),
                  onTap: () async {
                    if(formKey.currentState!.validate()){
                      btnController.start();

                      Utils.check().then((value) async {
                        if (value) {
                          await BaseClient.get("${ApiUtils.checkVoucher}/code/${voucherCodeController.text}",
                              onSuccess: (response) async {
                                btnController.stop();
                                if(response.data.toString().isNotEmpty){
                                  menuController.selectedVoucher.value = VoucherModel.fromMap(response.data);
                                  Get.back();
                                  voucherCodeController.clear();
                                  update();
                                }else{
                                  Get.back();
                                  CustomSnackBar.showCustomErrorToast(message: "please_type_correct_voucher".tr);
                                }

                                return true;
                              },
                              onError: (error) {
                                voucherCodeController.clear();
                                Get.back();

                                btnController.stop();

                                BaseClient.handleApiError(error);
                                return false;
                              },
                              headers: Utils.getHeader()
                          );
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
