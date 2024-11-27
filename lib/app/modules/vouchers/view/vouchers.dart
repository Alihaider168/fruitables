
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/vouchersMode.dart';
import 'package:rexsa_cafe/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:rexsa_cafe/app/modules/main_menu/controllers/main_menu_controller.dart';
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
      backgroundColor: Colors.white,
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
              
                child:
                !controller.isLoading.value && (controller.currentTab.value ==0? controller.vouchers.isEmpty:controller.usedVouchers.isEmpty)?
        
        Container(
          color: Colors.white,
          padding: getPadding(all: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard_outlined, size: getSize(120),),
               SizedBox(
                height: getSize(20)),
            MyText(
              title: 
              'no_voucher_found'.tr,
              fontWeight: FontWeight.bold,
              // textAlign: TextAlign.center,
              
                    fontSize:
                      getSize(20),
                 ),
            
            SizedBox(
                height:  getSize(5)),
            Container(
              width:  getSize(600),
              alignment: Alignment.center,
              child: Text(
                "no_voucher_Subheading".tr,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ColorConstant.textGrey,
                    fontSize: getSize(16)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: getSize(100)),
          
          
          ],),
        ):
                controller.currentTab.value ==0? _buildVoucherList(controller.vouchers):_buildVoucherList(controller.usedVouchers),
              ),
            ),
          ],
        ),)
      ),
    );
  }

  Widget _buildTabs() {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10.0), 
    shadowColor: Colors.grey.shade300,
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
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getFontSize(14),
            color: isSelected ? Colors.black : ColorConstant.textGrey,
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
           margin: getMargin(bottom: 15)
,
      child: Material(
          elevation: 3,
        borderRadius: BorderRadius.circular(10.0), 
      shadowColor: Colors.grey.shade300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width *.55,
                        child: Text(

                          voucher.title??'',
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
                      Row(
                        children: [
                           Text(
                            'SAR',
                            style: TextStyle(
                              color:  ColorConstant.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' ${voucher.minimumAmount?.toStringAsFixed(2)} ${"minimum".tr} ',
                            style: TextStyle(
                              color:  ColorConstant.textGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          copyToClipboard(voucher.code!);
                          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('code_copied'.tr),
          duration: Duration(seconds: 2),
        ),
      );
                        },
                        child: Icon(Icons.copy,color: ColorConstant.blue,size: 20,)),
                    ],
                  ),
                ),
                
        
                SizedBox(height: 8),
                Center(
                  child: Padding(
                  
                    padding: getPadding(right: 10, left: 10, top: 10, bottom: 10),
                    child: DottedLine(
                      lineLength: getSize(303),
                      dashColor: Colors.grey.shade500,
                    ),
                  ),
                ),
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
        ),
      ),
    );
  }
  void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print('Text copied to clipboard: $text');
}
}


Widget showVoucherCard(VoucherModel? voucher,num totalAmount,Function setState) {
 final  MainMenuController menuController = Get.put(MainMenuController());
    return Container(
      margin: getMargin(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: getPadding(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
        
          children: [        
            Icon(Icons.card_giftcard),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                // width: getSize(100),
                child: Text(
                  "${voucher?.code ?? ''}",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,

                    
                  ),
                ),
              ),
            ),
             SizedBox(width: getSize(10)),
            InkWell(
              onTap: (){
                menuController.selectedVoucher = Rxn<VoucherModel>();
                Future.delayed(Duration(milliseconds: 500),(){
                  setState();
                });
                
              },
              child: Text(
              "remove".tr,               
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  
                  color: ColorConstant.red
                ),
              ),
            ),
            SizedBox(width: getSize(10),),
            Container(
              constraints: BoxConstraints(maxWidth: getSize(100)),
               padding: getPadding(left: 8, right: 8,top: 3, bottom: 3),
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConstant.blue.withOpacity(0.2)
          ),
              child: Text(
                '${'SAR'} ${calculateVoucherAmount(voucher, totalAmount) >0?"-":"" }${calculateVoucherAmount(voucher, totalAmount).toStringAsFixed(2)}',
               
               maxLines: 1,
                style: TextStyle(
                
                  fontSize: 13,
                  // fontWeight: FontWeight.w600,
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
                    
          ],
        ),
      ),
    );
  }