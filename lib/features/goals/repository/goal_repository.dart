// import '../../core/network/network_service.dart';
// import '../models/goal_model.dart';
// import '../services/firestore/goal_firestore_service.dart';
// import '../services/hive/goal_hive_service.dart';

import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/goals/service/goal_firestore_service.dart';
import 'package:expence_management/features/goals/service/goal_hive_service.dart';

class GoalRepository {
  final GoalHiveService hiveService;
  final GoalFirestoreService firestoreService;

  GoalRepository({required this.hiveService, required this.firestoreService});

  Future<void> addGoal(GoalModel goal) async {
    await hiveService.addGoal(goal);

    if (await NetworkService.isConnected()) {
      final synced = GoalModel(
        id: goal.id,
        userId: goal.userId,
        goalName: goal.goalName,
        category: goal.category,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount,
        deadline: goal.deadline,
        isSynced: true,
      );

      await firestoreService.addGoal(synced);

      await hiveService.update(synced);
    }
  }

  Future<List<GoalModel>> getGoals(String userId) async {
    if (await NetworkService.isConnected()) {
      final data = await firestoreService.getGoals(userId);

      for (final g in data) {
        await hiveService.update(g);
      }

      return data;
    }

    return hiveService.getGoals(userId);
  }

  Future<void> syncPending() async {
    if (!await NetworkService.isConnected()) return;

    final unsynced = hiveService.getUnsynced();

    for (final g in unsynced) {
      final synced = GoalModel(
        id: g.id,
        userId: g.userId,
        goalName: g.goalName,
        category: g.category,
        targetAmount: g.targetAmount,
        savedAmount: g.savedAmount,
        deadline: g.deadline,
        isSynced: true,
      );

      await firestoreService.addGoal(synced);

      await hiveService.update(synced);
    }
  }
}
