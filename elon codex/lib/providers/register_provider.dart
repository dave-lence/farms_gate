// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final url = Urls();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.registerUrl;

    _isLoading = true;
    notifyListeners();

    // Check for empty fields
    if (userData.isEmpty ||
        userData.values
            .any((value) => value == null || value.toString().trim().isEmpty)) {
      showCustomToast(context, 'All fields are required.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Check for internet connectivity
    bool hasInternetAccess = await InternetConnectivity().hasInternetConnection;
    if (!hasInternetAccess) {
      showCustomToast(context, 'No Internet Connection.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _handleErrorResponse(response, context);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on SocketException {
      showCustomToast(context, 'Network error. Please check your connection.',
          '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } on FormatException {
      showCustomToast(
          context, 'Invalid response format from server.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (error) {
      _errorMessage = 'An unexpected error occurred';
      showCustomToast(context, _errorMessage!, '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserDetails(
      Map<String, dynamic> userData, BuildContext context,
      {File? profileImage}) async {
    String postUrl = url.updateUserDetails;

    _isLoading = true;
    notifyListeners();

    // Check for empty fields
    if (userData.isEmpty) {
      showCustomToast(context, 'All fields are required.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Check for internet connectivity
    bool hasInternetAccess = await InternetConnectivity().hasInternetConnection;
    if (!hasInternetAccess) {
      showCustomToast(context, 'No Internet Connection.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Create multipart request
      final request = http.MultipartRequest('PATCH', Uri.parse(postUrl))
        ..headers.addAll({
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'multipart/form-data',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
        });

      // Add user data as form fields
      userData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add profile image if available
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', // Backend expects this field for the image
          profileImage.path,
        ));
      }

      // Send request and handle response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        showCustomToast(context, resBody['message'], '', ToastType.success);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print(response.body);

        _handleErrorResponse(response, context);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on SocketException {
      showCustomToast(context, 'Network error. Please check your connection.',
          '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } on FormatException {
      showCustomToast(
          context, 'Invalid response format from server.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (error) {
      _errorMessage = 'An unexpected error occurred';
      showCustomToast(context, _errorMessage!, '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _handleErrorResponse(http.Response response, BuildContext context) {
    try {
      final Map<String, dynamic> resBody = jsonDecode(response.body);
      if (resBody.containsKey('message')) {
        if (resBody['message'] is String) {
          showCustomToast(context, resBody['message'], '', ToastType.error);
        } else if (resBody['message'] is List) {
          List<String> messages = List<String>.from(resBody['message']);
          for (var message in messages) {
            showCustomToast(context, message, '', ToastType.error);
          }
        } else {
          showCustomToast(
              context, 'An unexpected error occurred.', '', ToastType.error);
        }
      } else {
        showCustomToast(
            context, 'An unknown error occurred.', '', ToastType.error);
      }
    } catch (e) {
      showCustomToast(
          context, 'Failed to send your request.', '', ToastType.error);
    }
  }
}
