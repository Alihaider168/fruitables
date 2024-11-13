import 'package:fruitables/app/data/core/app_export.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressController extends GetxController {
  late GoogleMapController mapController;
  LatLng currentPosition = const LatLng(0, 0);
  Rx<Marker> currentMarker = const Marker(markerId: MarkerId('current_location'),).obs;
  Rx<Circle> currentCircle  = const Circle(circleId: CircleId('current_location_circle'),).obs;
  TextEditingController addressController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  final List<String> labels = [
    "home".tr,
    "work".tr,
    "partner".tr,
    "other".tr,
  ];

  final List<String> labelImages = [
    ImageConstant.home,
    ImageConstant.work,
    ImageConstant.partner,
    ImageConstant.other,
  ];

  RxInt selectedLabel = (-1).obs;


  @override
  void onInit() {
    super.onInit();
    regionController.text = Constants.selectedBranch?.address??"";
    _getCurrentLocation();
  }


  Future<void> _getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case when permission is denied
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    currentMarker.value = Marker(
      markerId: const MarkerId('current_location'),
      position: currentPosition,
    );
    currentCircle.value = Circle(
      circleId: const CircleId('current_location_circle'),
      center: currentPosition,
      radius: 200, // Change the radius as needed
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );

    moveToCurrentLocation();


  }

  // Move the camera to the current location
  moveToCurrentLocation(){
    mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
  }



}
