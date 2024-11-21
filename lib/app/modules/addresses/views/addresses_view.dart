import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/noData.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      body:Obx(
         ()=> Skeletonizer(
           enabled: controller.isloading.value,
           child: Obx(()=> !controller.isloading.value&&  controller.addresses.isEmpty? NoData(
        svgPath: 'assets/images/address.svg',
        name: "no_address_found".tr,message: "no_address_found_desc".tr,): controller.isloading.value?ListView.separated(
               itemCount: 10,
               separatorBuilder: (_,__){
                 return Container();
               },
               itemBuilder: (context, index) {
                 return Container(
                   decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ColorConstant.textGrey.withOpacity(.4)))),
                   padding: getPadding(left: 0,top:10,bottom: 10),
                   child: Row(
                     children: [
                     Container(
                                       margin: getMargin(all: 10),
                                       padding: getPadding(all: 8),
                                       decoration: BoxDecoration(
                                         color:  ColorConstant.white,
                                           shape: BoxShape.circle,
                                           border: Border.all(color: ColorConstant.textGrey)
                                       ),
                                       child: CustomImageView(
                                         imagePath: ImageConstant.other,
                                         height: getSize(15),
                                         width: getSize(15),
                                         
                                       ),
                                     ),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             
                             // Text("${address.label??""}",
                             
                             // style: TextStyle(
                             //   fontWeight: FontWeight.w600,fontSize: getFontSize(13),
                               
                            
                             // ),),
                             Text("Dummy address abcd efgh ijk lmnop qrst uvwxyz",style: TextStyle( 
                               fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                               color: ColorConstant.black,
                               height: 1.2
                               
                            
                             ),),
                             
                             Row(
                               children: [
                                 Text( "Street :",style: TextStyle( 
                                   fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                   color: ColorConstant.textGrey,
                                   height: 1.2
                                   
                                 
                                 )),
                                 Text( "123",style: TextStyle( 
                                   fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                   color: ColorConstant.black,
                                   height: 1.2
                                   
                                 
                                 )),
                               ],
                             ),
                           
                             Row(
                               children: [
                                     Text( "Floor :",style: TextStyle( 
                                   fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                   color: ColorConstant.textGrey,
                                   height: 1.2
                                   
                                 
                                 )),
                                 Text(  "example floor",style: TextStyle( 
                                   fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                   color: ColorConstant.black,
                                   height: 1.2
                                   
                                 
                                 )),
                               ],
                             ),
                           ],
                         ),
                       ),
                     
                            
                       IconButton(
                         onPressed: (){
                         },
                         icon: Icon(Icons.delete_outline_outlined,color: ColorConstant.primaryPink,),
                       )
                     ],
                   ),
                 );
               }
           )
            :ListView.separated(
               itemCount: controller.addresses.length,
               separatorBuilder: (_,__){
                 return Container();
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
                     padding: getPadding(left: 0,top:10,bottom: 10),
                     child: Row(
                       children: [
                       Container(
                                         margin: getMargin(all: 10),
                                         padding: getPadding(all: 8),
                                         decoration: BoxDecoration(
                                           color:  ColorConstant.white,
                                             shape: BoxShape.circle,
                                             border: Border.all(color: ColorConstant.grayBorder)
                                         ),
                                         child: CustomImageView(
                                           imagePath: address.label?.toLowerCase() =="home"?   ImageConstant.home:address.label?.toLowerCase() =="work"?ImageConstant.work:
                                           address.label?.toLowerCase() =="partner"?   ImageConstant.partner:ImageConstant.other,
                                           height: getSize(15),
                                           width: getSize(15),
                                         ),
                                       ),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               
                               // Text("${address.label??""}",
                               
                               // style: TextStyle(
                               //   fontWeight: FontWeight.w600,fontSize: getFontSize(13),
                                 
           
                               // ),),
                                      Container(
                                        width: double.infinity,
                                        child: Container(
                                         width:getSize(250),
                                          child: Text(address.address.toString(),style: TextStyle( 
                                          fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                          color: ColorConstant.black,
                                          height: 1.2,                                                   
                                                                                                                 ),),
                                        ),
                                      ),
                              
                               if(
                                 address.street!= null 
                               )
                                Row(
                                 children: [
                                   Text( "${"street".tr} ",style: TextStyle( 
                                     fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                     color: ColorConstant.textGrey,
                                     height: 1.2
                                     
                                   
                                   )),
                                   Text( address.street.toString(),style: TextStyle( 
                                     fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                     color: ColorConstant.black,
                                     height: 1.2
                                     
                                   
                                   )),
                                 ],
                               ),
                               if(
                                 address.floor!= null 
                               )
                               Row(
                                 children: [
                                       Text( "${"floor".tr} ",style: TextStyle( 
                                     fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                     color: ColorConstant.textGrey,
                                     height: 1.2
                                     
                                   
                                   )),
                                   Text(  address.floor.toString(),style: TextStyle( 
                                     fontWeight: FontWeight.w400,fontSize: getFontSize(12),
                                     color: ColorConstant.black,
                                     height: 1.2
                                     
                                   
                                   )),
                                 ],
                               ),
                             ],
                           ),
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
         ),
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
        backgroundColor: ColorConstant.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(50))
        ),
        child: Icon(Icons.add,color: ColorConstant.white,),
      ));
  
      // bottomNavigationBar: Container(
      //     width: size.width,
      //     height: size.height*0.12,
      //     padding: getPadding(left: 16,right: 16),
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(getSize(20)),
      //         topRight: Radius.circular(getSize(20)),
      //       ),
      //       boxShadow: [
      //         // Top shadow
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.3), // Card-like shadow color
      //           spreadRadius: 1,
      //           blurRadius: 8,
      //           offset: Offset(0, -4), // Move shadow upwards
      //         ),
      //         // Left shadow
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.3), // Card-like shadow color
      //           spreadRadius: 1,
      //           blurRadius: 8,
      //           offset: Offset(-4, 0), // Move shadow to the left
      //         ),
      //         // Right shadow
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.3), // Card-like shadow color
      //           spreadRadius: 1,
      //           blurRadius: 8,
      //           offset: Offset(4, 0), // Move shadow to the right
      //         ),
      //       ],
      //     ),
      //     child: Center(
      //       child: CustomButton(
      //         controller: controller.btnController,
      //         onTap: (){
      //           Get.toNamed(Routes.ADD_ADDRESS)!.then((addedAddress){
      //             if(addedAddress != null){
      //               String? address = addedAddress["address"];
      //               String? street = addedAddress["street"];
      //               String? floor = addedAddress["floor"];
      //               String? label = addedAddress["label"];
      //               controller.addAddress(label: label.toString().capitalizeFirst,floor: floor,street: street,address: address);
      //             }
      //           });
      //         },
      //         prefixWidget: Padding(
      //           padding: getPadding(right: 5),
      //           child: Icon(
      //             Icons.add,color: ColorConstant.white,
      //           ),
      //         ),
      //         text: "lbl_add_address".tr,
      //       ),
      //     ),
      //   )
    
  }
}
