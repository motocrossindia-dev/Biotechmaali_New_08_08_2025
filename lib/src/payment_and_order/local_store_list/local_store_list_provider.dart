import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/local_store_list/model/local_store_model.dart';
import 'package:flutter/material.dart';
import 'local_store_list_repository.dart';

class LocalStoreListProvider extends ChangeNotifier {
  final LocalStoreListRepository _repository = LocalStoreListRepository();

  int selectedStoreIndex = 0;
  LocalStoreModel? _selectedStore;
  List<LocalStoreModel> _stores = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<LocalStoreModel> get stores => _stores;
  bool get isLoading => _isLoading;
  String? get error => _error;
  LocalStoreModel? get selectedStore => _selectedStore;

  void setSelectedStoreModel(LocalStoreModel store) {
    log("selected store : ${store.contact}");
    _selectedStore = store;
    selectedStoreIndex = _stores.indexOf(store);
    notifyListeners();
  }

  void setSelectedStore(int index) {
    selectedStoreIndex = index;
    notifyListeners();
  }

  Future<void> fetchStores() async {
    _isLoading = true;
    _error = null;
    // notifyListeners();

    try {
      _stores = await _repository.getStores();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      log('Error fetching stores: $e');
      notifyListeners();
    }
  }
}
