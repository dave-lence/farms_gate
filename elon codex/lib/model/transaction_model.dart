// class TransactionModel {
//   final String? type;
//   final String? title;
//   final DateTime? date;
//   final double? amount;
//   final String? status;
//   final String? description;

//   TransactionModel({
//     required this.type,
//     required this.title,
//     required this.date,
//     required this.amount,
//     required this.description,
//     required this.status,
//   });

//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       type: json['type'],
//       title: json['category'],
//       date: DateTime.parse(json['transactionDate']),
//       amount: json['amount'].toDouble(),
//       description: json['description'],
//       status: json['status'],
//     );
//   }
// }
class TransactionModel {
  final String? type;
  final String? title;
  final DateTime? date;
  final double amount;
  final String? status;
  final String? description;

  TransactionModel({
    this.type,
    this.title,
    this.date,
    required this.amount,
    this.description,
    this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['receiptDetails']?['type'] ?? 'Unknown',
      title: json['category'] ?? 'Unknown',
      date: json['receiptDetails']?['transactionDate'] != null
          ? DateTime.tryParse(json['receiptDetails']['transactionDate'])
          : null,
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? 'No description available',
      status: json['status'] ?? 'Unknown',
    );
  }
}
