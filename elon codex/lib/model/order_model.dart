import 'dart:convert';

class MyOrderModel {
  final String id;
  final String orderNo;
  final String userId;
  final String farmerId;
  final String productName;
  final String productId;
  final int amount;
  final List<String> images;
  final String farmName;
  final String location;
  final String description;

  final int quantity;
  final String status;
  final String createdAt;

  MyOrderModel({
    required this.id,
    required this.orderNo,
    required this.userId,
    required this.farmerId,
    required this.productName,
    required this.productId,
    required this.images,
    required this.description,
    required this.farmName ,
    required this.location,
    required this.amount,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      id: json['_id'],
      orderNo: json['orderNo'],
      userId: json['userId'],
      farmerId: json['farmerId'],
      description: json['description'],
      productName: json['name'],
      productId: json['productId'],
      farmName: json['farmName'] ?? 'Not available',
      images: (json['images'] is String)
          ? List<String>.from(jsonDecode(json['images']))
          : (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      amount: json['amount'],
      location: json['location'],
      quantity: json['quantity'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
}
