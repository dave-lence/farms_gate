import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/address_model.dart';
import 'package:farms_gate_marketplace/model/bank_model.dart';
import 'package:farms_gate_marketplace/model/transaction_model.dart';
import 'package:farms_gate_marketplace/model/wallet_model.dart';
import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/ui/screens/payment_screen.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletRepo {
  final Urls url = Urls();


  Future<WalletModel> fetchWalletData(BuildContext context) async {
    final String fetchWalletUrl = url.walletUrl;

    try {
      // Get the bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Make the GET request
      final response = await http.get(
        Uri.parse(fetchWalletUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle successful response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Ensure the response contains the expected "data" key
        if (data.containsKey('data')) {
          return WalletModel.fromJson(data['data']);
        } else {
          throw Exception('Invalid response format: missing "data" key');
        }
      } else if (response.statusCode == 401) {
        final data = json.decode(response.body);
        showCustomToast(context, data['messag'], '', ToastType.error);
        throw Exception('Unauthorized access. Please log in again. ');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final data = json.decode(response.body);
        final message =
            data['message'] ?? 'An error occurred on the client side';
        showCustomToast(context, message, '', ToastType.error);
        throw Exception('Client-side error: $message');
      } else if (response.statusCode >= 500) {
        // Server-side error
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error. Status code: ${response.statusCode}');
      } else {
        // Other unexpected status codes
        showCustomToast(
            context, 'Unexpected error occurred.', '', ToastType.error);
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on SocketException {
      // Handle no internet connection
      showCustomToast(
          context,
          'No Internet connection. Please check your connection.',
          '',
          ToastType.error);
      throw Exception('No Internet connection');
    } on FormatException {
      // Handle invalid JSON response
      showCustomToast(
          context, 'Problem occured from the server.', '', ToastType.error);
      throw Exception('Invalid response format');
    } catch (e) {
      // Handle general errors
      showCustomToast(context, 'An error occurred.', '', ToastType.error);
      throw Exception('Error fetching wallet data: $e');
    }
  }

  Future<void> fetchTransactions(BuildContext context, int page) async {
    final String apiUrl = '${url.getTransactionHistory}?page=$page&limit=1';

    try {
     final transactionProvider = Provider.of<TransactionProvider>(context, listen:  false);
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
        List<TransactionModel> _transactions = [];

        _transactions =
            data.map((json) => TransactionModel.fromJson(json)).toList();

        transactionProvider.addTransaction(_transactions[0]);
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
      showCustomToast(context, 'No internet connection. Please check your network.', '', ToastType.error);
    } on TimeoutException {
      showCustomToast(context, 'The request timed out. Please try again later.', '', ToastType.error);
    } on FormatException {
      showCustomToast(context, 'Request faied. Please try reloading.', '', ToastType.error);
    } on Exception catch (e) {
       e.toString();
    } 
  }


  Future<List<BankModel>> fetchBanks(BuildContext context) async {
    final String fetchWalletUrl = url.fetchBanksUrl;

    try {
      // Get the bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Make the GET request
      final response = await http.get(
        Uri.parse(fetchWalletUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle successful response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        // Ensure the response contains the expected "data" key
        if (data.containsKey('data')) {
          List<dynamic> banksData = data['data'];
          return banksData.map((bank) => BankModel.fromJson(bank)).toList();
        } else {
          throw Exception('Invalid response format: missing "data" key');
        }
      } else if (response.statusCode == 401) {
        final data = json.decode(response.body);
        showCustomToast(context, data['messag'], '', ToastType.error);
        throw Exception('Unauthorized access. Please log in again. ');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final data = json.decode(response.body);
        final message =
            data['message'] ?? 'An error occurred on the client side';
        showCustomToast(context, message, '', ToastType.error);
        throw Exception('Client-side error: $message');
      } else if (response.statusCode >= 500) {
        // Server-side error
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error. Status code: ${response.statusCode}');
      } else {
        // Other unexpected status codes
        showCustomToast(
            context, 'Unexpected error occurred.', '', ToastType.error);
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on SocketException {
      // Handle no internet connection
      showCustomToast(
          context,
          'No Internet connection. Please check your connection.',
          '',
          ToastType.error);
      throw Exception('No Internet connection');
    } on FormatException {
      // Handle invalid JSON response
      showCustomToast(
          context, 'Problem occured from the server.', '', ToastType.error);
      throw Exception('Invalid response format');
    } catch (e) {
      // Handle general errors
      showCustomToast(context, 'An error occurred.', '', ToastType.error);
      throw Exception('Error fetching wallet data: $e');
    }
  }

  Future<void> postUsersAddress(
      BuildContext context, AddressModel userAddressBody) async {
    final String postUserAddressUrl = url.postUserAddressForChckout;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.patch(
        Uri.parse(postUserAddressUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userAddressBody.toJson()),
      );

      print(userAddressBody.toJson());
      if (response.statusCode == 200) {
        // final data = json.decode(response.body)['data'];
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PaymentScreen()));
      } else {
        final data = json.decode(response.body)['data'];
        showCustomToast(context, data['message'], '', ToastType.error);
        throw Exception('Failed to load address data');
      }
    } catch (e) {
      showCustomToast(context, 'Error posting request', '', ToastType.error);
      throw Exception('Error fetching address data: $e');
    }
  }

  Future<Map<String, dynamic>?> validateBankDetails(
      BuildContext context, String bankCode, String accountNumber) async {
    final String validateBankDetailsUrl = url.validateBankDetailsUrl;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.post(
        Uri.parse(validateBankDetailsUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body:
            jsonEncode({"accountNumber": accountNumber, "bankCode": bankCode}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 400) {
        // Bad request
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['data']['message'] ?? 'Invalid request parameters',
            '',
            ToastType.error);
        throw Exception('Bad request: ${errorData['data']['message']}');
      } else if (response.statusCode == 401) {
        // Unauthorized
        showCustomToast(context, 'Unauthorized access', '', ToastType.error);
        throw Exception('Unauthorized access');
      } else if (response.statusCode == 404) {
        // Not found
        showCustomToast(context, 'Bank details not found', '', ToastType.error);
        throw Exception('Bank details not found');
      } else if (response.statusCode == 500) {
        // Internal server error
        showCustomToast(context, 'Server error, please try again later', '',
            ToastType.error);
        throw Exception('Internal server error');
      } else {
        // Other status codes
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['data']['message'] ?? 'An unexpected error occurred',
            '',
            ToastType.error);
        throw Exception('Unexpected error: ${errorData['data']['message']}');
      }
    } on http.ClientException catch (e) {
      showCustomToast(
          context, 'Network error: ${e.message}', '', ToastType.error);
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      showCustomToast(context, 'Invalid response format', '', ToastType.error);
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Error fetching user bank data: $e');
    }
  }

  Future<Map<String, dynamic>?> getOtp(BuildContext context) async {
    final String getOtpUrl = url.getOtp;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.post(
        Uri.parse(getOtpUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.of(context).pushNamed('/enter_txn_pin_model');

        return data;
      } else if (response.statusCode == 400) {
        // Bad request
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['message'] ?? 'Invalid request parameters',
            '',
            ToastType.error);
        throw Exception('Bad request: ${errorData['message']}');
      } else if (response.statusCode == 401) {
        // Unauthorized
        showCustomToast(context, 'Unauthorized access', '', ToastType.error);
        throw Exception('Unauthorized access');
      } else if (response.statusCode == 404) {
        // Not found
        showCustomToast(context, 'Resource not found', '', ToastType.error);
        throw Exception('Resource not found');
      } else if (response.statusCode == 500) {
        // Internal server error
        showCustomToast(context, 'Server error, please try again later', '',
            ToastType.error);
        throw Exception('Internal server error');
      } else {
        // Other status codes
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['message'] ?? 'An unexpected error occurred',
            '',
            ToastType.error);
        throw Exception('Unexpected error: ${errorData['message']}');
      }
    } on http.ClientException catch (e) {
      showCustomToast(
          context, 'Network error: ${e.message}', '', ToastType.error);
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      showCustomToast(context, 'Invalid response format', '', ToastType.error);
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Error fetching OTP: $e');
    }
  }

  Future<void> withdrawFunds(BuildContext context, String otpCode) async {
    final String getOtpUrl = url.widthrawUrl;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.post(Uri.parse(getOtpUrl),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "amount": 1000,
            "bankCode": "044",
            "accountNumber": "0690000032",
            "accountName": "Pastor Bright",
            "walletType": "main_wallet",
            "otp": otpCode
          }));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.pushNamed(context, '/trans_success_model');
        return data;
      } else if (response.statusCode == 400) {
        // Bad request
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['message'] ?? 'Invalid request parameters',
            '',
            ToastType.error);
        throw Exception('Bad request: ${errorData['message']}');
      } else if (response.statusCode == 401) {
        // Unauthorized
        showCustomToast(context, 'Unauthorized access', '', ToastType.error);
        throw Exception('Unauthorized access');
      } else if (response.statusCode == 404) {
        // Not found
        showCustomToast(context, 'Resource not found', '', ToastType.error);
        throw Exception('Resource not found');
      } else if (response.statusCode == 500) {
        // Internal server error
        showCustomToast(context, 'Server error, please try again later', '',
            ToastType.error);
        throw Exception('Internal server error');
      } else {
        // Other status codes
        final errorData = json.decode(response.body);
        showCustomToast(
            context,
            errorData['message'] ?? 'An unexpected error occurred',
            '',
            ToastType.error);
        throw Exception('Unexpected error: ${errorData['message']}');
      }
    } on http.ClientException catch (e) {
      showCustomToast(
          context, 'Network error: ${e.message}', '', ToastType.error);
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      showCustomToast(context, 'Invalid response format', '', ToastType.error);
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Error fetching OTP: $e');
    }
  }

  Future<bool> initiateFlutterwavePayment(BuildContext context) async {
    final String initializeUrl = url.initializeGateWay;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      final response = await http.post(
        Uri.parse(initializeUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "returnUrl": "https://farmsgate-frontend-pb.vercel.app//cart_screen",
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        await launchInBrowserView(data['link']);
        return true;
      } else {
        final data = json.decode(response.body);
        final errorMessage = data['message'] ?? 'An unknown error occurred';
        showCustomToast(context, errorMessage, '', ToastType.error);
        return false;
      }
    } on SocketException {
      showCustomToast(
          context,
          'No internet connection. Please try again later.',
          '',
          ToastType.error);
      return false;
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
      return false;
    } on FormatException {
      showCustomToast(
          context,
          'Invalid response from the server. Please try again later.',
          '',
          ToastType.error);
      return false;
    } catch (e) {
      showCustomToast(
          context, 'An unexpected error occurred', '', ToastType.error);
      print('Error: $e');
      return false;
    }
  }

  Future topUpWallet(BuildContext context, int amount) async {
    final String topUpUrl = url.topUpWalletUrl;

    try {
      // Retrieve bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Make the POST request
      final response = await http.post(
        Uri.parse(topUpUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": amount,
          "returnUrl":
              "https://farmsgate-frontend-pb.vercel.app//wallet_screen",
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Ensure "data" key exists and contains the expected "link"
        if (responseBody.containsKey('data') &&
            responseBody['data']['link'] != null) {
          final data = responseBody['data'];
          launchInBrowserView(data['link']);
        } else {
          throw Exception('Invalid response format: Missing "data" or "link"');
        }
      } else if (response.statusCode == 401) {
        // Unauthorized access
        showCustomToast(
            context, 'Unauthorized. Please log in again.', '', ToastType.error);
        throw Exception('Unauthorized access. Status code: 401');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client-side error
        final responseBody = json.decode(response.body);
        final errorMessage =
            responseBody['message'] ?? 'A client-side error occurred';
        showCustomToast(context, errorMessage, '', ToastType.error);
        throw Exception('Client-side error: $errorMessage');
      } else if (response.statusCode >= 500) {
        // Server-side error
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error. Status code: ${response.statusCode}');
      } else {
        // Unexpected status code
        showCustomToast(
            context, 'Unexpected error occurred.', '', ToastType.error);
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on SocketException {
      // No internet connection
      showCustomToast(
          context,
          'No Internet connection. Please check your connection.',
          '',
          ToastType.error);
      throw Exception('No Internet connection');
    } on FormatException {
      // Invalid JSON response
      showCustomToast(context, 'Error from the server .', '', ToastType.error);
      throw Exception('Invalid response format');
    } catch (e) {
      // General error handling
      showCustomToast(context, 'An error occurred.', '', ToastType.error);
      throw Exception('Error during top-up: $e');
    }
  }

  Future<void> launchInBrowserView(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $uri');
    }
  }
}
