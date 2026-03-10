import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_repository.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/widgets/payment_success_popup.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_summary_response.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ChoosePaymentProvider extends ChangeNotifier {
  final ChoosePaymentRepository _repository = ChoosePaymentRepository();
  late Razorpay _razorpay;
  bool _isLoading = false;
  String _error = '';
  OrderSummaryResponse? _orderSummaryResponse;

  bool isWalletCheckbox = false;
  double? actualWalletBalance;
  bool isOnlineRadioButton = true;
  double _walletBalence = 0.0;
  bool get isLoading => _isLoading;
  String get error => _error;
  BuildContext context;
  int? orderId;
  bool isGstCheckbox = false;
  double totalBillAmount = 0.0;

  bool _isGst = false;
  bool get isGst => _isGst;

  void handleOnlinePaymentOption(bool value) {
    isOnlineRadioButton = !value;
    log("value : $value");
    notifyListeners();
  }

  void handleGstCheckbox(bool value) {
    isGstCheckbox = value;
    if (value) {
      _isGst = true;
    } else {
      _isGst = false;
    }
    notifyListeners();
  }

  void setIsGst() {
    _isGst = !isGst;
    notifyListeners();
  }

  void handleWalletBalance(double value) {
    actualWalletBalance = value;
    log("wallet balance : $actualWalletBalance");
    notifyListeners();
  }

  void handleCashOnDeliveryPayment(bool value) {
    isOnlineRadioButton = value;
    log("value : $value");
    notifyListeners();
  }

  void handleWalletCheckbox(bool value, double? walletBalence) {
    isWalletCheckbox = value;

    if (walletBalence != null) {
      _walletBalence = walletBalence;
    } else {
      _walletBalence = 0.0;
    }

    log("wallet balance : $_walletBalence");
    notifyListeners();
  }

  ChoosePaymentProvider(this.context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // void setOrderSummary(OrderSummaryResponse response) {
  //   _orderSummaryResponse = response;
  //   notifyListeners();
  // }

  void checkPaymentMethod(
      OrderSummaryResponse orderSummaryResponse, BuildContext context,
      {bool isPickUpStore = false}) {
    log("order summary response : ${orderSummaryResponse.data.order.grandTotal}");
    actualWalletBalance = context.read<WalletProvider>().balance;
    _orderSummaryResponse = orderSummaryResponse;

    // Calculate the actual amount based on delivery option
    double totalAmount = orderSummaryResponse.data.order.grandTotal;

    // If Pick Up Store, subtract shipping and shipping GST from total
    if (isPickUpStore) {
      final shippingInfo = orderSummaryResponse.data.shippingInfo;
      final order = orderSummaryResponse.data.order;

      // Get shipping values from shippingInfo or order object
      final shippingCharge =
          shippingInfo?.shippingCharge ?? order.shippingCharge;
      final shippingCgst = shippingInfo?.shippingCgst ?? order.shippingCgst;
      final shippingSgst = shippingInfo?.shippingSgst ?? order.shippingSgst;
      final shippingGst = shippingCgst + shippingSgst;

      totalAmount = totalAmount - shippingCharge - shippingGst;
      log("Pick Up Store - Adjusted total: $totalAmount (subtracted shipping: $shippingCharge + GST: $shippingGst)");
    }

    totalBillAmount = totalAmount;

    if (isWalletCheckbox) {
      if (actualWalletBalance! >= totalAmount) {
        // Wallet has enough balance - process payment with wallet only
        initiateWalletOnlyPayment(context, orderSummaryResponse);
      } else if (actualWalletBalance! >= 0) {
        // Wallet has partial balance - use wallet + razorpay for remaining
        initiatePartialWalletPayment(context, orderSummaryResponse);
      } else {
        // No wallet balance - show error
        Fluttertoast.showToast(
          msg: "Insufficient wallet balance",
          backgroundColor: Colors.red,
        );
      }
    } else {
      // Normal payment without wallet
      initiatePayment(context, orderSummaryResponse);
    }
  }

  Future<void> initiatePayment(
      BuildContext context, OrderSummaryResponse orderSummaryResponse,
      {bool isWallet = false}) async {
    log("order summary response : ${orderSummaryResponse.data.order.grandTotal}");

    _orderSummaryResponse = orderSummaryResponse;

    // Use totalBillAmount which is already adjusted for Pick Up Store in checkPaymentMethod
    double amoutToPay = totalBillAmount;
    log("Amount to pay (adjusted): $amoutToPay");

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      if (_orderSummaryResponse == null) {
        throw Exception('Order details not found');
      }

      final response = await _repository.proceedToPayment(
          orderId: _orderSummaryResponse!.data.order.id,
          paymentMethod: 'UPI',
          isGst: _isGst);

      log(response["order_id"].toString());
      log(response["razorpay_order"]['id'].toString());

      orderId = response["order_id"];

      final options = {
        // "key": "rzp_test_y70g5dxx6kOQ7v",
        "key": "rzp_live_SOdeeGn6k2XbYX",

        "amount": (amoutToPay * 100).toInt(),
        "name": "Biotech Maali",
        "description": "Order #${_orderSummaryResponse!.data.order.orderId}",
        "order_id": response["razorpay_order"]['id'],
        "prefill": {
          "contact": "8907444333",
          "email": "customer@email.com",
        },
        "notes": {
          "order_id": _orderSummaryResponse!.data.order.orderId.toString(),
        },
        "theme": {"color": "#4CAF50"}
      };

      _razorpay.open(options);
    } catch (e) {
      _error = "Something went wrong....., please try again later";
      Fluttertoast.showToast(
        msg: _error,
        backgroundColor: Colors.red,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New method: Wallet has enough balance to cover full payment
  Future<void> initiateWalletOnlyPayment(
      BuildContext context, OrderSummaryResponse orderSummaryResponse) async {
    log("Initiating wallet only payment");

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _repository.proceedToPayment(
          orderId: orderSummaryResponse.data.order.id,
          paymentMethod: 'Wallet',
          isGst: _isGst);

      // Payment successful - show success popup
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => const PaymentSuccessPopup(),
      );

      // Update wallet balance
      context.read<WalletProvider>().fetchWalletDetails();
    } catch (e) {
      _error = e.toString();
      Fluttertoast.showToast(
        msg: "Error processing wallet payment",
        backgroundColor: Colors.red,
      );
    } finally {
      _isLoading = false;
      isWalletCheckbox = false;
      notifyListeners();
    }
  }

  // New method: Wallet has partial balance, use wallet + razorpay for remaining
  Future<void> initiatePartialWalletPayment(
      BuildContext context, OrderSummaryResponse orderSummaryResponse) async {
    log("Initiating partial wallet payment");

    // Use totalBillAmount which is already adjusted for Pick Up Store
    double totalAmount = totalBillAmount;
    double remainingAmount = totalAmount - actualWalletBalance!;

    log("Total amount (adjusted): $totalAmount");
    log("Wallet balance: $actualWalletBalance");
    log("Remaining amount: $remainingAmount");

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      if (_orderSummaryResponse == null) {
        throw Exception('Order details not found');
      }

      // Backend will handle wallet deduction and return razorpay order for remaining amount
      final response = await _repository.proceedToPayment(
          orderId: orderSummaryResponse.data.order.id,
          paymentMethod: 'Wallet',
          isGst: _isGst);

      log("Partial wallet payment response: ${response.toString()}");

      // If backend returns razorpay order details, open razorpay for remaining amount
      if (response.containsKey("razorpay_order") &&
          response["razorpay_order"] != null) {
        orderId = response["order_id"];

        final options = {
          // "key": "rzp_test_y70g5dxx6kOQ7v",
          "key": "rzp_live_SOdeeGn6k2XbYX",
          "amount": (remainingAmount * 100).toInt(),
          "name": "Biotech Maali",
          "description":
              "Order #${orderSummaryResponse.data.order.orderId} (Remaining Amount)",
          "order_id": response["razorpay_order"]['id'],
          "prefill": {
            "contact": "8907444333",
            "email": "customer@email.com",
          },
          "notes": {
            "order_id": orderSummaryResponse.data.order.orderId.toString(),
            "wallet_used": actualWalletBalance.toString(),
          },
          "theme": {"color": "#4CAF50"}
        };

        _razorpay.open(options);
      } else {
        // If no razorpay order returned, payment was completed with wallet only
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => const PaymentSuccessPopup(),
        );

        // Update wallet balance
        context.read<WalletProvider>().fetchWalletDetails();
      }
    } catch (e) {
      _error = e.toString();
      Fluttertoast.showToast(
        msg: "Error processing wallet payment",
        backgroundColor: Colors.red,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Determine payment method based on whether wallet was used
      String paymentMethod = isWalletCheckbox ? 'Wallet' : 'UPI';

      await _repository.verifyPayment(
        razorpayPaymentId: response.paymentId,
        razorpayOrderId: response.orderId,
        razorpaySignature: response.signature,
        orderId: orderId,
        paymentMethod: paymentMethod,
      );

      // Track successful purchase analytics
      if (_orderSummaryResponse != null) {
        final orderData = _orderSummaryResponse!.data;
        final items = orderData.orderItems
            .map((p) => {
                  'id': p.productId.toString(),
                  'name': p.productName,
                  'price': p.sellingPrice,
                  'quantity': p.quantity,
                })
            .toList();

        AnalyticsService().logPurchase(
          transactionId: orderData.order.orderId,
          totalValue: totalBillAmount,
          items: items,
          paymentMethod: paymentMethod,
        );

        // Track payment method used
        AnalyticsService().logAddPaymentInfo(
          paymentType: paymentMethod,
          value: totalBillAmount,
        );

        // Update user properties
        AnalyticsService().setPreferredPayment(paymentMethod);
      }

      if (navigatorKey.currentContext != null) {
        // Use post-frame callback to update wallet
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<WalletProvider>().fetchWalletDetails();
        });

        isWalletCheckbox = false;
        notifyListeners();

        // Show success dialog
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => const PaymentSuccessPopup(),
        );
      } else {
        log("Navigator context is null");
        throw Exception("Navigation failed - context is null");
      }
    } catch (e) {
      _error = e.toString();
      log("Error in payment success handler: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Payment verified but navigation failed. Please restart the app.",
        backgroundColor: Colors.orange,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    _error = response.message ?? 'Payment failed';
    log("Response : ${_error.toString()}");

    // Track payment failure analytics
    String paymentMethod = isWalletCheckbox ? 'Wallet+UPI' : 'UPI';
    AnalyticsService().logPaymentFailed(
      paymentMethod: paymentMethod,
      errorReason: _error,
      amount: totalBillAmount,
      orderId: orderId?.toString(),
    );

    if (isWalletCheckbox) {
      if (actualWalletBalance! < totalBillAmount) {
        await _repository.rollbackWalletPayment(
            orderId: orderId!, walletAmount: actualWalletBalance!.toString());
      }
    }

    Fluttertoast.showToast(
      msg: "Payment failed press proceed to continue",
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.red,
      backgroundColor: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      backgroundColor: Colors.green,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
