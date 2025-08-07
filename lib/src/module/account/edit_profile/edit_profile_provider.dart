import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/edit_profile/edit_profile_repository.dart';
import 'package:intl/intl.dart';

class EditProfileProvider extends ChangeNotifier {
  EditProfileProvider() {
    fetchProfileData();
  }
  final ProfileRepository profileRepository = ProfileRepository();

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController gstNumber = TextEditingController();
  final TextEditingController gstNumberCheckout = TextEditingController();

  // bool _isGst = false;
  // bool get isGst => _isGst;

  String _selectedGender = 'Male';
  bool _isEditing = false;
  bool _isLoading = false;

  String get selectedGender => _selectedGender;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;

  void selectGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  bool hasGstNumber() {
    return gstNumberCheckout.text.trim().isNotEmpty;
  }

  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final profileData = await profileRepository.fetchProfile();

      log("Profile Data provider = ${profileData.toString()}");

      prefs.setString('userName', profileData['first_name']);

      firstName.text = profileData['first_name'] ?? '';
      lastName.text = profileData['last_name'] ?? '';
      emailAddress.text = profileData['email'] ?? '';
      mobileNumber.text = profileData['mobile'] ?? '';
      gstNumberCheckout.text = profileData['gst'] ?? '';
      dateOfBirth.text = profileData['date_of_birth'] != null
          ? DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(profileData['date_of_birth']))
          : '';
      _selectedGender = profileData['gender'] ?? 'Male';
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(bool? isplaceOrder, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await profileRepository.updateProfile(
        firstName: firstName.text,
        lastName: lastName.text,
        email: emailAddress.text,
        mobile: mobileNumber.text,
        gender: _selectedGender,
        gst: gstNumber.text,
        dateOfBirth: dateOfBirth.text.isNotEmpty ? dateOfBirth.text : null,
      );

      if (success) {
        _isEditing = false;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userName", firstName.text);
        await context.read<AccountProvider>().getUserName();
        if (isplaceOrder == true) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditAddressScreen(
                isAddAddress: true,
                isFromAccount: true,
              ),
            ),
          );
          // return false;
        }
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
