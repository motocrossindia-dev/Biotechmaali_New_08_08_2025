import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_repository.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferFriendProvider extends ChangeNotifier {
  ReferFriendRepository referFriendRepository = ReferFriendRepository();
  final TextEditingController _referralCode = TextEditingController();
  int? _totlaReferral = 0;
  int? _totalcoins = 0;
  bool _isLoading = false;

  TextEditingController get referralCode => _referralCode;
  int? get totlaReferral => _totlaReferral;
  int? get totalcoins => _totalcoins;
  bool get isLoading => _isLoading;

  Future<void> getReferralDetails() async {
    _isLoading = true;
    // notifyListeners();

    try {
      final data = await referFriendRepository.getReferral();

      if (data != null) {
        _totlaReferral = data.totalReferrals;
        _totalcoins = data.totalCoins;
        _referralCode.text = data.referralCode;
      }
    } catch (e) {
      debugPrint('Error fetching referral details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> shareReferralCode() async {
    if (_referralCode.text.isEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Create a temporary file with the app logo
      final ByteData byteData =
          await rootBundle.load('assets/png/biotech_logo.png');
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/biotech_logo.png');
      await file.writeAsBytes(imageBytes);

      // Customize the message to be shared
      final String message =
          'Hey! I invite you to join Biotech Maali. Use my referral code:\n\n'
          '${_referralCode.text}\n\n'
          'Download the app now: https://play.google.com/store/apps/details?id=com.biotechmaali.app';

      // Share the message and image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: 'Biotech Maali Referral Code',
      );
    } catch (e) {
      debugPrint('Error sharing referral code: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
