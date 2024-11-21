import 'package:get/get.dart';
import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:video_player/video_player.dart';

class LanguageSelectionController extends GetxController {
  RxInt selectedPreference = 0.obs;
  RxInt selectedLanguage = 0.obs;
  bool fromMenu = false;
  late VideoPlayerController videoController;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
     videoController = VideoPlayerController.network(
      'https://video-previews.elements.envatousercontent.com/5cb483f5-5bb9-4837-9c2b-2d5608be41f4/watermarked_preview/watermarked_preview.mp4', // Replace with your video URL
    )
      ..initialize().then((_) {
        // Ensure the video is looped and starts playing
        videoController.setLooping(true);
        videoController.play();
       // Refresh the UI once the video is initialized
      });
    var data = Get.arguments;
    if(data!= null && data["from_menu"] != null){
      fromMenu = data['from_menu'];
    }
    super.onInit();
  }
}
