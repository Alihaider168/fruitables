import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/utils/language_utils.dart';
import 'package:video_player/video_player.dart';

import '../controllers/language_selection_controller.dart';

class LanguageSelectionView extends StatefulWidget {
  const LanguageSelectionView({super.key});

  @override
  State<LanguageSelectionView> createState() => _LanguageSelectionViewState();
}

class _LanguageSelectionViewState extends State<LanguageSelectionView> {
      LanguageSelectionController controller = Get.put(LanguageSelectionController());
        late VideoPlayerController videoController;

    
  @override
  void initState() {
    super.initState();  
     videoController = VideoPlayerController.network(
      'https://video-previews.elements.envatousercontent.com/5cb483f5-5bb9-4837-9c2b-2d5608be41f4/watermarked_preview/watermarked_preview.mp4', // Replace with your video URL
    )
      ..initialize().then((_) {
        // Ensure the video is looped and starts playing
        videoController.setLooping(true);
        videoController.play();
        setState(() {
          
        });
        
       // Refresh the UI once the video is initialized
      });
    var data = Get.arguments;
    if(data!= null && data["from_menu"] != null){
      controller.fromMenu = data['from_menu'];
    }

  }
  @override
  Widget build(BuildContext context) {
    Utils.hideKeyboard(context);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor:  ColorConstant.blackShaded,
      statusBarIconBrightness: Brightness.light,     // White icons on status bar
      systemNavigationBarColor: Colors.white,        // Black navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      // backgroundColor: Colors.orange.shade400.withOpacity(0.5),
      
      // backgroundColor: const Color(0xFFf0f8ff),
      body: Container(
      color:  Colors.grey.shade200,
        child: SafeArea(
          child: Stack(
            children: [
                Obx(
                  ()=> Container(
                    color: controller.isLoading.value ?Colors.black:Colors.black,
                               width: double.infinity,
                               height: double.infinity,
                               child: videoController.value.isInitialized
                    ? VideoPlayer(videoController)
                    : Center(),
                             ),
                ),
               
              Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: getPadding(left: 25,right: 25,bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: getSize(30),),
                      
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: getSize(60),
                        child: Image.asset(
                           ImageConstant.logo2,
                          height: getSize(20),
                        ),
                      ),
                      SizedBox(height: getSize(20),),
                      const MyText(title: "Welcome to Rexsa Cafe",fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,),
                      const MyText(title: "مرحبًا بكم في ريكسا كافيه",fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white,),
                      SizedBox(height: getSize(15),),
                      // Spacer(),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     MyText(title: "Country",fontWeight: FontWeight.bold,fontSize: 15,),
                      //     MyText(title: "دولة",fontWeight: FontWeight.bold,fontSize: 15,),
                      //   ],
                      // ),
                      // SizedBox(height: getSize(8),),
                      // Obx(()=> mainWidget(
                      //   isSelected: controller.selectedCountry.value == 0,
                      //   title: "Saudi Arabia - السعودية",
                      //   image: ImageConstant.saudia,
                      //   index: 0,
                      //   groupValue: controller.selectedCountry.value,
                      //   onTap: (){
                      //     controller.selectedCountry.value = 0;
                      //   }
                      // )),
                      SizedBox(height: getSize(20),),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(title: "Language",fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white,),
                          MyText(title: "لغة",fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white,),
                        ],
                      ),
                      SizedBox(height: getSize(8),),
                      Obx(()=> mainWidget(
                                                context: context,

                          isSelected: controller.selectedLanguage.value == 0,
                          title: "العربية",
                          index: 0,
                          groupValue: controller.selectedLanguage.value,
                          onTap: (){
                            controller.selectedLanguage.value = 0;
                          }
                      )),
                      SizedBox(height: getSize(10),),
                      Obx(()=> mainWidget(
                                                context: context,

                          isSelected: controller.selectedLanguage.value == 1,
                          title: "English",
                          index: 1,
                          groupValue: controller.selectedLanguage.value,
                          onTap: (){
                            controller.selectedLanguage.value = 1;
                          }
                      )),
                      SizedBox(height: getSize(20),),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(title: "Preference",fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white,),
                          MyText(title: "ترجیح",fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white,),
                        ],
                      ),
                      SizedBox(height: getSize(8),),
                 
                      Obx(()=> mainWidget(
                        context: context,
                        image: ImageConstant.pickup,
                          isSelected: controller.selectedPreference.value == 0,
                          title: "Pickup - استلام من الفرع",
                          index: 0,
                          groupValue: controller.selectedPreference.value,
                          onTap: (){
                            controller.selectedPreference.value = 0;
                          }
                      )),
                                            SizedBox(height: getSize(10),),

                           Obx(()=> mainWidget(
                                                context: context,

                        image: ImageConstant.delivery,
                          isSelected: controller.selectedPreference.value == 1,
                          title: "Delivery - ( قريباً )" ,
                          index: 1,
                          groupValue: controller.selectedPreference.value,
                          onTap: (){
                            // controller.selectedPreference.value = 1;
                          }
                      )),
                      Spacer(),
                      
                      SizedBox(height: getSize(20),),
                      InkWell(
                        onTap: ()async{
                              Constants.isDelivery.value = (controller.selectedPreference.value == 0);
                          if(controller.fromMenu){
                            Get.back();
                          }else{
                            Get.toNamed(Routes.LOCATION_SELECTION,);
                          }
                          if (controller.selectedLanguage.value == 1) {
                            Get.updateLocale(const Locale('en', 'US'));
                          } else if (controller.selectedLanguage.value == 0) {
                            Get.updateLocale(const Locale('ar', 'SA'));
                          }
                      
                          Future.delayed(1.seconds,(){
                            Utils.setUIOverlay();
                          });
                          LanguageUtils languagePreference = LanguageUtils();
                          await languagePreference.saveLanguage("arabic");
                        },
                        child: Container(
                          height: getSize(50),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),),
                          child: Text("Confirm تأكيد", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(20)
                          ),),
                        )),
                     
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainWidget({
    bool isSelected = false,
    String? image,
    Color? color,
    required String title,
    required int index,
    required int groupValue,
    void Function()? onTap,
   required BuildContext context,
  }){

    return GestureDetector(
      onTap: onTap,
      child: Container(
      
        decoration: BoxDecoration(
            color: color != null? Colors.white:color,
            borderRadius: BorderRadius.circular(getSize(10)),
            border: Border.all(color: color != null ? ColorConstant.primaryPink : Colors.white)
        ),
        padding: getPadding(right: 0, top: 5,  bottom: 5, left:0),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
   Radio<int>(
  value: index,
  groupValue: groupValue,
  activeColor: color == null ? Colors.white : ColorConstant.primaryPink, // Active color
  onChanged: (value) {
    if (onTap != null) {
      onTap!();
    }
  },
  // Setting the inactive (unselected) color using MaterialStateProperty
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  fillColor: MaterialStateProperty.resolveWith<Color>(
    (states) {
      // If it's not selected, set to the unselected color
      if (states.contains(MaterialState.selected)) {
        return color == null ? Colors.white : ColorConstant.primaryPink;
      }
      return Colors.white ; // Inactive color (unselected state)
    },
  ),
),
              image == null
                  ? const Offstage()
                  : Container(
                decoration: BoxDecoration(
                    color: ColorConstant.grayBackground,
                    shape: BoxShape.circle
                ),
                margin: getMargin(right: 15),
                padding: getPadding(all: 5),
                child: CustomImageView(
                  svgPath: image,
                  color: ColorConstant.primaryPink1,
                  height: getSize(24),
                  width: getSize(24),
                ),
              ),
              // CustomImageView(
              //   imagePath: ImageConstant.saudia,
              //   height: getSize(30),
              //   fit: BoxFit.fitHeight,
              //   margin: getMargin(right: 10),
              // ),
              MyText(title: title,fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}
