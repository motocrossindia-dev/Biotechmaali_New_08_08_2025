import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_compo_list/model/product_compo_model.dart';
import 'package:biotech_maali/src/module/product_compo_list/product_compo_repository.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_repository.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';

/// Result types for combo order placement
enum ComboOrderResult {
  success,
  profileNotUpdated,
  addressNotUpdated,
  loginRequired,
  serverError,
  deliveryUnavailable,
  networkError,
  comboUnavailable,
  genericError,
}

class ComboOrderResponse {
  final ComboOrderResult result;
  final String? message;
  final OrderData? orderData;

  ComboOrderResponse({
    required this.result,
    this.message,
    this.orderData,
  });
}

class ProductCompoListProvider extends ChangeNotifier {
  final ProductCompoRepository _repository = ProductCompoRepository();
  bool _isLoading = false;
  bool _isBuying = false;
  String? _error;
  ProductCompoData? _comboData;
  OrderResponseModel? _orderResponse;

  bool get isLoading => _isLoading;
  bool get isBuying => _isBuying;
  String? get error => _error;
  ProductCompoData? get comboData => _comboData;
  List<ComboOffer> get comboOffers => _comboData?.activeComboOffers ?? [];
  List<ComboOffer> get shopTheLook => _comboData?.shopTheLook ?? [];
  OrderResponseModel? get orderResponse => _orderResponse;

  Future<void> fetchComboOffers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repository.getComboOffers();
      _comboData = response.data;
    } catch (e) {
      _error = "Failed to fetch combo offers, something went wrong";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Places a combo order and returns a result.
  /// Navigation should be handled by the caller (screen) to avoid context issues.
  Future<ComboOrderResponse> placeOrderCombo(int comboId) async {
    try {
      _isBuying = true;
      _error = '';
      notifyListeners();

      log('Placing combo order - comboId: $comboId');
      _orderResponse = await _repository.buyComboProduct(comboId);

      _isBuying = false;
      notifyListeners();

      return ComboOrderResponse(
        result: ComboOrderResult.success,
        orderData: _orderResponse!.data,
      );
    } on ProfileNotUpdatedException {
      _error = 'Please update your profile first';
      return ComboOrderResponse(
        result: ComboOrderResult.profileNotUpdated,
        message: _error,
      );
    } on AddressNotUpdatedException {
      _error = 'Please add delivery address';
      return ComboOrderResponse(
        result: ComboOrderResult.addressNotUpdated,
        message: _error,
      );
    } catch (e) {
      log('Combo order error: ${e.toString()}');
      String errorMessage = e.toString().toLowerCase();
      String displayMessage = e
          .toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Failed to place order: ', '');

      ComboOrderResult resultType;
      String message;

      if (errorMessage.contains('login') ||
          errorMessage.contains('session expired') ||
          errorMessage.contains('authentication')) {
        resultType = ComboOrderResult.loginRequired;
        message = displayMessage;
      } else if (errorMessage.contains('status code of 500') ||
          errorMessage.contains('server error')) {
        resultType = ComboOrderResult.serverError;
        message = "Server is temporarily unavailable. Please try again later.";
      } else if (errorMessage.contains('delivery not available') ||
          errorMessage.contains('pincode') ||
          errorMessage.contains('delivery')) {
        resultType = ComboOrderResult.deliveryUnavailable;
        message = displayMessage;
      } else if (errorMessage.contains('internet') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout') ||
          errorMessage.contains('network')) {
        resultType = ComboOrderResult.networkError;
        message = displayMessage;
      } else if (errorMessage.contains('not found') ||
          errorMessage.contains('not available') ||
          errorMessage.contains('no longer')) {
        resultType = ComboOrderResult.comboUnavailable;
        message =
            'This combo offer is no longer available. Please check other offers.';
      } else {
        resultType = ComboOrderResult.genericError;
        message = displayMessage.isNotEmpty
            ? displayMessage
            : "Something went wrong. Please try again.";
      }

      _error = message;
      return ComboOrderResponse(
        result: resultType,
        message: message,
      );
    } finally {
      _isBuying = false;
      notifyListeners();
    }
  }
}
