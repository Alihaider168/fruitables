import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fruitables/app/data/models/city_model.dart';
import 'package:fruitables/app/data/utils/api_utils.dart';
import 'package:fruitables/app/data/utils/utils.dart';
import 'package:fruitables/app/data/widgets/custom_button.dart';
import 'package:fruitables/app/services/base_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/core/app_export.dart';

class LocationSelectionController extends GetxController {
  late GoogleMapController mapController;
  LatLng currentPosition = const LatLng(0, 0);
  Rx<Marker> currentMarker = const Marker(markerId: MarkerId('current_location'),).obs;
  Rx<Circle> currentCircle  = const Circle(circleId: CircleId('current_location_circle'),).obs;

  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();


  // List to hold filtered search results
  RxList<Branches> filteredLocations = <Branches>[].obs;

  bool isInitialized = false;

  CityModel? cityModel;

  int _selectedCityIndex = 0;
  int selectedCity = 0;


  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    getRegions();
    // Add a listener to the search controller
    _searchController.addListener(_filterLocations);
  }

  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
      filteredLocations.value = (cityModel?.data?.branches??[]).where((element)=> (Utils.checkIfUrduLocale() ? element.city?.name : element.city?.englishName) == cityController.text).toList()
          .where((location) => location.englishName!.toLowerCase().contains(query) || location.name!.toLowerCase().contains(query))
          .toList();
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
    if(isInitialized){
      mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
    } else{
      moveToCurrentLocation();
    }
  }

  Future<dynamic> getRegions() async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.getRegions,
          onSuccess: (response) async {
            print(response);
            cityModel = CityModel.fromJson(response.data);
            return true;
          },
          onError: (error) {
            BaseClient.handleApiError(error);
            update();
            return false;
          },
        );
      }
    });
  }


  showCitySheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          )),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.7,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: getPadding(all: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: (){
                        Get.back();
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                            color: ColorConstant.black,
                            shape: BoxShape.circle
                        ),
                        padding: getPadding(all: 3),
                        child: Icon(
                          Icons.close,
                          color: ColorConstant.white,
                          size: getSize(18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(),
                      itemExtent: 40.0,
                      onSelectedItemChanged: (int index) {
                        _selectedCityIndex = index;
                      },
                      children: (cityModel?.data?.cities??[])
                          .map((city) => Center(
                        child: MyText(
                          title: Utils.checkIfUrduLocale() ? (city.name??"") : city.englishName??"",
                          fontSize: 16,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 30),
                    child: CustomButton(
                      onTap: (){
                        selectedCity = _selectedCityIndex;
                        cityController.text = Utils.checkIfUrduLocale() ? (cityModel?.data?.cities?[selectedCity].name??"") : (cityModel?.data?.cities?[selectedCity].englishName??"");
                        filteredLocations.value = (cityModel?.data?.branches??[]).where((element)=> (Utils.checkIfUrduLocale() ? element.city?.name : element.city?.englishName) == cityController.text).toList();
                        filteredLocations.refresh();
                        Get.back();
                      },
                      text: "lbl_done".tr,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void showCustomBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          )),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.7,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: getPadding(all: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search bar and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search, color: Colors.pink),
                            hintText: 'Search',
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: MyText(
                          title: 'Close',
                          clr: ColorConstant.primaryPink,
                          customWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // List of locations
                  Expanded(
                      child: Obx(()=> filteredLocations.isEmpty
                          ? const Center(child: Text('No results found'))
                          : ListView.builder(
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: (){
                              regionController.text = Utils.checkIfUrduLocale() ? filteredLocations[index].name??"" : filteredLocations[index].englishName??"";
                              Get.back();
                            },
                            title: Text(Utils.checkIfUrduLocale() ? filteredLocations[index].name??"" : filteredLocations[index].englishName??""),
                          );
                        },
                      )),

                  )
                ],
              ),
            );
          },
        );
      },
    );
  }


}
