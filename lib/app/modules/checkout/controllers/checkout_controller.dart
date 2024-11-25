import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart' as intl;
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
// import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/data/utils/Shared_prefrences/app_prefrences.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

import '../../../data/core/app_export.dart';

class CheckoutController extends GetxController {

  num? usedPointsBalance;
  num? usedWalletBalance;
    String? voucherCode;
  num? voucherAmount;
  AppPreferences appPreferences = AppPreferences();


  MainMenuController menuController = Get.put(MainMenuController());
  RxBool instructions = false.obs;

  RoundedLoadingButtonController checkoutController = RoundedLoadingButtonController();

  // TextEditingController addressController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  RxString selectedAddress= "".obs;
  RxString selectedMethod = "".obs;
  RxString selectedTime = "".obs;

  RxInt selectedDayIndex = 0.obs;
  RxInt selectedHourIndex = 0.obs;
  RxInt selectedMinuteIndex = 0.obs;
Rxn<VoucherModel> voucher = Rxn<VoucherModel>();
 

  List<String> days = [
    "today".tr,
    intl.DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 1))),
    intl.DateFormat('EEE MMM d').format(DateTime.now().add(Duration(days: 2))),
  ];

  void removeThings(){
    usedPointsBalance = null;
    usedWalletBalance = null;
  }

  @override
  void onInit(){
    var data = Get.arguments;
    if(data != null && data["usedWalletBalance"]!= null){
      usedWalletBalance = data["usedWalletBalance"];
    }else{
      usedWalletBalance = null;
    }
    if(data != null && data["usedPointsBalance"]!= null){
      usedPointsBalance = data["usedPointsBalance"];
    }else{
      usedPointsBalance = null;
    }
     if(data != null && data["voucher"]!= null){
      voucher.value = data["voucherCode"];
    }else{
      voucher.value = null;
    }
     

    super.onInit();

  }



  List<int> getHours() {
    if (selectedDayIndex.value == 0) {
      return List.generate(24 - DateTime.now().hour, (index) => DateTime.now().hour + index);
    } else {
      return List.generate(24, (index) => index);
    }
  }

  List<int> getMinutes() {
    if (selectedDayIndex.value == 0 && selectedHourIndex.value == 0) {
      int startingMinute = (DateTime.now().minute ~/ 10 + 1) * 10;
      return List.generate((60 - startingMinute) ~/ 10, (index) => startingMinute + index * 10);
    } else {
      return List.generate(6, (index) => index * 10); // Minutes in increments of 10
    }
  }

  void showDeliveryTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: getPadding(all: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()=> Get.back(),
                    child: MyText(title: "cancel".tr,
                      color: ColorConstant.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      selectedTime.value = "${days[selectedDayIndex.value]}, ${(getHours()[selectedHourIndex.value]).toString().padLeft(2, '0')}:${getMinutes()[selectedMinuteIndex.value].toString().padLeft(2, '0')}";
                      Get.back();
                    },
                    child: MyText(title: "lbl_done".tr,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.blue,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    // Day picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedDayIndex.value = index;
                          selectedHourIndex.value = 0;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: days.length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedDayIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              days[index],
                                fontSize: 18,
                                color: index == selectedDayIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      ),
                    ),
                    // Hour picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedHourIndex.value = index;
                          selectedMinuteIndex.value = 0;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getHours().length,
                          builder: (context, index) {
                            return Obx(()=>  Container(
                              color: index == selectedHourIndex.value ? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getHours()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedHourIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                    // Minute picker
                    Expanded(
                      child: Obx(()=> ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          selectedMinuteIndex.value = index;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: getMinutes().length,
                          builder: (context, index) {
                            return Obx(()=> Container(
                              color: index == selectedMinuteIndex.value? Colors.grey[300] : Colors.transparent,
                              alignment: Alignment.center,
                              child: MyText(title:
                              getMinutes()[index].toString().padLeft(2, '0'),
                                fontSize: 18,
                                color: index == selectedMinuteIndex.value ? Colors.black : Colors.grey,
                              ),
                            ));
                          },
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<dynamic> addOrder({String? paymentId,String? paymentMethod}) async {
    await menuController.cart.loadCartFromPreferences();
    Utils.check().then((value) async {
      if (value) {
        checkoutController.start();
        List<Map<String, dynamic>> products = [];

        for(int i=0;i<menuController.cart.items.length;i++){
          final cItem = menuController.cart.items[i];
          products.add({
            "productId": cItem.item.id,
            "name":   cItem.item.englishName,
            "arabicName":cItem.item.name,
            "size": cItem.size,
            "quantity": cItem.quantity,
            "price": menuController.cart.getPrice(cItem)
          });
        }



        await BaseClient.post(ApiUtils.addOrder,
            onSuccess: (response) async {
              checkoutController.stop();
              print(response);
              CustomSnackBar.showCustomToast(message: "order_created".tr);
              Get.back();
              menuController.currentOrderForReview = Orders.fromJson(response.data);
              appPreferences.setCurrentOrder(data: jsonEncode(response.data));// menuController.pendingOrders.add(Orders.fromJson(response.data));
              // menuController.saveOrders();
              Get.toNamed(Routes.NEW_DETAIL,arguments: {'order': Orders.fromJson(response.data),"from_order": true});
              menuController.cart.clearCart();
              menuController.bottomBar.value = false;
              menuController.orderAdded.value = true;

              return true;
            },
            onError: (error) {
              checkoutController.stop();
              BaseClient.handleApiError(error);
              return false;
            },
            headers: Utils.getHeader(),
            data: {
              "branch": Constants.selectedBranch?.id,
              "paymentId": paymentId??"",
              "payableAmount": getFinalPrice(),
              "usedPointsBalance": "${usedPointsBalance??0}",
              "usedWalletBallance": "${usedWalletBalance??0}",
              "paymentMethod": paymentMethod,
              "pickupTime": Constants.isDelivery.value ? null : selectedTime.value,
              "totalAmount": menuController.cart.getTotalDiscountedPrice() + menuController.cart.getTax() + (Constants.isDelivery.value ? Constants.DELIVERY_FEES : 0),
              "tax": menuController.cart.getTax(),
              "type" : Constants.isDelivery.value ? "delivery" : "pickup",
              "address": selectedAddress.value,
              "instructions" : instructionsController.text,
              "discount": menuController.cart.getTotalDiscountForCart(),
              "products": products,
              'voucherId':voucher.value?.code,
              'voucherAmount':voucher.value != null? calculateVoucherAmount(voucher.value!, getFinalPrice()):null,


            });
      }
    });
  }


  Future<void> startPayment(BuildContext context,{required num amount}) async {
    try {
      checkoutController.start();
      MFInitiatePaymentRequest request = MFInitiatePaymentRequest(
        invoiceAmount: amount, currencyIso: MFCurrencyISO.SAUDIARABIA_SAR,
      );
      await MFSDK
          .initiatePayment(request, Utils.checkIfArabicLocale() ? MFLanguage.ARABIC : MFLanguage.ENGLISH)
          .then((value) {
        checkoutController.stop();
        debugPrint(value.toString());
        showCardsDialog(value.paymentMethods??[],amount: amount);

        // executePayment(value.paymentMethods![0].paymentMethodId);
      })
          .catchError((error)  {
        checkoutController.stop();
        final MFError er= error;
        CustomSnackBar.showCustomErrorToast(message: er.toJson().toString());
        log("fatoorah error $error");
      });
      // PaymentResponse response =  await MyFatoorah.startPayment(
      //   context: context,
      //   // afterPaymentBehaviour: AfterPaymentBehaviour.AfterCallbackExecution,
      //   // showServiceCharge: true,
      //   onResult: (res){
      //     if(res.isSuccess){
      //       addOrder(paymentId: res.paymentId,paymentMethod: "card");
      //     }else{
      //       CustomSnackBar.showCustomErrorToast(message: "Something went wrong");
      //     }
      //   },
      //   request: MyfatoorahRequest.live(
      //     currencyIso: Country.SaudiArabia,
      //     // successUrl: '',
      //     successUrl: 'https://rexsacafe.com/payment-status?status=success',
      //     errorUrl: 'https://rexsacafe.com/payment-status?status=error',
      //     // errorUrl: '',
      //     invoiceAmount: amount.toDouble(),
      //     language: Utils.checkIfArabicLocale() ? ApiLanguage.Arabic : ApiLanguage.English,
      //     customerMobile: Constants.userModel?.customer?.mobile,
      //     customerEmail: Constants.userModel?.customer?.email,
      //     customerName: Constants.userModel?.customer?.name,
      //     token: Constants.fatoorahToken,
      //     // token: 'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
      //   ),);
      // print("payment test: "+response.toString());
      // if(response.status == PaymentStatus.Success){
      //   addOrder(paymentId: response.paymentId,paymentMethod: "card");
      // }else{
      //   CustomSnackBar.showCustomErrorToast(message: "Something went wrong");
      // }
    } catch (e) {
      print('Error: $e');
    }

  }


  num getFinalPrice(){
    num price = menuController.cart.getTotalDiscountedPrice() + menuController.cart.getTax() + (Constants.isDelivery.value ? Constants.DELIVERY_FEES : 0);
    return price -(usedPointsBalance??0) - (usedWalletBalance??0);
  }


  showCardsDialog(List<MFPaymentMethod> cards, {required num amount}){
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(10)),
        ),
        child: Container(
          padding: getPadding(top: 15,bottom: 15),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400, // Set the max height for the dialog
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(title: "$amount",fontSize: 16,fontWeight: FontWeight.bold,),
                SizedBox(height: getSize(10),),
                Expanded(
                  child: ListView.separated(
                    itemCount: cards.length, // Number of items in the list
                    separatorBuilder: (_,__){
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                          executePayment(cards[index].paymentMethodId,amount: amount);
                        },
                        leading: CustomImageView(
                          url: cards[index].imageUrl,
                          height: getSize(30),
                        ),
                        title: MyText(title: Utils.checkIfArabicLocale() ? cards[index].paymentMethodAr??"" : cards[index].paymentMethodEn??"",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  executePayment(int? paymentMethodId,{required num amount}) async {
    MFExecutePaymentRequest request = MFExecutePaymentRequest(invoiceValue: amount,
      customerName: Constants.userModel?.customer?.name,
      customerMobile: Constants.userModel?.customer?.mobile,
      customerEmail: Constants.userModel?.customer?.email,
    );
    request.paymentMethodId = paymentMethodId;

    await MFSDK
        .executePayment(request, Utils.checkIfArabicLocale() ? MFLanguage.ARABIC : MFLanguage.ENGLISH, (invoiceId) {
      debugPrint(invoiceId);

    })
        .then((value) {
      debugPrint(value.toString());
      Get.back();
      if((value.invoiceStatus??"").toLowerCase() == "paid"){
        addOrder(paymentId: value.invoiceId.toString(),paymentMethod: "card");
      }else{
        CustomSnackBar.showCustomErrorToast(message: "Something went wrong");
      }
    })
        .catchError((error)  {
      debugPrint(error.message);
    });
  }



}
double calculateVoucherAmount(VoucherModel voucher,num totalAmount){
  double? amount =0.0;
    if(voucher.type == 'percentage'){
      amount = (totalAmount *voucher.discount! ) /100;


  }else{
          amount =voucher.discount!;


  }
  return amount;



}