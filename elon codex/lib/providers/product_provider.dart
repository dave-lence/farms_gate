// ignore_for_file: unused_field

import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo = ProductRepo();
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  bool _isLoading = false;

  Future<void> fetchAllProducts(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final response = await productRepo.getAllProducts( 1,context);
    _products = response;
    _isLoading = false;
    notifyListeners();
  }

 
}
