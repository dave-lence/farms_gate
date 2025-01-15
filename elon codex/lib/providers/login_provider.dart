// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/user_model.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  
  bool _isLoading = false;
  String? _errorMessage;
  final url = Urls();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> loginUser(
      Map<String, dynamic> userData, BuildContext context) async {
    String postUrl = url.loginUrl;

    _isLoading = true;
    notifyListeners();

    // Validate user input
    if (userData.isEmpty ||
        userData.values
            .any((value) => value == null || value.toString().trim().isEmpty)) {
      showCustomToast(context, 'All fields are required.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Check for Internet connectivity
    bool hasInternetAccess =
        await InternetConnectivity().hasInternetConnection;
    if (!hasInternetAccess) {
      showCustomToast(context, 'No Internet Connection.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Powered-By': 'Express',
          'Access-Control-Allow-Origin': '*',
          'ETag': 'W/"1cf-GmaQcol3V8fuI2AF+bDS0RVL9os"',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5',
        },
        body: jsonEncode(userData),
      );

      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        // Save token and user details to SharedPreferences
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('bearer', resBody['token']);
          await prefs.setString(
              'userLoginDetails', jsonEncode(resBody['data']));
        } catch (e) {
          showCustomToast(
              context, 'Error saving user details.', '', ToastType.warning);
        }

        notifyListeners();
        return true; // Login successful
      } else {
        // Handle error response
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
      showCustomToast(context, 'Invalid server response.', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (error) {
      showCustomToast(
          context, 'An error occurred: $error', '', ToastType.error);
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserProfile> fetchUserProfile(BuildContext context) async {
    String profileUrl = url.getProfileUrl;
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';

    _isLoading = true;
    notifyListeners();

    try {
      // Send GET request
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Validate and parse data
        if (responseData.containsKey('data')) {
          final dynamic productData = responseData['data'];
          final userData = UserProfile.fromJson(productData);

          _isLoading = false;
          notifyListeners();
          return userData;
        } else {
          _isLoading = false;
          notifyListeners();
          throw Exception('Data key missing in response');
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        // Other status codes
         showCustomToast(
            context,
            'Failed to load profile.',
            '',
            ToastType.error);
        throw Exception(
            'Failed to load profile. Status code: ${response.statusCode}');
      }
    } on SocketException {
      _isLoading = false;
      notifyListeners();
       showCustomToast(
          context, 'No Internet connection. Please check your connection.', '', ToastType.error);
      throw Exception('No Internet connection. Please check your connection.');
    } on FormatException {
      _isLoading = false;
      notifyListeners();
      throw Exception('Invalid response format from server.');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
       showCustomToast(
          context,
          'An error occurred while loading profile. Please try again.',
          '',
          ToastType.error);
      throw Exception('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
