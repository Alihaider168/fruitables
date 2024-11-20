import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class NewDetailController extends GetxController with GetSingleTickerProviderStateMixin{

  MainMenuController menuController = Get.put(MainMenuController());
  Orders? order;
  bool fromOrder = false;
    late Animation<double> animation;
      late AnimationController _controller;



  @override
  void onInit() {
       _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Repeats the animation indefinitely
print("onit is called");

    animation = Tween<double>(begin: -50, end: 50).animate(_controller); 
    var data = Get.arguments;
    print(data);
    if(data != null && data['order']!=null){
      order = data['order'];
    }
    if(data != null && data['from_order']!=null){
      fromOrder = data['from_order'];
    }
     // Repeats the animation indefinitely

    super.onInit();
  }

}
