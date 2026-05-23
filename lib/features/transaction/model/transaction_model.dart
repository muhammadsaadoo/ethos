import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String cardId;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String note;

  @HiveField(7)
  final bool isExpense;

  @HiveField(8)
  final bool isSynced;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.isExpense,
    this.isSynced = false,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      cardId: json['cardId'],
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      note: json['note'],
      isExpense: json['isExpense'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardId': cardId,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'isExpense': isExpense,
      'isSynced': isSynced,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? cardId,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    bool? isExpense,
    bool? isSynced,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardId: cardId ?? this.cardId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      isExpense: isExpense ?? this.isExpense,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
