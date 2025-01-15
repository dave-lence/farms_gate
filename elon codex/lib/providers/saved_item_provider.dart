import 'dart:convert';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedItemProvider extends ChangeNotifier {
  final url = Urls();
  final List<ProductModel> _savedItems = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isSaved(ProductModel product) {
    return _savedItems.contains(product);
  }

  List<ProductModel> get savedItems => List.unmodifiable(_savedItems);

  void addToSavedItemss(ProductModel product) {
    _savedItems.add(product);
    notifyListeners();
  }

  void removeFromSavedItemss(ProductModel product) {
    _savedItems.removeWhere((item) => item.productId == product.productId);
    notifyListeners();
  }

  void initializeSavedItems(List<ProductModel> items) {
    _savedItems.clear();
    _savedItems.addAll(items);
    notifyListeners();
  }

  Future<void> fetchSavedProducts(BuildContext context, int page) async {
    setLoading(true);

    final getNegotiatedProduct = Uri.parse('${url.fetchedSavedItems}?page=$page&limit=10');
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';

    final response = await http.get(
      getNegotiatedProduct,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> productJson = jsonDecode(response.body);

      final List<dynamic> productData = productJson['data']['result'];

      _savedItems.clear();
      _savedItems
          .addAll(productData.map((item) => ProductModel.fromJson(item)));
      setLoading(false);

      notifyListeners();
    } else {
      setLoading(false);

      throw Exception('Failed to load products');
    }
  }
}
