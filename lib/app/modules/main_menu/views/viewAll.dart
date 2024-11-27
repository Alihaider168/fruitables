import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';
import 'package:rexsa_cafe/app/modules/category_detail/views/category_detail_view.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';

class ViewAllScreen extends StatefulWidget {
  final HomePageWidgets homePageWidget;
    final MainMenuController controller;
  const ViewAllScreen({super.key, required this.homePageWidget, required this.controller});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: Utils.checkIfArabicLocale()?widget.homePageWidget.title:widget.homePageWidget.englishName,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body:  ListView.builder(
        itemCount: widget.controller.getProductsIds(widget.homePageWidget.products).length,
        itemBuilder: (context, index) {
          print("main ${widget.homePageWidget.products.length}");
List<Items> items = widget.controller
    .getProductsIds(widget.homePageWidget.products)
    .cast<Items>();      
    print(items.length);    
    final item =items[index];

          return ItemWidget(
            item:item,fromFav: false,
            onFavTap: (){
             
            },

          );
        },
      ),
            bottomNavigationBar: Obx(()=>  !widget.controller.bottomBar.value  && !widget.controller.orderAdded.value? Offstage() : CartBottom(showCurrentOrder :widget.controller.orderAdded.value,order: widget.controller.currentOrder.value,ordersLength:widget. controller.ordersLenght.value-1   ,)),

    );
  }
}