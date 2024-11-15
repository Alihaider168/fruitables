import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_round_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressController extends GetxController {
  late GoogleMapController mapController;
  LatLng currentPosition = const LatLng(0, 0);
  Rx<Marker> currentMarker = const Marker(markerId: MarkerId('current_location'),).obs;
  Rx<Circle> currentCircle  = const Circle(circleId: CircleId('current_location_circle'),).obs;
  TextEditingController addressController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  final List<String> labels = [
    "home",
    "work",
    "partner",
    "other",
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
    getAddressFromLatLng(currentPosition.latitude, currentPosition.longitude);
    moveToCurrentLocation();


  }

  // Move the camera to the current location
  moveToCurrentLocation(){
    mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
  }
  // Move the camera to the new location
  moveToNewLocation(LatLng latlng){
    currentPosition = latlng;
    mapController.animateCamera(CameraUpdate.newLatLng(latlng));
    currentMarker.value = Marker(
      markerId: const MarkerId('current_location'),
      position: currentPosition,
    );

    getAddressFromLatLng(latlng.latitude, latlng.longitude);
  }


  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      // Extract the first placemark from the list
      Placemark place = placemarks[0];

      // Create a formatted address string
      String address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      addressController.text = address;
    } catch (e) {
      print(e);
      addressController.text = "";
    }
  }



}
