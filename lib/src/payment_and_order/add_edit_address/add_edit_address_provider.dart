import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/add_edit_address/add_edit_address_repository.dart';
import 'package:biotech_maali/src/payment_and_order/add_edit_address/model/add_or_edit_address_model.dart';
import 'package:biotech_maali/src/payment_and_order/change_address/change_address_provider.dart';
import 'package:biotech_maali/src/payment_and_order/change_address/model/address_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../import.dart';

class AddEditAddressProvider extends ChangeNotifier {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  bool _isHomeAddress = true;

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get cityController => _cityController;
  TextEditingController get stateController => _stateController;
  TextEditingController get pincodeController => _pincodeController;
  bool get isHomeAddress => _isHomeAddress;

  final AddEditAddressRepository _addEditAddressRepository =
      AddEditAddressRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleIsHomeAddress() {
    _isHomeAddress = !_isHomeAddress;
    notifyListeners();
  }

  setEditData(AddressModel address) {
    _firstNameController.text = address.firstName;
    _lastNameController.text = address.lastName;
    _addressController.text = address.address;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _pincodeController.text = address.pincode.toString();
    _isHomeAddress = address.addressType == 'Home';
    notifyListeners();
  }

  clearAllFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _addressController.clear();
    _cityController.clear();
    _stateController.clear();
    _pincodeController.clear();
    _isHomeAddress = true;
    notifyListeners();
  }

  Future<void> addAddress(BuildContext context) async {
    if (_firstNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter first name');
      return;
    }

    if (_lastNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter last name');
      return;
    }

    if (_addressController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter address');
      return;
    }

    if (_cityController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter city');
      return;
    }

    if (_stateController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter state');
      return;
    }

    if (_pincodeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter pincode');
      return;
    }

    if (_pincodeController.text.length != 6) {
      Fluttertoast.showToast(msg: 'Please enter a valid 6-digit pincode');
      return;
    }

    _isLoading = true;
    notifyListeners();

    AddOrEditAddressModel address = AddOrEditAddressModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text,
      addressType: _isHomeAddress ? 'Home' : 'Work',
      pincode: int.parse(_pincodeController.text),
    );

    try {
      final response = await _addEditAddressRepository.addAddress(address);

      _isLoading = false;
      notifyListeners();

      if (response) {
        await context.read<ChangeAddressProvider>().fetchAllAddress();
        clearAllFields();
        Navigator.pop(context); // Use pop to go back to the previous screen
        Fluttertoast.showToast(msg: 'Address added successfully');
        return;
      } else {
        Fluttertoast.showToast(msg: 'Failed to add address');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      String errorMessage;
      if (e is NetworkException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is ServerException) {
        errorMessage = 'Server error. Please try again later.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      log("Error: $e");
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  Future<void> updateAddress(BuildContext context, int addressId) async {
    if (_firstNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter first name');
      return;
    }

    if (_lastNameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter last name');
      return;
    }

    if (_addressController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter address');
      return;
    }

    if (_cityController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter city');
      return;
    }

    if (_stateController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter state');
      return;
    }

    if (_pincodeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter pincode');
      return;
    }

    if (_pincodeController.text.length != 6) {
      Fluttertoast.showToast(msg: 'Please enter a valid 6-digit pincode');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      bool response = await _addEditAddressRepository.editAddress(
        AddOrEditAddressModel(
          addressId: addressId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          address: _addressController.text,
          city: _cityController.text,
          state: _stateController.text,
          addressType: _isHomeAddress ? 'Home' : 'Work',
          pincode: int.parse(_pincodeController.text),
        ),
      );

      _isLoading = false;
      notifyListeners();

      log("message: ${response.toString()}");

      if (response) {
        await context.read<ChangeAddressProvider>().fetchAllAddress();
        Fluttertoast.showToast(msg: 'Address updated successfully');
        clearAllFields();
        Navigator.pop(context); // Use pop to go back to the previous screen
      } else {
        Fluttertoast.showToast(msg: 'Failed to update address');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      String errorMessage;
      if (e is NetworkException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is ServerException) {
        errorMessage = 'Server error. Please try again later.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      log("Error: $e");
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _isHomeAddress = false;
    super.dispose();
  }
}
