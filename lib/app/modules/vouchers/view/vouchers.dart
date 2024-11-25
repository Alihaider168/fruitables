
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/modules/cart/controllers/cart_controller.dart';
import 'package:rexsa_cafe/app/modules/vouchers/controller/vouchersController.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VoucherScreen extends StatefulWidget {
  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final controller = Get.put(VoucherController());
  
@override
initState(){
  super.initState();
  controller.getUsedVouchers();
    controller.getVouchers();

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "vouchers".tr,fontWeight: FontWeight.bold,fontSize: 22,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: Obx(
        ()=>
        Skeletonizer(
          enabled: controller.isLoading.value,
          child: controller.isLoading.value?
        ListView.separated(
          separatorBuilder: (context,index){
            return Container(
              // height: getSize(10),
            );
          },
          itemCount: 5,
          itemBuilder: (context, index){
            VoucherModel voucher = VoucherModel(title: 'sabhjvx',
            //  minimumAmount: 342,
              discount: 34243, type: 'percentage', expiryDate: DateTime.now());
            return Padding(
              padding: getPadding(right: 16,left: 16,top: 10, bottom: 10),
              child: _buildVoucherCard(voucher),
            );
          })
        :
         Column(
          children: [
            _buildTabs(),
            Obx(
              ()=> Expanded(
              
                child:controller.currentTab.value ==0? _buildVoucherList(controller.vouchers):_buildVoucherList(controller.usedVouchers),
              ),
            ),
          ],
        ),)
      ),
    );
  }

  Widget _buildTabs() {
    return Material(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: controller.tabs.asMap().entries.map((entry) {
            return Expanded(
              child: Obx(() => _buildTab(entry.key, entry.value)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = controller.currentTab.value == index;
    
    return GestureDetector(
      onTap: () => controller.currentTab.value = index,
      child: Container(
        
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:Colors.white,

          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.pink : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getFontSize(14),
            color: isSelected ? Colors.pink : ColorConstant.textGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherList(List<VoucherModel>vouchers) {
    return Obx(() {
      return ListView.builder(
        padding:getPadding(all: 16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final voucher = vouchers[index];
          return _buildVoucherCard(voucher);
        },
      );
    });
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    return Container(
      margin: getMargin(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: getPadding(top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
        padding: getPadding(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    voucher.title??'',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${voucher.type != 'percentage' ?'SAR':''} ${voucher.discount?.toStringAsFixed(2)} ${voucher.type == 'percentage' ?'%':''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Padding(
        padding: getPadding(left: 16, right: 16),
              child: Container(
                        padding: getPadding(left: 8, right: 8,top: 3, bottom: 3),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstant.blue.withOpacity(0.2)
                ),
                child: Text(
                  voucher.code??'',
                  style: TextStyle(
                    color:  ColorConstant.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                    
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
        padding: getPadding(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  // Row(
                  //   children: [
                  //      Text(
                  //       'SAR',
                  //       style: TextStyle(
                  //         color:  ColorConstant.black,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                      // Text(
                      //   ' ${voucher.minimumAmount?.toStringAsFixed(2)} ${"minimum".tr} ',
                      //   style: TextStyle(
                      //     color:  ColorConstant.textGrey,
                      //     fontSize: 14,
                      //   ),
                      // ),
                  //   ],
                  // ),
                  InkWell(
                    onTap: (){
                      copyToClipboard(voucher.code!);
                    },
                    child: Icon(Icons.copy,color: ColorConstant.blue,size: 20,)),
                ],
              ),
            ),
            
    
            SizedBox(height: 8),
            Row(children: [
              Container(
                height: 20,
                width: 13,
                decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
              ),),
              Padding(

                padding: getPadding(right: 10, left: 10.5),
                child: DottedLine(
                  lineLength: getSize(303),
                  dashColor: Colors.grey.shade500,
                ),
              ),
               Container(
                height: 20,
                width: 13,
                decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
              ),)
            ],),
            Center(
              child: Padding(
                      padding: getPadding(top: 0, bottom: 0),
                child: Text(
                  '${"valid_until".tr} ${DateFormat('dd MMM yyyy').format(voucher.expiryDate!)}',
                  style: TextStyle(
                    color:  ColorConstant.black,
                    fontSize: 14,
                  ),
                ),
              ),
            )
           
          ],
        ),
      ),
    );
  }
  void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print('Text copied to clipboard: $text');
}
}


Widget showVoucherCard(CartController controller,VoucherModel voucher) {

    return Container(
      margin: getMargin(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: getPadding(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
        
          children: [
             Container(
          height: 15,
          width: 10,
          decoration: BoxDecoration(
          color: ColorConstant.opacBlackColor.withOpacity(.05),
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
        ),),
                          SizedBox(width: 10),
        
            Icon(Icons.card_giftcard),
            SizedBox(width: 10),
            Container(
              width: getSize(100),
              child: Text(
                "${voucher.code}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
             SizedBox(width: getSize(10)),
            InkWell(
              onTap: (){
                controller.selectedVoucher.value =null;
                
              },
              child: Text(
              "Remove",               
                style: TextStyle(
                
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  
                  color: ColorConstant.red
                ),
              ),
            ),
                        Spacer(),

            Container(
              constraints: BoxConstraints(maxWidth: getSize(100)),
               padding: getPadding(left: 8, right: 8,top: 3, bottom: 3),
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConstant.blue.withOpacity(0.2)
          ),
              child: Text(
                '${voucher.type != 'percentage' ?'SAR':''} -${voucher.discount?.toStringAsFixed(2)} ${voucher.type == 'percentage' ?'%':''}',
               
               maxLines: 1,
                style: TextStyle(
                
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  
                  color: ColorConstant.blue
                ),
              ),
            ),
            // InkWell(
            //   onTap: (){
            //     copyToClipboard(voucher.code!);
            //   },
            //   child: Icon(Icons.copy,color: ColorConstant.blue,size: 23,)),
              SizedBox(width: getSize(10),),
                    Container(
          height: 15,
          width: 10,
          decoration: BoxDecoration(
          color: ColorConstant.opacBlackColor.withOpacity(.05),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
        ),),
          ],
        ),
      ),
    );
  }