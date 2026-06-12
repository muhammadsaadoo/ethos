import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
// import '../../models/goal_model.dart';

class GoalFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addGoal(GoalModel goal) async {
    await firestore
        .collection('users')
        .doc(goal.userId)
        .collection('goals')
        .doc(goal.id)
        .set(goal.toJson());
  }

  Future<List<GoalModel>> getGoals(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .get();

    return snapshot.docs.map((e) => GoalModel.fromJson(e.data())).toList();
  }

  // ✅ UPDATE
  Future<void> updateGoal(GoalModel goal) async {
    await firestore
        .collection('users')
        .doc(goal.userId)
        .collection('goals')
        .doc(goal.id)
        .update(goal.toJson());
  }

  // ❌ DELETE
  Future<void> deleteGoal({
    required String userId,
    required String goalId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .delete();
  }
}

// class GoalFirestoreService {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<void> addGoal(GoalModel goal) async {
//     await firestore
//         .collection('users')
//         .doc(goal.userId)
//         .collection('goals')
//         .doc(goal.id)
//         .set(goal.toJson());
//   }

//   Future<List<GoalModel>> getGoals(String userId) async {
//     final snapshot = await firestore
//         .collection('users')
//         .doc(userId)
//         .collection('goals')
//         .get();

//     return snapshot.docs.map((e) => GoalModel.fromJson(e.data())).toList();
//   }
// }
