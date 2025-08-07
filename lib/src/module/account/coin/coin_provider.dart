import 'dart:developer';

import 'package:biotech_maali/src/module/account/coin/model/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:biotech_maali/src/module/account/coin/coin_repository.dart';

class CoinProvider extends ChangeNotifier {
  // Singleton pattern

  CoinProvider() {
    fetchTransactions();
  }

  final CoinRepository _repository = CoinRepository();

  // Coin balance
  int _coinBalance = 0;
  int get coinBalance => _coinBalance;

  // Redemption rates - these could come from API in the future
  final double _redemptionRate = 10.0; // ₹5 per 100 coins
  double get redemptionRate => _redemptionRate;

  // Earn rate
  final int _earnRate = 1; // 1 coin per ₹10 spent
  int get earnRate => _earnRate;

  // Transaction history
  List<CoinTransaction> _coinTransactions = [];
  List<CoinTransaction> get coinTransactions => _coinTransactions;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  // Filter
  String _selectedFilter = 'all';
  String get selectedFilter => _selectedFilter;

  // Controller for redeeming coins
  final TextEditingController redeemController = TextEditingController();

  @override
  void dispose() {
    redeemController.dispose();
    super.dispose();
  }

  // Getter for filtered transactions
  List<CoinTransaction> get filteredTransactions {
    if (_selectedFilter == 'all') {
      return _coinTransactions;
    } else if (_selectedFilter == 'earned') {
      return _coinTransactions
          .where((t) => t.transactionType == 'EARN')
          .toList();
    } else {
      // ignore: unrelated_type_equality_checks
      return _coinTransactions
          .where((t) => t.transactionType == 'SPEND')
          .toList();
    }
  }

  // Getter for total earned coins
  int get totalEarned {
    return _coinTransactions
        .where((t) => t.transactionType == 'EARN')
        .fold(0, (sum, t) => sum + t.coins);
  }

  // Getter for total spent coins
  int get totalSpent {
    return _coinTransactions
        .where((t) => t.transactionType == 'SPEND')
        .fold(0, (sum, t) => sum + t.coins);
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Fetch transactions from API
  Future<void> fetchTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      // notifyListeners();

      final transactions = await _repository.fetchCoinTransactions();
      _coinTransactions = transactions;

      // Calculate current balance
      _calculateBalance();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Calculate balance based on transactions
  void _calculateBalance() {
    int earned = _coinTransactions
        .where((t) => t.transactionType == 'EARN')
        .fold(0, (sum, t) => sum + t.coins);

    int spent = _coinTransactions
        .where((t) => t.transactionType.contains('SPEND'))
        .fold(0, (sum, t) => sum + t.coins);

    _coinBalance = earned - spent;
    log("coin balance: $_coinBalance, earned: $earned, spent: $spent");
    notifyListeners();
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  // Redeem coins
  Future<bool> redeemCoins(int amount) async {
    if (amount <= 0) {
      _error = 'Invalid amount';
      return false;
    }

    try {
      _error = null; // Clear any previous error

      final success = await _repository.redeemCoins(amount);

      if (success) {
        // Refresh transactions after successful redemption
        await refreshTransactions();
        return true;
      } else {
        _error = 'Redemption failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
