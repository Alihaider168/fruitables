import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,)),
        title: MyText(title: "Cart",color: ColorConstant.white,fontSize: 22,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
      body: Padding(
        padding: getPadding(all: 16),
        child: Column()
      ),
    );
  }
}
