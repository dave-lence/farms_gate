import 'dart:async';

import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/transaction_model.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Urls urls = Urls();

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTransactions(BuildContext context, int page) async {
    final String apiUrl = '${urls.getTransactionHistory}?page=$page&limit=1';

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data']['result'];
        _transactions =
            data.map((json) => TransactionModel.fromJson(json)).toList();
        addTransaction(_transactions[0]);
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        showCustomToast(
            context,
            'Failed to load transactions:  ${errorResponse['message']}',
            '',
            ToastType.error);
        throw Exception(
            'Failed to load transactions: ${errorResponse['message'] ?? 'Unknown error'}');
      }
    } on SocketException {
      
      _errorMessage = 'No internet connection. Please check your network.';
      showCustomToast(
          context,
           _errorMessage!,
          '',
          ToastType.error);
    } on TimeoutException {
      _errorMessage = 'The request timed out. Please try again later.';
       showCustomToast(context, _errorMessage!, '', ToastType.error);
    } on FormatException {
      _errorMessage = 'Request faied. Please try reloading.';
       showCustomToast(context, _errorMessage!, '', ToastType.error);
    } on Exception catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  Timer? _refreshTimer;

  // Other methods...

  void startAutoRefresh(BuildContext context) {
    _refreshTimer?.cancel();
    _refreshTimer =
        Timer.periodic(Duration(seconds: 30), (_) => fetchTransactions(context, 1));
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
