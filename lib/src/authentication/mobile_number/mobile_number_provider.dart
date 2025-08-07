import 'dart:developer';
import '../../../import.dart';

class MobileNumberProvider extends ChangeNotifier {
  final TextEditingController _mobileNumber = TextEditingController();
  TextEditingController get mobileNumber => _mobileNumber;

  final MobileNumberRepository _mobileNumberRepository =
      MobileNumberRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> registerMobile(BuildContext context) async {
    if (_mobileNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      
          await _mobileNumberRepository.registerWithMobile(_mobileNumber.text);
      _isLoading = false;
      notifyListeners();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(mobile: _mobileNumber.text),
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}
