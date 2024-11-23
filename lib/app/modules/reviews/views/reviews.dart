import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/modules/reviews/controller/reviewsController.dart';

class ReviewsScreen extends StatefulWidget {
  final Orders order;
  const ReviewsScreen({super.key, required this.order});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final ReviewsController controller = ReviewsController();
  RxBool ratingRequired = false.obs;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },
          icon: Icon(Icons.arrow_back_ios,color: ColorConstant.white,),
        ),
        title: MyText(title: "lbl_reviews".tr,fontSize: 18,fontWeight: FontWeight.bold,color: ColorConstant.white,),
        centerTitle: true,
      ),
      body: Obx(
        ()=> SafeArea(child:
        controller.successful.value?Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
               margin: getMargin(left: 15, right: Utils.checkIfArabicLocale()?15:0),
              width: double.infinity,
              alignment: Alignment.center,
              child: SvgPicture.asset('assets/images/successful.svg', height: getSize(150),width: getSize(150),)),
               Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: MyText(title: "review_submitted".tr, fontWeight: FontWeight.bold,)),
              SizedBox(height: getSize(100),)
          ],
        ):
         Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
        
        
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         SizedBox(height: getSize(15)),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        child: MyText(title: "how_was_your_last_order?".tr, fontWeight: FontWeight.w600,fontSize: getFontSize(18),)),
                      
                                                      SizedBox(height: getSize(15)),
                       Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                         
                              color: Colors.grey.shade300
                           
                          )
                        ),
                                                margin: getMargin(right: 16, left: 16),

                        padding: getPadding(right: 16, left: 16, top: 16, bottom: 16),
                         child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomImageView(
                                    url: Utils.getCompleteUrl(widget.order.branch?.image?.key??""),
                                    height: getSize(95),
                                    width: getSize(100),
                                    fit: BoxFit.cover,
                                    radius: getSize(8),
                                  ),
                                  SizedBox(width: getSize(12)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(title:
                                     Utils.checkIfArabicLocale()?   widget.order.branch?.name??"":widget.order.branch?.englishName??'',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                       
                                        ),
                                  
                                       
                                        SizedBox(height: getSize(4)),
                                        MyText(title:
                                        Utils.checkIfArabicLocale()?(widget.order.products??[]).map((element)=> element.arabicName.toString()).join(", "): (widget.order.products??[]).map((element)=> element.name.toString()).join(", ")
                                         , fontSize: 12,
                                          alignRight: Utils.checkIfArabicLocale() ?true:null,
                                          color: Colors.grey.shade700.withOpacity(.8),
                                          line: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    
                                       
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                       ),
                      
                  
                      
                           Container(
                            margin: getMargin(all: 16),
                            padding: getPadding(all: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade300)
                              
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 MyText(title: "whats_your_rate".tr, fontWeight: FontWeight.w600,),
                                                  SizedBox(height: getSize(10)),
                  
                                RatingBar.builder(
                            initialRating: controller.rating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            updateOnDrag: true,
                            
                            
                            itemSize: getSize(45),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                ratingRequired.value = false;
                                controller.rating.value= rating.toDouble();
                                print(controller.rating.value);
                              });
                            },
                          ),
                         Obx(()=>
                           ratingRequired.value ?
                         
                          SizedBox(height: getSize(10)):SizedBox()),
                        Obx(()=>
                        ratingRequired.value ?
                         MyText(title: 'rating_required'.tr, fontSize: 12, color:Colors.red ,):SizedBox()),
                      
                      
                                                               SizedBox(height: getSize(20)),
                            MyText(title: "write_your_review".tr, fontWeight: FontWeight.w600,),
                                                  SizedBox(height: getSize(10)),
                          TextFormField(
                            controller: controller.reviewsController,
                  
                            decoration: InputDecoration(
                            
                              hintText: 'would_you_like_to_write'.tr,
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                               border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstant.textGrey),
                  
                                
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: ColorConstant.textGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: ColorConstant.textGrey, width: 1.0),
                          ),
                        
                            ),
                            minLines: 4,
                            maxLines: 10,
                          )
                              ],
                            ),
                           )
                  
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              ()=> Padding(
                padding:getPadding(all: 16),
                child: CustomButton(
                  prefixWidget:controller.isLoading.value ? Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    
                    ),
                  ):null,
                  text: "Submit",onTap: (){
                  if(controller.rating.value == 0){
                    ratingRequired.value  = true;
                  }
                  if(controller.formKey.currentState!.validate() && controller.rating.value != 0 ){
                    
                    
                    controller.submitRating(widget.order.customer?.name??"",widget.order.customer?.email??"",
                    widget.order.customer?.mobile??"",widget.order.branch?.id??"",widget.order.id??""
                    );
                
                  }
                },),
              ),
            )
          ],
        )),
      ),
    );
    
  }
}