import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 2)
class GoalModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String goalName;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double targetAmount;

  @HiveField(5)
  final double savedAmount;

  @HiveField(6)
  final DateTime deadline;

  @HiveField(7)
  final bool isSynced;

  GoalModel({
    required this.id,
    required this.userId,
    required this.goalName,
    required this.category,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.isSynced = false,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['userId'],
      goalName: json['goalName'],
      category: json['category'],
      targetAmount: (json['targetAmount'] ?? 0).toDouble(),
      savedAmount: (json['savedAmount'] ?? 0).toDouble(),
      deadline: DateTime.parse(json['deadline']),
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goalName': goalName,
      'category': category,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  GoalModel copyWith({
    String? goalName,
    String? category,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    bool? isSynced,
  }) {
    return GoalModel(
      id: id,
      userId: userId,
      goalName: goalName ?? this.goalName,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
