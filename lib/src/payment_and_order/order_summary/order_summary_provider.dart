import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/change_address/model/address_model.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_screen.dart';
import 'package:biotech_maali/src/payment_and_order/local_store_list/local_store_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_summary_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'order_summary_repository.dart';

class OrderSummaryProvider extends ChangeNotifier {
  OrderSummaryProvider() {
    fetchAllAddress();
  }
  final OrderSummaryRepository _repository = OrderSummaryRepository();

  int? selectedAddressIndex;
  final List<AddressModel> addresses = [];
  bool isAddressLoading = false;
  bool _isLoading = false;
  String _error = '';
  int? _selectedAddressId;
  String selectedDeliveryOption = 'Standard';
  bool isAddressSelected = false;
  OrderData? _orderData;
  // double totalAmount = 0.0;

  OrderData? get orderData => _orderData;
  bool get isLoading => _isLoading;
  String get error => _error;
  int? get selectedAddressId => _selectedAddressId;
  AddressModel selectedAddress = AddressModel(
    address: "",
    addressType: "",
    city: "",
    firstName: "",
    lastName: "",
    id: 0,
    pincode: 0,
    state: "",
    user: 0,
    isDefault: true,
  );

  void setOrderSummaryData(OrderData orderSummaryData) {
    _orderData = orderSummaryData;
    log("order summary data : ${orderSummaryData.newTotal}");
    notifyListeners();
  }

  void setAddressSelection(bool value) {
    isAddressLoading = value;
    notifyListeners();
  }

  void setChooseDeliveryOption(bool value) {
    log("value : $value");
    isAddressSelected = value;
    notifyListeners();
  }
  // void setSelectedAddressId(int id) {
  //   _selectedAddressId = id;
  //   notifyListeners();
  // }

  void setSelectedAddressIndex(int index) {
    selectedAddressIndex = index;
    notifyListeners();
  }

  void setDeliveryOption(String value) {
    selectedDeliveryOption = value;
    notifyListeners();
  }

  Future<void> fetchAllAddress() async {
    isAddressLoading = true;
    try {
      final response = await _repository.getAllAddress();
      if (response != null && response is List) {
        addresses
            .addAll(response.map((e) => AddressModel.fromJson(e)).toList());
        for (var address in addresses) {
          if (address.isDefault) {
            selectedAddressIndex = addresses.indexOf(address);
          }
        }

        selectedAddress = addresses[selectedAddressIndex!];
        _selectedAddressId = addresses[selectedAddressIndex!].id;
        isAddressLoading = false;
        notifyListeners();
      } else {
        // Handle unexpected response format
        log('Unexpected response format: $response');
        isAddressLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // Handle errors
      isAddressLoading = false;
      notifyListeners();
      log('Error fetching addresses: $e');
    }
  }

  Future<bool> updateOrderSummary(
      {required int orderId,
      required int addressId,
      required BuildContext context}) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final result = context.read<LocalStoreListProvider>().selectedStore;

      log("deliery option : ${result?.id}");

      OrderSummaryResponse orderSummaryResponse =
          await _repository.updateOrderSummary(
        context: context,
        orderId: orderId,
        addressId: addressId,
        deliveryOption: selectedDeliveryOption,
        storeId: result?.id ?? 0,
      );

      log("orderSummary Response: ${orderSummaryResponse.data.order.orderId}");
      context.read<ChoosePaymentProvider>().handleWalletCheckbox(false, null);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            orderSummaryResponse: orderSummaryResponse,
          ),
        ),
      );

      return true;
    } catch (e) {
      _error = e.toString();
      Fluttertoast.showToast(
        msg: _error,
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
