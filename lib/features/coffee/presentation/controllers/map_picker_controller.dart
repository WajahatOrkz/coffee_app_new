import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerController extends GetxController {
  GoogleMapController? mapController;
  final selectedLocation = Rxn<LatLng>();
  final address = "Tap on map to select location".obs;
  final isLoading = true.obs;
  final markers = <Marker>{}.obs;

  LatLng? _pendingCameraMove;

  static const CameraPosition kDefaultPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // ✅ Agar location pehle aa gayi thi aur map baad mein ready hua
    if (_pendingCameraMove != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_pendingCameraMove!, 15),
        );
        _pendingCameraMove = null;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      isLoading.value = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied");
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permissions are permanently denied.");
      isLoading.value = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      selectedLocation.value = latLng;

      markers.clear();
      markers.add(
        Marker(markerId: const MarkerId('selected'), position: latLng),
      );

     
      isLoading.value = false;

      await Future.delayed(const Duration(milliseconds: 300));

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      } else {
      
        _pendingCameraMove = latLng;
      }

      getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      print("❌ Error getting location: $e");
      Get.snackbar("Error", "Failed to get current location: $e");
      isLoading.value = false;
    }
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address.value =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void onMapTapped(LatLng position) {
    selectedLocation.value = position;
    markers.clear();
    markers.add(
      Marker(markerId: const MarkerId('selected'), position: position),
    );
    getAddressFromLatLng(position.latitude, position.longitude);
  }

  void confirmSelection() {
    if (selectedLocation.value != null) {
      Get.back(
        result: {
          'address': address.value,
          'lat': selectedLocation.value!.latitude,
          'lng': selectedLocation.value!.longitude,
        },
      );
    } else {
      Get.snackbar("Error", "Please select a location on the map.");
    }
  }
}