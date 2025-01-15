class NegotiatedProductModel {
  final String id;
  final String productName;
  final String? farmName;
  final int currentPrice;
  final int proposedPrice;
  final String status;
  final List<String> productImages;

  NegotiatedProductModel({
    required this.id,
    required this.productName,
    this.farmName,
    required this.currentPrice,
    required this.proposedPrice,
    required this.status,
    required this.productImages,
  });

  factory NegotiatedProductModel.fromJson(Map<String, dynamic> json) {
    return NegotiatedProductModel(
      id: json['_id'],
      productName: json['productName'],
      farmName: json['farmName'],
      currentPrice: json['currentPrice'],
      proposedPrice: json['proposedPrice'],
      status: json['status'],
      productImages: List<String>.from(json['productImages']),
    );
  }
}

class NegotiationProductResponse {
  final List<NegotiatedProductModel> result;
  final int pageTotal;
  final int totalCount;
  final String message;
  final String status;

  NegotiationProductResponse({
    required this.result,
    required this.pageTotal,
    required this.totalCount,
    required this.message,
    required this.status,
  });

  factory NegotiationProductResponse.fromJson(Map<String, dynamic> json) {
    return NegotiationProductResponse(
      result: (json['data']['result'] as List)
          .map((item) => NegotiatedProductModel.fromJson(item))
          .toList(),
      pageTotal: json['data']['page_total'],
      totalCount: json['data']['total_count'],
      message: json['message'],
      status: json['status'],
    );
  }
}
