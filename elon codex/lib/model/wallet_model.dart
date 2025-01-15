class WalletModel {
  final String id;
  final String userId;
  final double balance; // Changed to double
  final double escrowBalance; // Changed to double
  final double lockedBalance; // Changed to double
  final String currencyCode;
  final String currencySymbol;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.escrowBalance,
    required this.lockedBalance,
    required this.currencyCode,
    required this.currencySymbol,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      balance:
          (json['balance'] as num).toDouble(), // Ensure it's parsed as double
      escrowBalance: (json['escrowbalance'] as num)
          .toDouble(), // Ensure it's parsed as double
      lockedBalance: (json['lockedbalance'] as num)
          .toDouble(), // Ensure it's parsed as double
      currencyCode: json['currencyCode'] as String,
      currencySymbol: json['currencySymbol'] as String,
      isDefault: json['default'] as bool,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
