import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/negotiated_product_model.dart';
import 'package:farms_gate_marketplace/model/order_model.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/saved_item_provider.dart';
import 'package:farms_gate_marketplace/ui/screens/confrim_order_screen.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final url = Urls();

  Future<NegotiationProductResponse> fetchNegotiatedProducts(
      int page, BuildContext context) async {
    final getNegotiatedProduct =
        Uri.parse('${url.getNegotiatedProduct}?limit=10&page=$page');

    try {
      // Retrieve the bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        throw Exception('Authentication token is missing.');
      }

      // Make the API request
      final response = await http.get(
        getNegotiatedProduct,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle HTTP response codes
      switch (response.statusCode) {
        case 200:
          return NegotiationProductResponse.fromJson(jsonDecode(response.body));
        case 400:
          showCustomToast(context, 'Invalid request. Please try again.', '',
              ToastType.error);
          throw Exception('Invalid request. Please try again.');
        case 401:
          showCustomToast(context, 'Unauthorized access. Please log in again.',
              '', ToastType.error);
          throw Exception('Unauthorized access. Please log in again.');
        case 403:
          showCustomToast(
              context,
              'You do not have permission to access this resource.',
              '',
              ToastType.error);
          throw Exception(
              'You do not have permission to access this resource.');
        case 404:
          showCustomToast(
              context, 'Requested data not found.', '', ToastType.error);
          throw Exception('Requested data not found.');
        case 500:
          showCustomToast(context, 'Server error. Please try again later.', '',
              ToastType.error);
          throw Exception('Server error. Please try again later.');
        default:
          showCustomToast(context, 'Unexpected error: ${response.statusCode}',
              '', ToastType.error);
          throw Exception('Unexpected error: ${response.statusCode}');
      }
    } on SocketException {
      showCustomToast(
          context,
          'No internet connection. Please check your network.',
          '',
          ToastType.error);
      throw Exception('Server error. Please try again later.');
    } on FormatException {
      showCustomToast(context, 'Invalid response format from the server.', '',
          ToastType.error);
      throw Exception('Server error. Please try again later.');
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
      throw Exception('Server error. Please try again later.');
    } catch (e) {
      showCustomToast(
          context, 'An unexpected error occurred.', '', ToastType.error);
      throw Exception('Server error. Please try again later.');
    }
  }

  Future<void> postFavouriteItems(
      String productId, BuildContext context, ProductModel product) async {
    final favouriteProvider =
        Provider.of<SavedItemProvider>(context, listen: false);
    final postFavProduct = '${url.postFavItem}$productId';

    try {
      // Retrieve the bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        return;
      }

      // Make the API request
      final response = await http.post(
        Uri.parse(postFavProduct),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle HTTP response codes
      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          favouriteProvider.addToSavedItemss(product);
          showCustomToast(
              context, responseBody['message'], '', ToastType.success);
          break;
        case 400:
          showCustomToast(context, 'Invalid request. Please try again.', '',
              ToastType.error);
          break;
        case 401:
          showCustomToast(context, 'Unauthorized access. Please log in again.',
              '', ToastType.error);
          break;
        case 403:
          showCustomToast(
              context,
              'You do not have permission to save this product.',
              '',
              ToastType.error);
          break;
        case 404:
          showCustomToast(context, 'Product not found.', '', ToastType.error);
          break;
        case 500:
          showCustomToast(context, 'Server error. Please try again later.', '',
              ToastType.error);
          break;
        default:
          showCustomToast(context, 'Unexpected error: ${response.statusCode}',
              '', ToastType.error);
          break;
      }
    } on SocketException {
      showCustomToast(
          context,
          'No internet connection. Please check your network.',
          '',
          ToastType.error);
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
    } on FormatException {
      showCustomToast(context, 'Invalid response format from the server.', '',
          ToastType.error);
    } catch (e) {
      showCustomToast(
          context, 'An unexpected error occurred.', '', ToastType.error);
    }
  }

  Future<void> postCartItems(
      BuildContext context, List<Map<String, dynamic>> cartBody) async {
    final postCartItems = url.checkOutUrl;

    try {
      // Retrieve bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        return;
      }
      // API request
      final response = await http.post(
        Uri.parse(postCartItems),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"items": cartBody}),
      );

      // Handle HTTP response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
            jsonDecode(response.body)['data'];

        final int serviceCharge = responseBody['serviceCharge'];
        final int subTotal = responseBody['subTotal'];
        final int total = responseBody['total'];

        // Navigate to ConfirmOrderScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfrimOrderScreen(
              serviceCharge: serviceCharge,
              subTotal: subTotal,
              total: total,
            ),
          ),
        );
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody.containsKey('message')
            ? responseBody['message']
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '') // Handle array response
            : 'Client error occurred. Please try again.';
        showCustomToast(context, message, '', ToastType.error);
      } else if (response.statusCode >= 500) {
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
      } else {
        showCustomToast(
            context,
            'Unexpected error occurred. Status code: ${response.statusCode}',
            '',
            ToastType.error);
      }
    } on SocketException {
      showCustomToast(
          context,
          'No internet connection. Please check your network.',
          '',
          ToastType.error);
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
    } on FormatException {
      showCustomToast(context, 'Invalid response format from the server.', '',
          ToastType.error);
    } catch (e) {
      showCustomToast(
          context, 'An unexpected error occurred: $e', '', ToastType.error);
    }
  }

  Future<void> deleteFavouriteItems(
      String productId, BuildContext context, ProductModel product) async {
    final favouriteProvider =
        Provider.of<SavedItemProvider>(context, listen: false);

    final deleteFavProduct = '${url.deleteSavedItem}$productId';

    try {
      // Retrieve bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        return;
      }

      // Make the API call
      final response = await http.delete(
        Uri.parse(deleteFavProduct),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle HTTP response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Update provider and show success message
        favouriteProvider.removeFromSavedItemss(product);
        showCustomToast(
            context, responseBody['message'], '', ToastType.success);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody.containsKey('message')
            ? responseBody['message']
            : 'Client error occurred. Please try again.';
        showCustomToast(context, message, '', ToastType.error);
      } else if (response.statusCode >= 500) {
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
      } else {
        showCustomToast(
            context,
            'Unexpected error occurred. Status code: ${response.statusCode}',
            '',
            ToastType.error);
      }
    } on SocketException {
      showCustomToast(
          context,
          'No internet connection. Please check your network.',
          '',
          ToastType.error);
    } on TimeoutException {
      showCustomToast(context, 'Request timed out. Please try again later.', '',
          ToastType.error);
    } on FormatException {
      showCustomToast(context, 'Invalid response format from the server.', '',
          ToastType.error);
    } catch (e) {
      showCustomToast(
          context, 'An unexpected error occurred: $e', '', ToastType.error);
    }
  }

  Future<List<ProductModel>> getAllProducts(int page, BuildContext context) async {
    String getProdUrl = '${url.getAllProducts}?limit=10&page=$page';

    try {
      // Retrieve bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Check if token is expired
      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        throw Exception('Authentication token has expired.');
      }

      // Make the API call
      final response = await http.get(
        Uri.parse(getProdUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle HTTP response
      if (response.statusCode == 200) {
        final Map<String, dynamic> productJson = jsonDecode(response.body);

        if (productJson.containsKey('data') &&
            productJson['data'].containsKey('result')) {
          final List<dynamic> productData = productJson['data']['result'];

          return productData
              .map((product) => ProductModel.fromJson(product))
              .toList();
        } else {
          showCustomToast(context, 'Unexpected response.', '', ToastType.error);
          throw Exception('Unexpected response structure.');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody.containsKey('message')
            ? responseBody['message']
            : 'Client error occurred. Please try again.';
        showCustomToast(context, message, '', ToastType.error);
        throw Exception(message);
      } else if (response.statusCode >= 500) {
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error occurred.');
      } else {
        showCustomToast(
            context,
            'Unexpected error occurred. Status code: ${response.statusCode}',
            '',
            ToastType.error);
        throw Exception(
            'Unexpected error occurred. Status code: ${response.statusCode}');
      }
    } on SocketException {
      showCustomToast(context, 'No internet connection.', '', ToastType.error);
      throw Exception('No internet connection.');
    } on TimeoutException {
      showCustomToast(context, 'Request timed out.', '', ToastType.error);
      throw Exception('Request timed out.');
    } on FormatException {
      showCustomToast(
          context, 'Invalid response format from server.', '', ToastType.error);
      throw Exception('Invalid response format from server.');
    } catch (error) {
      showCustomToast(
          context, 'An unexpected error occurred: $error', '', ToastType.error);
      throw Exception('An unexpected error occurred: $error');
    }
  }

  Future<List<MyOrderModel>> getOrderedProducts(
      BuildContext context, String? status) async {
    String getProdUrl = status!.isNotEmpty
        ? '${url.getOrders}?limit=10&page=1&status=$status'
        : url.getOrders;

    try {
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        throw Exception('Authentication token has expired.');
      }

      final response = await http.get(
        Uri.parse(getProdUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> productJson = jsonDecode(response.body);
        final List<dynamic> resultData = productJson['data']['result'];

        final products = resultData.map((order) {
          final productInfo = order['productInfo'];
          return MyOrderModel(
            id: order['_id'],
            orderNo: order['orderNo'],
            userId: order['userId'],
            farmerId: order['farmerId'],
            productName: productInfo['name'],
            images: List<String>.from(productInfo['images']),
            productId: productInfo['productId'],
            amount: productInfo['amount'],
            quantity: productInfo['quantity'],
            status: order['status'],
            createdAt: order['createdAt'],
            description: productInfo['description'] ?? '',
            farmName: productInfo['farmName'] ?? '',
            location: productInfo['location'] ?? '',
          );
        }).toList();

        return products;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody.containsKey('message')
            ? responseBody['message']
            : 'Client error occurred. Please try again.';
        showCustomToast(context, message, '', ToastType.error);
        throw Exception(message);
      } else if (response.statusCode >= 500) {
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error occurred.');
      } else {
        showCustomToast(
            context,
            'Unexpected error occurred. Status code: ${response.statusCode}',
            '',
            ToastType.error);
        throw Exception(
            'Unexpected error occurred. Status code: ${response.statusCode}');
      }
    } on SocketException {
      showCustomToast(context, 'No internet connection.', '', ToastType.error);
      throw Exception('No internet connection.');
    } on TimeoutException {
      showCustomToast(context, 'Request timed out.', '', ToastType.error);
      throw Exception('Request timed out.');
    } on FormatException {
      showCustomToast(
          context, 'Invalid response format from server.', '', ToastType.error);
      throw Exception('Invalid response format from server.');
    } catch (error) {
      showCustomToast(
          context, 'An unexpected error occurred: $error', '', ToastType.error);
      throw Exception('An unexpected error occurred: $error');
    }
  }

  Future<void> fetchSavedProducts(BuildContext context, int page) async {
    try {
      final savedItemProvider =
          Provider.of<SavedItemProvider>(context, listen: false);

      final getSavedItemsUrl =
          Uri.parse('${url.fetchedSavedItems}?page=$page&limit=10');

      // Retrieve and validate the bearer token
      final prefs = await SharedPreferences.getInstance();
      String bearerToken = prefs.getString('bearer') ?? '';

      // Check if the token is expired
      if (JwtDecoder.isExpired(bearerToken)) {
        showCustomToast(
            context,
            'Authentication token has expired. Please log in again.',
            '',
            ToastType.error);
        throw Exception('Authentication token has expired.');
      }

      // Make the API call
      final response = await http.get(
        getSavedItemsUrl,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // Handle the API response
      if (response.statusCode == 200) {
        final Map<String, dynamic> productJson = jsonDecode(response.body);

        if (productJson.containsKey('data') &&
            productJson['data'].containsKey('result')) {
          final List<dynamic> productData = productJson['data']['result'];

          productData
              .map((item) => ProductModel.fromJson(item))
              .forEach((product) {
            savedItemProvider.addToSavedItemss(product);
          });

          // savedItemProvider.savedItems
          //     .addAll(productData.map((item) => ProductModel.fromJson(item)));
        } else {
          showCustomToast(
              context, 'Unexpected response structure.', '', ToastType.error);
          throw Exception('Unexpected response structure.');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody.containsKey('message')
            ? responseBody['message']
            : 'Client error occurred. Please try again.';
        showCustomToast(context, message, '', ToastType.error);

        throw Exception(message);
      } else if (response.statusCode >= 500) {
        showCustomToast(context, 'Server error. Please try again later.', '',
            ToastType.error);
        throw Exception('Server error occurred.');
      } else {
        showCustomToast(
            context,
            'Unexpected error occurred. Status code: ${response.statusCode}',
            '',
            ToastType.error);
        throw Exception(
            'Unexpected error occurred. Status code: ${response.statusCode}');
      }
    } on SocketException {
      showCustomToast(context, 'No internet connection.', '', ToastType.error);
      throw Exception('No internet connection.');
    } on TimeoutException {
      showCustomToast(context, 'Request timed out.', '', ToastType.error);
      throw Exception('Request timed out.');
    } on FormatException {
      showCustomToast(
          context, 'Invalid response format from server.', '', ToastType.error);
      throw Exception('Invalid response format from server.');
    } catch (error) {
      showCustomToast(
          context, 'An unexpected error occurred: $error', '', ToastType.error);
      throw Exception('An unexpected error occurred: $error');
    }
  }
}
