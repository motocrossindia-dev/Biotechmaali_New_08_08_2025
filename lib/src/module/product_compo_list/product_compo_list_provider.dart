import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_compo_list/model/product_compo_model.dart';
import 'package:biotech_maali/src/module/product_compo_list/product_compo_repository.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_repository.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCompoListProvider extends ChangeNotifier {
  final ProductCompoRepository _repository = ProductCompoRepository();
  bool _isLoading = false;
  String? _error;
  ProductCompoData? _comboData;
  OrderResponseModel? _orderResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  ProductCompoData? get comboData => _comboData;
  List<ComboOffer> get comboOffers => _comboData?.comboOffers ?? [];
  List<ComboOffer> get shopTheLook => _comboData?.shopTheLook ?? [];
  OrderResponseModel? get orderResponse => _orderResponse;

  Future<void> fetchComboOffers() async {
    try {
      _isLoading = true;
      _error = null;

      final response = await _repository.getComboOffers();
      _comboData = response.data;
    } catch (e) {
      _error = "Failed to fetch combo offers, something went wrong";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrderCompo(int productId, BuildContext context) async {
    try {
      _isLoading = true;
      _error = '';

      log('product id : $productId');
      _orderResponse = await _repository.buyComboProduct(productId);

      _isLoading = false;
      Fluttertoast.showToast(msg: "Order initiated successfully");
      context
          .read<OrderSummaryProvider>()
          .setOrderSummaryData(orderResponse!.data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSummaryScreen(
            // orderData: _orderResponse!.data,
            isSingleProduct: true,
          ),
        ),
      );
    } on ProfileNotUpdatedException {
      _error = 'Please update your profile first';
      Fluttertoast.showToast(msg: _error!);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EditProfileScreen(
                  isPlaceOrder: true,
                )),
      );
    } on AddressNotUpdatedException {
      _error = 'Please add delivery address';
      Fluttertoast.showToast(msg: _error!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddEditAddressScreen(
            isAddAddress: true,
          ),
        ),
      );
    } catch (e) {
      _error = "Failed to place order, something went wrong";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
