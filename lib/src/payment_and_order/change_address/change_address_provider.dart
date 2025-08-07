import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'change_address_repository.dart';
import 'model/address_model.dart';

class ChangeAddressProvider extends ChangeNotifier {

  
  int? selectedAddressIndex;
  final List<AddressModel> addresses = [];
  final ChangeAddressRepository _repository = ChangeAddressRepository();

  void setSelectedAddressIndex(int index) {
    selectedAddressIndex = index;
    notifyListeners();
  }

  Future<void> fetchAllAddress() async {
    try {
      final response = await _repository.getAllAddress();
      if (response != null && response is List) {
        addresses.clear();
        addresses
            .addAll(response.map((e) => AddressModel.fromJson(e)).toList());
        for (var address in addresses) {
          if (address.isDefault) {
            selectedAddressIndex = addresses.indexOf(address);
          }
        }
        notifyListeners();
      } else {
        // Handle unexpected response format
        log('Unexpected response format: $response');
      }
    } catch (e) {
      // Handle errors
      log('Error fetching addresses: $e');
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      final response = await _repository.deleteAddress(id);
      if (response != null && response is bool) {
        if (response) {
          addresses.removeWhere((element) => element.id == id);
          notifyListeners();
        } else {
          // Handle error
          log('Error deleting address');
        }
      } else {
        // Handle unexpected response format
        log('Unexpected response format: $response');
      }
    } catch (e) {
      // Handle errors
      log('Error deleting address: $e');
    }
  }

  Future<bool> changeDeliveryAddress(int addressId) async {
    try {
      final response = await _repository.changeDeliveryAddress(addressId);
      if (response) {
        Fluttertoast.showToast(msg: 'Delivery address changed successfully');
        
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Failed to change delivery address');
        return false;
      }
    } catch (e) {
      log('Error changing delivery address: $e');
      Fluttertoast.showToast(
          msg: 'An error occurred while changing the delivery address');
      return false;
    } finally {
      await fetchAllAddress();
    }
  }
}
