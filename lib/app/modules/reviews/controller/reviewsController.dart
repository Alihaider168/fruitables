import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/modules/main_menu/views/main_menu_view.dart';
import 'package:rexsa_cafe/app/modules/orders/controllers/orders_controller.dart';

class ReviewsController extends GetxController{
  TextEditingController reviewsController = TextEditingController();
  final OrdersController ordersController  = OrdersController();


    final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  RxDouble rating = 1.0.obs;
  RxBool isLoading = false.obs;
    RxBool successful= false.obs;




  submitRating(String name, String email, String phone, String branchId, String orderId,){
     Utils.check().then((value) async {
      if (value) {
        isLoading.value = true;
        await BaseClient.post(ApiUtils.submitReview,
            onSuccess: (response) async {
                      isLoading.value = false;
                      successful.value = true;
                         Future.delayed(Duration(seconds: 2),(){
                                                            successful.value = false;
                                                            Get.offAll(MainMenuView());
                                                          });

             
              return true;
            },
            onError: (error) {
              print(error.message);
                                    isLoading.value = false;
                                                          successful.value = false;
                                                       




              BaseClient.handleApiError(error);
              return false;
            },
            data: {
              'name':name,
              'email':email,
              'phone':phone,
              'date':DateTime.now().toString(),
              'review':reviewsController.text,
              'rating':rating.value,
              'branch':branchId,
              'order':orderId
            },
            headers: Utils.getHeader()
        );
      }
    });
  }
}