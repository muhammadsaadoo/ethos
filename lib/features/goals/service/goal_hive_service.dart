import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
// import '../../models/goal_model.dart';

class GoalHiveService {
  final Box<GoalModel> box = Hive.box<GoalModel>(HiveBoxes.goals);

  Future<void> addGoal(GoalModel goal) async {
    await box.put(goal.id, goal);
  }

  List<GoalModel> getGoals(String userId) {
    return box.values.where((e) => e.userId == userId).toList();
  }

  List<GoalModel> getUnsynced() {
    return box.values.where((e) => e.isSynced == false).toList();
  }

  Future<void> update(GoalModel goal) async {
    await box.put(goal.id, goal);
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
