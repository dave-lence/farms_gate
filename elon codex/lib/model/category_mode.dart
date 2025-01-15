import 'package:farms_gate_marketplace/model/product_model.dart';

class CategoryModel {
  final String name;
  final List<ProductModel> products;

  CategoryModel({
    required this.name,
    required this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String,
      products: (json['products'] as List<dynamic>)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
