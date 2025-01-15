import 'dart:convert';

class ProductModel {
  final String id;
  final String? productId;
  final String? category;
  final String? createdAt;
  final String description;
  final String farmerId;
  final String farmName;
  final List<String> images;
  final int inStock;
  final bool isMarketable;
  final String? location;
  final double marketPrice;
  final String name;
  final String? updatedAt;

  ProductModel({
    required this.id,
    this.productId,
    this.category,
    this.createdAt,
    required this.description,
    required this.farmerId,
    this.farmName = 'Not available',
    required this.images,
    required this.inStock,
    required this.isMarketable,
    this.location,
    required this.marketPrice,
    required this.name,
    this.updatedAt,
  });

  /// Factory constructor for creating a new Product instance from a map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      productId: json['productId'],
      category: json['category'],
      createdAt: json['created_at'],
      description: json['description'] ?? '',
      farmerId: json['farmerId'] ?? '',
      farmName: json['farmName'] ?? 'Not available',
      images: (json['images'] is String)
          ? List<String>.from(jsonDecode(json['images']))
          : (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      inStock: json['inStock'] ?? 0,
      isMarketable: json['isMarketable'] == true || json['isMarketable'] == 1,
      location: json['location'],
      marketPrice: (json['marketPrice'] as num?)?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  /// Method to convert a Product instance to a map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'category': category,
      'created_at': createdAt,
      'description': description,
      'farmerId': farmerId,
      'farmName': farmName,
      'images': images,
      'inStock': inStock,
      'isMarketable': isMarketable ? 1 : 0,
      'location': location,
      'marketPrice': marketPrice,
      'name': name,
      'updated_at': updatedAt,
    };
  }
}
