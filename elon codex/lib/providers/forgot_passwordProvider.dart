// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final url = Urls();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> forgotPassword(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.forgotPassUrl;

    _isLoading = true;
    notifyListeners();
    if (userData.isEmpty ||
        userData.values
            .any((value) => value == null || value.toString().trim().isEmpty)) {
      showCustomToast(context, 'Email field is required.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      if (!hasInternetAccess) {
        showCustomToast(
            context, 'No Internet Connection.', '', ToastType.error);
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
          'ETag': 'W/"12f-JwG1I+gs8S1fwrz8hdW5uAEeD2Q"',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        showCustomToast(context, resBody['message'], '', ToastType.success);
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', resBody['data']['_id']);
        } catch (e) {
          // print('Error saving to SharedPreferences: $e');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        if (resBody.containsKey('message')) {
          if (resBody['message'] is String) {
            showCustomToast(context, resBody['message'], '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          } else if (resBody['message'] is List) {
            List<String> messages = List<String>.from(resBody['message']);
            for (var message in messages) {
              showCustomToast(context, message, '', ToastType.error);
              _isLoading = false;
              notifyListeners();
            }
          } else {
            showCustomToast(
                context, 'An unexpected error occurred', '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          }
        } else {
          showCustomToast(
              context, 'An unknown error occurred', '', ToastType.error);
          _isLoading = false;
          notifyListeners();
        }

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.resetPassword;

    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';

    InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      if (!hasInternetAccess) {
        showCustomToast(
            context, 'No Internet Connection.', '', ToastType.error);
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
          'ETag': 'W/"12f-JwG1I+gs8S1fwrz8hdW5uAEeD2Q"',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        showCustomToast(context, resBody['message'], '', ToastType.success);

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'userLoginDetails', jsonEncode(resBody['data']));
        } catch (e) {
          // print('Error saving to SharedPreferences: $e');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        if (resBody.containsKey('message')) {
          if (resBody['message'] is String) {
            showCustomToast(context, resBody['message'], '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          } else if (resBody['message'] is List) {
            List<String> messages = List<String>.from(resBody['message']);
            for (var message in messages) {
              showCustomToast(context, message, '', ToastType.error);
              _isLoading = false;
              notifyListeners();
            }
          } else {
            showCustomToast(
                context, 'An unexpected error occurred', '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          }
        } else {
          showCustomToast(
              context, 'An unknown error occurred', '', ToastType.error);
          _isLoading = false;
          notifyListeners();
        }

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.verifyOtp;

    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';

    InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      if (!hasInternetAccess) {
        showCustomToast(
            context, 'No Internet Connection.', '', ToastType.error);
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
          'ETag': 'W/"12f-JwG1I+gs8S1fwrz8hdW5uAEeD2Q"',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        showCustomToast(context, resBody['message'], '', ToastType.success);

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'userLoginDetails', jsonEncode(resBody['data']));
        } catch (e) {
          // print('Error saving to SharedPreferences: $e');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        if (resBody.containsKey('message')) {
          if (resBody['message'] is String) {
            showCustomToast(context, resBody['message'], '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          } else if (resBody['message'] is List) {
            List<String> messages = List<String>.from(resBody['message']);
            for (var message in messages) {
              showCustomToast(context, message, '', ToastType.error);
              _isLoading = false;
              notifyListeners();
            }
          } else {
            showCustomToast(
                context, 'An unexpected error occurred', '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          }
        } else {
          showCustomToast(
              context, 'An unknown error occurred', '', ToastType.error);
          _isLoading = false;
          notifyListeners();
        }

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOtp(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.resendOtp;

    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';
    InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      if (!hasInternetAccess) {
        showCustomToast(
            context, 'No Internet Connection.', '', ToastType.error);
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
          'ETag': 'W/"12f-JwG1I+gs8S1fwrz8hdW5uAEeD2Q"',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        showCustomToast(context, resBody['message'], '', ToastType.success);

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', resBody['data']['_id']);

          await prefs.setString(
              'userLoginDetails', jsonEncode(resBody['data']));
        } catch (e) {
          // print('Error saving to SharedPreferences: $e');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        if (resBody.containsKey('message')) {
          if (resBody['message'] is String) {
            showCustomToast(context, resBody['message'], '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          } else if (resBody['message'] is List) {
            List<String> messages = List<String>.from(resBody['message']);
            for (var message in messages) {
              showCustomToast(context, message, '', ToastType.error);
              _isLoading = false;
              notifyListeners();
            }
          } else {
            showCustomToast(
                context, 'An unexpected error occurred', '', ToastType.error);
            _isLoading = false;
            notifyListeners();
          }
        } else {
          showCustomToast(
              context, 'An unknown error occurred', '', ToastType.error);
          _isLoading = false;
          notifyListeners();
        }

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
