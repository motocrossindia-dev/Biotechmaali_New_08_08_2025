import 'package:biotech_maali/src/other_modules/contact_us/contact_us_repository.dart';
import 'package:biotech_maali/src/other_modules/contact_us/model/cantact_us_model.dart';
import 'package:flutter/foundation.dart';

class ContactProvider with ChangeNotifier {
  final ContactRepository _repository = ContactRepository();

  final List<CorporateContact> _contacts = [];
  final bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<CorporateContact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Map<String, List<String>> _fieldErrors = {};

  Map<String, List<String>> get fieldErrors => _fieldErrors;

  Future<bool> submitInquiry(ContactInquiry inquiry) async {
    try {
      _isSubmitting = true;
      _error = null;
      _fieldErrors = {};
      notifyListeners();

      final result = await _repository.submitInquiry(inquiry);

      if (!result['success']) {
        _error = result['message'];
        if (result['errors'] != null) {
          _fieldErrors = Map<String, List<String>>.from(result['errors'].map(
              (key, value) => MapEntry(key, (value as List).cast<String>())));
        }
        return false;
      }

      return true;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
