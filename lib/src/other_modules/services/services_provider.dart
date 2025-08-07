import 'dart:developer';

import 'package:biotech_maali/src/other_modules/services/model/service_enquery_model.dart';
import 'package:biotech_maali/src/other_modules/services/model/service_model.dart';
import 'package:biotech_maali/src/other_modules/services/service_repository.dart';

import '../../../import.dart';

class ServicesProvider with ChangeNotifier {
  final ServicesRepository _repository;
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String _error = '';
  bool _isSubmitting = false;

  List<String> serviceList = [
    'Landscaping',
    'Terrace Gardening',
    'Kitchen Gardening',
    'Vertical Wall Gardening',
    'Drip Irrigation',
    'Garden Maintenance',
  ];

  ServicesProvider() : _repository = ServicesRepository();

  List<ServiceModel> get services => _services.where((s) => s.visible).toList();
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isSubmitting => _isSubmitting;

  Future<void> fetchServices() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final result = await _repository.getServices();
      log("Data in provider for services list : ${result.toString()}");
      if (result == null) {
        return;
      } else {
        _services = result;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getCurrentLocationAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('user_current_address');
    if (location == null) {
      return "Location not found";
    } else {
      return location;
    }
  }

  Future<bool> submitForm(
    String name,
    String contact,
    String location,
    String service,
    String message,
  ) async {
    try {
      _isSubmitting = true;
      _error = '';
      notifyListeners();

      final enquiry = ServiceEnquiryModel(
        name: name,
        contact: contact,
        location: location,
        service: service,
        message: message,
      );

      final result = await _repository.submitEnquiry(enquiry);

      _isSubmitting = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isSubmitting = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError(String error) {
    _error = error;
    notifyListeners();
  }
}
