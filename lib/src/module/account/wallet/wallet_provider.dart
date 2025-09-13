import 'dart:developer';

import 'package:biotech_maali/src/module/account/wallet/wallet_model.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletProvider extends ChangeNotifier {
  final WalletRepository _repository = WalletRepository();

  late Razorpay _razorpay;
  bool _isProcessingPayment = false;

  bool get isProcessingPayment => _isProcessingPayment;

  WalletProvider() {
    fetchWalletDetails();
    fetchTransactions();
    _initializeRazorpay();
  }

  double _balance = 0.0;
  int _selectedAmount = 0;
  bool _isLoading = false;
  List<Transaction> _transactions = [];
  String? _error;

  final TextEditingController _amountController = TextEditingController();

  TextEditingController get amountController => _amountController;
  double get balance => _balance;
  int get selectedAmount => _selectedAmount;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWalletDetails() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _repository.getWalletDetails();
      _balance = double.parse(response.data.balance);

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchTransactions() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _repository.getTransactions();
      _transactions = response.data.transactions;

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void setSelectedAmount(int amount) {
    _amountController.text = amount.toString();
    _selectedAmount = amount;
    notifyListeners();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> addMoneyToWallet(BuildContext context) async {
    if (_selectedAmount <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid amount");
      return;
    }

    try {
      _isProcessingPayment = true;
      notifyListeners();

      final response =
          await _repository.createWalletOrder(_selectedAmount.toString());

      // Add debug log to check response
      log("Razorpay Order Response: $response");

      // Safely access the razorpay_order id
      log("razorpay_order id: ${response['order']['id']}");
      final razorpayOrderId = response['order']['id'];
      if (razorpayOrderId == null) {
        throw Exception('Invalid order response from server');
      }

      final options = {
        "key": "rzp_live_RH46LqJqM4UlmU",
        "amount": (_selectedAmount * 100).toInt(),
        "name": "Biotech Maali",
        "description": "Wallet Recharge",
        "order_id": razorpayOrderId,
        "prefill": {
          "contact": "8907444333",
          "email": "customer@email.com",
        },
        "theme": {"color": "#4CAF50"}
      };

      _razorpay.open(options);
    } catch (e) {
      _error = e.toString();
      log("Error creating payment: ${_error.toString()}");
      Fluttertoast.showToast(
          msg: "Error creating payment: ${_error!}",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG);
    } finally {
      _isProcessingPayment = false;
      notifyListeners();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      await _repository.verifyWalletPayment(
        razorpayPaymentId: response.paymentId!,
        razorpayOrderId: response.orderId!,
        razorpaySignature: response.signature!,
      );
      _amountController.clear();
      _selectedAmount = 0;

      await fetchWalletDetails();
      await fetchTransactions();

      Fluttertoast.showToast(
        msg: "Money added to wallet successfully!",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error verifying payment: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Payment failed: ${response.message}");
    Fluttertoast.showToast(
      msg: "Payment failed",
      textColor: Colors.red,
      backgroundColor: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      backgroundColor: Colors.blue,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
