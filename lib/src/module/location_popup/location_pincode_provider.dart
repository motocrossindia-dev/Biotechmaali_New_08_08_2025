import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPincodeProvider extends ChangeNotifier {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  TextEditingController get pincodeController => _pincodeController;
  TextEditingController get addressController => _addressController;

  bool isLoading = false;
  LatLng? selectedLocation;
  GoogleMapController? _mapController;
  String localityName = "Searching...";
  String localityPincode = "Searching...";
  bool isLocationEnabled = false;
  bool showAllAddresses = false;
  bool isLogin = false;

  Future<void> checkUserLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin') ?? false;
    notifyListeners();
  }

  Future<void> getCurrentLocation(
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        isLoading = false;
        notifyListeners();
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      selectedLocation = currentLocation;
      isLoading = false;
      notifyListeners();
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: 15,
          ),
        ),
      );
      await fetchAddressFromCoordinates(currentLocation, context);
      // After getting location, pop to home screen
      if (context.mounted) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Location updated successfully",
            backgroundColor: cButtonGreen);

        context.read<BottomNavProvider>().updateIndex(0);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch current location')),
      );
    }
  }

  Future<void> getCurrentLocationFromBottomNav(
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        isLoading = false;
        notifyListeners();
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      selectedLocation = currentLocation;
      isLoading = false;
      notifyListeners();
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: 15,
          ),
        ),
      );
      await fetchAddressFromCoordinates(currentLocation, context);
      // After getting location, pop to home screen
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch current location')),
      );
    }
  }

  Future<void> fetchAddressFromCoordinates(
      LatLng location, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
        localeIdentifier: "en_IN",
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        _addressController.text =
            "${place.locality == null ? "" : "${place.locality},"} ${place.subLocality == null ? "" : "${place.subLocality},"} ${place.subAdministrativeArea == null ? "" : "${place.subAdministrativeArea},"}"
            "${place.administrativeArea}, ${place.country}";
        _pincodeController.text = place.postalCode ?? '';
        log("_addressController.text: ${_addressController.text}");

        log("user locality: ${place.locality}");
        localityName = place.locality ?? "Searching...";
        localityPincode = place.postalCode ?? "Searching...";
        notifyListeners();

        prefs.setString("user_current_address", _addressController.text.trim());
        prefs.setString("user_pincode", place.postalCode ?? 'Searching...');
        prefs.setString("user_locality", place.locality ?? '');

        // Only use context if widget is still mounted
        if (context.mounted) {
          context
              .read<HomeProvider>()
              .setLocationPincode(place.postalCode ?? '');
          // Update full address in HomeProvider
          context
              .read<HomeProvider>()
              .updateFullAddress(_addressController.text.trim());
          log("Pincode set: ${place.postalCode ?? 'no data'}");
        }
      }
    } catch (e) {
      log("Error fetching address: $e");
      debugPrint('Error fetching address: $e');
    }
  }
}
