import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/goals/repository/goal_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// import '../../../data/models/goal_model.dart';
// import '../../../data/repositories/goal_repository.dart';

class GoalController extends GetxController {
  final GoalRepository repository;

  GoalController(this.repository);

  RxList<GoalModel> goals = <GoalModel>[].obs;

  final String userId = 'dummy_user_1';

  Future<void> loadGoals() async {
    final data = await repository.getGoals(userId);

    goals.value = data;
  }

  Future<void> addDummyGoal() async {
    final goal = GoalModel(
      id: const Uuid().v4(),
      userId: userId,
      goalName: 'Buy iPhone',
      category: 'Electronics',
      targetAmount: 200000,
      savedAmount: 50000,
      deadline: DateTime.now().add(const Duration(days: 90)),
    );

    await repository.addGoal(goal);

    goals.add(goal);
  }
}
