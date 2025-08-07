import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/coupon/coupon_list_repository.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../import.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepository _repository = CouponRepository();

  List _coupons = [];
  bool _isLoading = false;
  String? _error;
  String? _appliedCouponCode;
  double _cartValue = 0.0;
  double _discountAmount = 0.0;
  bool _isCouponApplied = false; // New flag to track coupon application status

  List get coupons => _coupons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get appliedCouponCode => _appliedCouponCode;
  double get cartValue => _cartValue;
  double get discountAmount => _discountAmount;
  double get finalAmount => _cartValue - _discountAmount;
  bool get isCouponApplied => _isCouponApplied; // Getter for the new flag

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  void setCartValue(double value) {
    _cartValue = value;
    notifyListeners();
  }

  Future<void> fetchCoupons(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    log("orderid : $orderId");

    try {
      _coupons = await _repository.getCoupons(orderId);
    } catch (e) {
      _error = "No coupons available";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderData?> applyCoupon(String couponId, String orderId,
      String couponCode, BuildContext context) async {
    _isLoading = true;
    _errorMessage = ""; // Reset error message before API call
    _isCouponApplied = false;
    notifyListeners();

    try {
      final result =
          await _repository.applyCoupon(couponId: couponId, orderId: orderId);

      if (result != null && result.success == true) {
        _appliedCouponCode = couponCode;
        _isCouponApplied = true;
        _discountAmount = result.discountAmount!;

        // Fluttertoast.showToast(msg: "Coupon applied successfully");
        // showSuccessDialog(context, "Coupon applied successfully");
        // showErrorBottomSheet(context, "Coupon applied successfully");

        _isLoading = false;
        notifyListeners();
        return result;
      } else if (result != null && result.success == false) {
        _appliedCouponCode = couponCode;
        _isCouponApplied = false; // Reset flag when coupon is not applied
        _discountAmount = 0;
        _isLoading = false;
        notifyListeners();
        return result;
      } else {
        _appliedCouponCode = null;
        _discountAmount = 0;
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      log("Coupon application error: $e");

      // Store the error message in provider
      _errorMessage = e
          .toString()
          .replaceFirst("Exception: ", ""); // Remove Exception prefix
      notifyListeners();

      Fluttertoast.showToast(
          msg: _errorMessage,
          textColor: cWhiteColor,
          backgroundColor: cDarkerRed,
          toastLength: Toast.LENGTH_LONG);

      _appliedCouponCode = null;
      _discountAmount = 0;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void removeCoupon() {
    _appliedCouponCode = null;
    _discountAmount = 0;
    _isCouponApplied = false; // Reset flag when coupon is removed
    notifyListeners();
  }
}

void showErrorBottomSheet(BuildContext context, String errorMessage) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            const Text(
              "Error",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close BottomSheet
                Navigator.pop(context); // Go Back to Previous Screen
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    },
  );
}
