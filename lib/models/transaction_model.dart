class TransactionModel {
  final String id;
  final double amount;
  final String categoryId;
  final String categoryLabel;
  final bool isExpense;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.categoryLabel,
    required this.isExpense,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'categoryLabel': categoryLabel,
      'isExpense': isExpense,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'],
      categoryLabel: json['categoryLabel'],
      isExpense: json['isExpense'],
      date: DateTime.parse(json['date']),
    );
  }
}
