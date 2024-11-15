import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/widgets/noData.dart';

import '../controllers/addresses_controller.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // lbl_my_addresses
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_my_addresses".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body:Obx(()=> controller.addresses.isEmpty? NoData(
        svgPath: 'assets/images/address.svg',
        name: "no_address_found".tr,message: "no_address_found_desc".tr,):Padding(
        padding: getPadding(
            top: 15,bottom: 15
        ),
        child: Obx(()=> ListView.separated(
            itemCount: controller.addresses.length,
            separatorBuilder: (_,__){
              return Divider();
            },
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  if(controller.fromCheckout){
                    Get.back(result: controller.addresses[index].address);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ColorConstant.textGrey.withOpacity(.4)))),
                  padding: getPadding(left: 0,top: 5,bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: getPadding(top: 5),
                        alignment: Alignment.topCenter,
                        height:getSize(70),
                        width:getSize(50),child: Icon(Icons.location_on_outlined, color: ColorConstant.textGrey,size: getSize(23),),),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            // Text("${address.label??""}",
                            
                            // style: TextStyle(
                            //   fontWeight: FontWeight.w600,fontSize: getFontSize(13),
                              

                            // ),),
                            Text("${"address".tr}: ${address.address??""}",style: TextStyle( 
                              fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                              color: ColorConstant.textGrey,
                              height: 1.2
                              

                            ),),
                            Text( "${"note_to_rider".tr}: ${address.street!= null ? "${address.street}, " : ""}${address.floor??""}",style: TextStyle( 
                              fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                              color: ColorConstant.textGrey,
                              height: 1.2
                              

                            )),
                          ],
                        ),
                      ),
                      controller.fromCheckout ? Offstage() : IconButton(
                        onPressed: (){
                          controller.showDeleteAddressDialog(context,index);
                        },
                        icon: Icon(Icons.edit_outlined,color: ColorConstant.primaryPink,),
                      ),

                      controller.fromCheckout ? Offstage() : IconButton(
                        onPressed: (){
                          controller.showDeleteAddressDialog(context,index);
                        },
                        icon: Icon(Icons.delete_outline_outlined,color: ColorConstant.primaryPink,),
                      )
                    ],
                  ),
                ),
              );
            }
        )),
      )),
      bottomNavigationBar: Container(
          width: size.width,
          height: size.height*0.12,
          padding: getPadding(left: 16,right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSize(20)),
              topRight: Radius.circular(getSize(20)),
            ),
            boxShadow: [
              // Top shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, -4), // Move shadow upwards
              ),
              // Left shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(-4, 0), // Move shadow to the left
              ),
              // Right shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Card-like shadow color
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(4, 0), // Move shadow to the right
              ),
            ],
          ),
          child: Center(
            child: CustomButton(
              controller: controller.btnController,
              onTap: (){
                Get.toNamed(Routes.ADD_ADDRESS)!.then((addedAddress){
                  if(addedAddress != null){
                    String? address = addedAddress["address"];
                    String? street = addedAddress["street"];
                    String? floor = addedAddress["floor"];
                    String? label = addedAddress["label"];
                    controller.addAddress(label: label.toString().capitalizeFirst,floor: floor,street: street,address: address);
                  }
                });
              },
              prefixWidget: Padding(
                padding: getPadding(right: 5),
                child: Icon(
                  Icons.add,color: ColorConstant.white,
                ),
              ),
              text: "lbl_add_address".tr,
            ),
          ),
        )
    );
  }
}
