import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_repository.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/model/franchise_model.dart';
import '../../../import.dart';

class FranchiseProvider extends ChangeNotifier {
  final FranchiseRepository _repository = FranchiseRepository();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _area = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _message = TextEditingController();
  bool _isLoading = false;
  String? _error;

  // Getters
  TextEditingController get name => _name;
  TextEditingController get contact => _contact;
  TextEditingController get email => _email;
  TextEditingController get area => _area;
  TextEditingController get address => _address;
  TextEditingController get message => _message;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Setters with validation

  Future<void> submitForm(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final franchise = FranchiseModel(
        name: _name.text,
        mobile: _contact.text,
        email: _email.text,
        area: _area.text,
        address: _address.text,
        message: _message.text,
      );

      bool result = await _repository.submitFranchiseInquiry(franchise);

      if (result == true) {
        _resetForm();
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget(
                    title: 'Success!',
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              content: const CommonTextWidget(
                title:
                    'Your franchise enquiry has been sent successfully. Our team will contact you shortly.\n\nThank you for your interest!',
                textAlign: TextAlign.center,
                fontSize: 16,
              ),
              actions: [
                TextButton(
                  child: CommonTextWidget(
                    title: 'OK',
                    fontSize: 16,
                    color: cButtonGreen,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _error = _getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }

  void _resetForm() {
    _name.clear();
    _contact.clear();
    _email.clear();
    _area.clear();
    _address.clear();
    _message.clear();
    _error = null;
    notifyListeners();
  }
}
