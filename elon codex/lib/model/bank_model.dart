class BankModel {
  final int? bankId;
  final String? code;
  final String? name;

  BankModel({
    this.bankId,
    this.code,
    this.name,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      bankId: json['bankId'],
      code: json['code'],
      name: json['name'],
    );
  }
}
