import 'dart:async';

import 'package:farms_gate_marketplace/model/wallet_model.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:flutter/material.dart';

class WalletProvider with ChangeNotifier {
  final WalletRepo _repository = WalletRepo();

  WalletModel? _walletData;
  bool _isLoading = false;
  bool _isTopUpLoading = false;
  String _errorMessage = '';

  WalletModel? get walletData => _walletData;
  bool get isLoading => _isLoading;
  bool get isTopUpLoading => _isTopUpLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWalletDetails(BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _walletData = await _repository.fetchWalletData(context);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> topUpWallet(BuildContext context, int amount) async {
    _isTopUpLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _walletData = await _repository.topUpWallet(context, amount);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isTopUpLoading = false;
      notifyListeners();
    }
  }
}
