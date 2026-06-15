import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String month; // e.g. "June 2026"

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double targetAmount;

  @HiveField(5)
  final bool isSynced;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.category,
    required this.targetAmount,
    this.isSynced = false,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      month: json['month'] ?? '',
      category: json['category'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0).toDouble(),
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'month': month,
      'category': category,
      'targetAmount': targetAmount,
      'isSynced': isSynced,
    };
  }

  BudgetModel copyWith({
    String? month,
    String? category,
    double? targetAmount,
    bool? isSynced,
  }) {
    return BudgetModel(
      id: id,
      userId: userId,
      month: month ?? this.month,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
