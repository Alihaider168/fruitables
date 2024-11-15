import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/widgets/cart_bottom.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_collapsable_widget.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_drawer.dart';

import '../controllers/main_menu_controller.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final controller = Get.put(MainMenuController());

  @override
  void initState() {
    super.initState();
    Utils.setUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: Utils.checkIfArabicLocale() ? getPadding(right: 15):getPadding(left: 15),
          child: GestureDetector(
            onTap: ()=>  controller.scaffoldKey.currentState!.openDrawer(),
            child: Icon(Icons.menu,color: ColorConstant.white,),
          ),
        ),
        leadingWidth: getSize(35),
        title: GestureDetector(
          onTap: (){
            Get.toNamed(Routes.LOCATION_SELECTION);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MyText(
                    title: !Constants.isDelivery.value ? "pickup_from".tr : "lbl_order_from".tr,
                  fontSize:Utils.checkIfArabicLocale()?11: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.white,
                  ),
                  Icon(Icons.keyboard_arrow_down,color: ColorConstant.white,size: getSize(20),)
                ],
              ),
              MyText(
                title: Constants.selectedBranch?.address??"",
                 fontSize:Utils.checkIfArabicLocale()?11: 14,
                    fontWeight: FontWeight.w600,
                color: ColorConstant.white,
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
             Get.toNamed(Routes.SEARCH);
            },
            icon: Icon(Icons.search,color: ColorConstant.white,),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body:
      Obx(()=> controller.isLoading.value ? Center(
        child: CircularProgressIndicator(),
      ):
      Padding(
        padding: getPadding(bottom: 16),
        child: Obx(()=> CustomCollapsableWidget(
          banners: controller.menuModel.value.data?.banners??[],
          header: // Horizontal ListView for categories
          Obx(()=> controller.menuModel.value.data?.categories != null && (controller.menuModel.value.data?.categories??[]).isNotEmpty ?
          Column(
            children: [
              SizedBox(height: getSize(15),),
              GridView.builder(
                padding: getPadding(right: getSize(8), left: getSize(8)),
                
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  
                  crossAxisSpacing: 2.5,
                   // Number of items per row
                  childAspectRatio:  .7,// Adjust the aspect ratio as needed
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap:true,
                
                
                itemCount: !controller.showAllCategories.value ?

                (  (controller.menuModel.value.data?.categories?.length??0) >8
                    ? 8 : (controller.menuModel.value.data?.categories?.length??0)) : (controller.menuModel.value.data?.categories??[]).length,
                // itemCount: (controller.menuModel.value.data?.categories??[]).length,
                itemBuilder: (context, index) {
                  final cat = (controller.menuModel.value.data?.categories??[])[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.CATEGORY_DETAIL,arguments: {'category':index});
                    },
                    child: Container(
                      padding: getPadding(left: 3,right: 3,top: 5,bottom:0),
                      
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImageView(
                            url:Utils.getCompleteUrl( cat.appImage?.key),
                            radius: 12,
                            // bgColor: Colors.red,
                            // url: cat.image,
                            height: getSize(75),
                            padding: getPadding(bottom: getSize(8),top: getSize(8), left: getSize(16), right: getSize(16)),
                            margin: getMargin(bottom: getSize(5)),
                            width: getSize(70),
                            
                            border: Border.all(color: ColorConstant.grayBorder.withOpacity(0.3)),
                          ),
                          MyText(
                            title: Utils.checkIfArabicLocale() ? cat.arabicName??"" : cat.englishName??"",
                            center: true,
                            fontSize:Utils.checkIfArabicLocale()?10.5: 12,
                            
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              // SizedBox(height: getSize(5),),
              if((controller.menuModel.value.data?.categories?.length??0  ) > 8)
              GestureDetector(
                onTap: (){
                  controller.showAllCategories.value = !controller.showAllCategories.value;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      title: controller.showAllCategories.value ? "hide_categories".tr : "view_all_categories".tr,
                      fontSize:Utils.checkIfArabicLocale()?11: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      width: getSize(5),
                    ),
                    Icon(!controller.showAllCategories.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),

                  ],
                ),
              )
            ],
          ): Offstage()),

          child:
          Column(
            children: [


              ListView.separated(
                itemCount: (controller.menuModel.value.data?.categories?.length??0) >5
                    ? 5 : (controller.menuModel.value.data?.categories?.length??0),
                separatorBuilder: (_,__){
                  return SizedBox(height: getSize(20),);
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final category = controller.menuModel.value.data?.categories![index];
                  final items = (controller.menuModel.value.data?.items ?? []).where((element) => category?.id == element.categoryId).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      Container(
                        padding: getPadding(left: 16, right: 16, bottom: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              title: Utils.checkIfArabicLocale() ? category?.arabicName??"" : category?.englishName??"",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),

                            Visibility(
                              visible: items.length>4,
                              child: GestureDetector(
                                onTap:(){
                                  Get.toNamed(Routes.CATEGORY_DETAIL,arguments: {'category':index});
                                },
                                child: MyText(
                                  title: 'lbl_view_all'.tr,
                                  fontSize:Utils.checkIfArabicLocale()?11: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.black.withOpacity(.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // padding: getPadding(right: 12, left: 12),
                        height: getSize(195),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (items.length>4 ? 4 : items.length),
                                itemBuilder: (context, i) {
                                    return Padding(
                                      padding: getPadding(
                                        // right:  2,
                                        right: i == 0 && Utils.checkIfArabicLocale() ? 14 : 2,
                                        left: i == 0 && !Utils.checkIfArabicLocale() ? 14 : 2,
                                      ),
                                      child: CustomItemCard(item: items[i]),
                                    );

                                },
                              ),
                              SizedBox(width: getSize(10),),
                              Visibility(
                                visible:  items.length>4,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.CATEGORY_DETAIL,arguments: {'category':index});
                                  },
                                  child: Padding(
                                    padding:getPadding(all: 16),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Icon(Icons.arrow_forward, color: ColorConstant.black.withOpacity(.6)),
                                        SizedBox(height: getSize(10),),
                                        MyText(
                                          title: 'lbl_view_all'.tr,
                                          fontSize:Utils.checkIfArabicLocale()?12: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.black.withOpacity(.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Items of the category
                      // SingleChildScrollView(
                      //   a,
                      //   child: Row(
                      //     children: [...items.map((item) => CustomItemCard(item: item))],
                      //   ),
                      // ),
                      // ...items.map((item) => CustomItemCard(item: item)),
                    ],
                  );
                },
              ),
            ],
          ),
        )),
      ),
      ),
      bottomNavigationBar: Obx(()=>  !controller.bottomBar.value  && !controller.orderAdded.value? Offstage() : CartBottom(showCurrentOrder :controller.orderAdded.value,order: controller.currentOrder.value,)),
    );
  }
}


class CustomItemCard extends StatelessWidget {
  CustomItemCard({super.key, required this.item});

  final MainMenuController controller = Get.put(MainMenuController());

  final Items item;

  RxInt quantity = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.showAddToCartItemSheet(context,item);
      },
      child: SizedBox(
        width: getSize(140),
        child: Padding(
          padding: getPadding(top: 5,right: 3,left: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getSize(135),
                height: getSize(143),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(10)),
                  color: Colors.grey.shade300.withOpacity(.3),
                  border: Border.all(color: ColorConstant.grayBorder.withOpacity(0.3)),
                ),
                // padding: getPadding(all: 5),
                child: Stack(
                  children: [

                    Center(
                      child: CustomImageView(
                        // bgColor: Colors.grey.shade300.withOpacity(.3),
                        url: Utils.getCompleteUrl(item.image?.key),
                        height: getSize(120),
                        radius: 10,
                        padding: getPadding(all:12),
                        width: getSize(140),
                        fit: BoxFit.contain,
                      ),
                    ),
                    controller.checkForDiscountedPercentage(item)!= 0 ?Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: getMargin(left: 5,top: 5),
                        padding: getPadding(left: 5,right: 5,top: 3,bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MyText(
                          title: "${controller.checkForDiscountedPercentage(item)!= 0? controller.checkForDiscountedPercentage(item).toString().split(".")[0] :""}% ${'lbl_off'.tr}",
                          fontSize:Utils.checkIfArabicLocale()?9: 9,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.white,
                        ),
                      ),
                    ) : Offstage(),
                    // Add Button
                    Positioned(
                      left: Utils.checkIfArabicLocale() ? getSize(5) : null,
                      right: Utils.checkIfArabicLocale() ? null : getSize(5),
                      bottom: getSize(5),
                      child: GestureDetector(
                        onTap: (){
                          if(!controller.checkForMultipleValues(item)){
                            String selectedSize = "small";
                            if((item.largePrice??0) != 0 ){
                              selectedSize = "large";
                            }else if((item.mediumPrice??0) != 0 ) {
                              selectedSize = "medium";
                            }else if((item.smallPrice??0) != 0 ) {
                              selectedSize = "small";
                            }

                            quantity.value += 1;
                            controller.bottomBar.value = true;
                            controller.addItemsToCart(item,size: selectedSize);
                          }else{
                            controller.showAddToCartItemSheet(context, item);
                          }

                        },
                        child: Container(
                          width: getSize(28),
                          height: getSize(28),
                          decoration: BoxDecoration(
                              color: ColorConstant.white,
                              shape: BoxShape.circle,
                            border: Border.all(color: ColorConstant.grayBorder)
                          ),
                          alignment: Alignment.center,
                          child:
                          // Obx(()=> quantity.value == 0
                          //     ?
                          Icon(Icons.add,color: ColorConstant.grayBorder,)
                              // : MyText(title: "${quantity.value}",color: ColorConstant.grayBorder,fontWeight: FontWeight.w600,)
                          // ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: getSize(8)),

              // Pricing
              RichText(
                textAlign: Utils.checkIfArabicLocale()?TextAlign.right:TextAlign.left,
                text: TextSpan(
                  
                  children: [
                    // Check if the prefix 'From' should be added
                    if (controller.checkForMultipleValues(item))
                      TextSpan(
                        text: '${'lbl_from'.tr} ', // Prefix text
                        style: TextStyle(
                          fontSize:Utils.checkIfArabicLocale()?10.5: 12,
                          fontWeight: FontWeight.w700,
                          color: controller.checkForMultipleValues(item) ? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                        ),
                      ),

                    // Display the price
                    TextSpan(
                      text: "${Utils.checkIfArabicLocale() ? "lbl_rs".tr: "lbl_rs".tr} ${controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item)? controller.checkForDiscountedPrice(item) : controller.calculatePrice(item)}  ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: controller.checkForDiscountedPrice(item) != 0? ColorConstant.primaryPink :Colors.black, // Change this to the desired color
                      ),
                    ),
                    // Conditionally show the original price if a discount is present
                    if (controller.checkForDiscountedPrice(item) != 0 && controller.checkForDiscountedPrice(item) != controller.calculatePrice(item))
                      TextSpan(
                        text: "${Utils.checkIfArabicLocale() ? "": "lbl_rs".tr} ${controller.calculatePrice(item)} ${!Utils.checkIfArabicLocale() ? "": "lbl_rs".tr} ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.textGrey, // Assuming ColorConstant is a defined color palette
                          decoration: TextDecoration.lineThrough, // Strikethrough for original price
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: getSize(0),),
              MyText(
                title: Utils.checkIfArabicLocale() ? item.name??"" : item.englishName??"",
                fontSize:Utils.checkIfArabicLocale()?11: 13,
                fontWeight: FontWeight.w400,
                color: ColorConstant.textGrey,
                line: 1,
                overflow: TextOverflow.ellipsis,
              ),


            ],
          ),
        ),
      ),
    );
  }
}

