import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/goals/repository/goal_repository.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class DummyDataService {
  final uuid = const Uuid();

  final String userId = "dummy_user_1";

  // ================= REPOSITORIES =================

  final CardRepository cardRepository = Get.find();

  final TransactionRepository transactionRepository = Get.find();

  final GoalRepository goalRepository = Get.find();

  // ======================================================
  // ===================== CREATE CARD ====================
  // ======================================================

  Future<CardModel> createDummyCard() async {
    final card = CardModel(
      id: uuid.v4(),
      userId: userId,
      cardName: "Test Card",
      totalAmount: 50000,
      cardNumber: "1234 5678 9012 3456",
      expiryDate: "12/28",
      cvv: "123",
      cardHolderName: "Test User",
      isSynced: false,
    );

    await cardRepository.addCard(card);

    return card;
  }

  // ======================================================
  // ================= CREATE TRANSACTION =================
  // ======================================================

  Future<TransactionModel> createDummyTransaction(String cardId) async {
    final tx = TransactionModel(
      id: uuid.v4(),
      userId: userId,
      cardId: cardId,
      amount: 1200,
      category: "Food",
      date: DateTime.now(),
      note: "Pizza & Burger",
      isExpense: true,
      isSynced: false,
    );

    await transactionRepository.addTransaction(tx);

    return tx;
  }

  // ======================================================
  // ===================== CREATE GOAL ====================
  // ======================================================

  Future<GoalModel> createDummyGoal() async {
    final goal = GoalModel(
      id: uuid.v4(),
      userId: userId,
      goalName: "Buy Laptop",
      category: "Electronics",
      targetAmount: 150000,
      savedAmount: 25000,
      deadline: DateTime.now().add(const Duration(days: 120)),
      isSynced: false,
    );

    await goalRepository.addGoal(goal);

    return goal;
  }

  // ======================================================
  // ====================== FETCH =========================
  // ======================================================

  Future<void> fetchEverything() async {
    final cards = await cardRepository.getCards(userId);

    final transactions = await transactionRepository.getTransactions(userId);

    final goals = await goalRepository.getGoals(userId);

    print("📦 CARDS");

    for (final c in cards) {
      print(c.toJson());
    }

    print("📦 TRANSACTIONS");

    for (final t in transactions) {
      print(t.toJson());
    }

    print("📦 GOALS");

    for (final g in goals) {
      print(g.toJson());
    }
  }

  Future<void> clearAllData() async {
    print("🧹 Clearing Hive data...");

    await Get.find<CardRepository>().hiveService.clearAll();

    await Get.find<TransactionRepository>().hiveService.clearAll();

    await Get.find<GoalRepository>().hiveService.clearAll();

    print("🧹 Clearing Firestore data...");

    final firestore = Get.find<CardRepository>().firestoreService.firestore;

    final userRef = firestore.collection("users").doc(userId);

    // delete cards
    final cards = await userRef.collection("cards").get();

    for (final doc in cards.docs) {
      await doc.reference.delete();
    }

    // delete transactions
    final txs = await userRef.collection("transactions").get();

    for (final doc in txs.docs) {
      await doc.reference.delete();
    }

    // delete goals
    final goals = await userRef.collection("goals").get();

    for (final doc in goals.docs) {
      await doc.reference.delete();
    }

    print("🔥 Firestore cleared");
  }

  Future<void> runCleanTestFlow() async {
    print("========== CLEAN TEST FLOW START ==========");

    // 1️⃣ CLEAR OLD DATA
    await clearAllData();

    print("🗑 OLD DATA CLEARED");

    // 2️⃣ CREATE FRESH DATA
    final card = await createDummyCard();
    print("✅ CARD CREATED");

    await createDummyTransaction(card.id);
    print("✅ TRANSACTION CREATED");

    await createDummyGoal();
    print("✅ GOAL CREATED");

    // 3️⃣ FETCH & VERIFY
    print("========== FETCH DATA ==========");

    await fetchEverything();

    print("========== CLEAN TEST FLOW END ==========");
  }

  // ======================================================
  // ====================== FULL TEST =====================
  // ======================================================

  // Future<void> runCompleteTest() async {
  //   print("========== TEST START ==========");

  //   final card = await createDummyCard();

  //   print("✅ CARD CREATED");

  //   await createDummyTransaction(card.id);

  //   print("✅ TRANSACTION CREATED");

  //   await createDummyGoal();

  //   print("✅ GOAL CREATED");

  //   print("========== FETCHING ==========");

  //   await fetchEverything();

  //   print("========== TEST END ==========");
  // }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expence_management/features/card/model/card_model.dart';
// import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';
// import 'package:expence_management/features/goals/model/goal_model.dart';
// import 'package:expence_management/features/goals/service/goal_hive_service.dart';
// import 'package:expence_management/features/transaction/model/transaction_model.dart';
// import 'package:expence_management/features/transaction/service/transaction_hive_service.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';

// class DummyDataService {
//   final uuid = const Uuid();

//   final String userId = "dummy_user_1";

//   // ===================== HIVE SERVICES =====================

//   final CardHiveService cardHiveService = Get.find();

//   final TransactionHiveService transactionHiveService = Get.find();

//   final GoalHiveService goalHiveService = Get.find();

//   // ===================== FIRESTORE =====================

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // ======================================================
//   // ===================== CREATE CARD ====================
//   // ======================================================

//   Future<CardModel> createDummyCard() async {
//     final card = CardModel(
//       id: uuid.v4(),
//       userId: userId,
//       cardName: "Test Card",
//       totalAmount: 50000,
//       cardNumber: "1234 5678 9012 3456",
//       expiryDate: "12/28",
//       cvv: "123",
//       cardHolderName: "Test User",
//       isSynced: false,
//     );

//     // SAVE TO HIVE
//     await cardHiveService.addCard(card);

//     // SAVE TO FIRESTORE
//     await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("cards")
//         .doc(card.id)
//         .set(card.toJson());

//     return card;
//   }

//   // ======================================================
//   // ================= CREATE TRANSACTION =================
//   // ======================================================

//   Future<TransactionModel> createDummyTransaction(String cardId) async {
//     final tx = TransactionModel(
//       id: uuid.v4(),
//       userId: userId,
//       cardId: cardId,
//       amount: 1200,
//       category: "Food",
//       date: DateTime.now(),
//       note: "Pizza & Burger",
//       isExpense: true,
//       isSynced: false,
//     );

//     // SAVE TO HIVE
//     await transactionHiveService.addTransaction(tx);

//     // SAVE TO FIRESTORE
//     await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("transactions")
//         .doc(tx.id)
//         .set(tx.toJson());

//     return tx;
//   }

//   // ======================================================
//   // ===================== CREATE GOAL ====================
//   // ======================================================

//   Future<GoalModel> createDummyGoal() async {
//     final goal = GoalModel(
//       id: uuid.v4(),
//       userId: userId,
//       goalName: "Buy Laptop",
//       category: "Electronics",
//       targetAmount: 150000,
//       savedAmount: 25000,
//       deadline: DateTime.now().add(const Duration(days: 120)),
//       isSynced: false,
//     );

//     // SAVE TO HIVE
//     await goalHiveService.addGoal(goal);

//     // SAVE TO FIRESTORE
//     await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("goals")
//         .doc(goal.id)
//         .set(goal.toJson());

//     return goal;
//   }

//   // ======================================================
//   // =============== FETCH CARDS FIRESTORE ================
//   // ======================================================

//   Future<void> fetchCardsFromFirestore() async {
//     final snapshot = await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("cards")
//         .get();

//     print("🔥 FIRESTORE CARDS:");

//     for (final doc in snapshot.docs) {
//       print(doc.data());
//     }
//   }

//   // ======================================================
//   // ============ FETCH TRANSACTIONS FIRESTORE ============
//   // ======================================================

//   Future<void> fetchTransactionsFromFirestore() async {
//     final snapshot = await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("transactions")
//         .get();

//     print("🔥 FIRESTORE TRANSACTIONS:");

//     for (final doc in snapshot.docs) {
//       print(doc.data());
//     }
//   }

//   // ======================================================
//   // ================= FETCH GOALS FIRESTORE ==============
//   // ======================================================

//   Future<void> fetchGoalsFromFirestore() async {
//     final snapshot = await firestore
//         .collection("users")
//         .doc(userId)
//         .collection("goals")
//         .get();

//     print("🔥 FIRESTORE GOALS:");

//     for (final doc in snapshot.docs) {
//       print(doc.data());
//     }
//   }

//   // ======================================================
//   // ================== FETCH CARDS HIVE ==================
//   // ======================================================

//   Future<void> fetchCardsFromHive() async {
//     final cards = cardHiveService.getCards(userId);

//     print("📦 HIVE CARDS:");

//     for (final card in cards) {
//       print(card.toJson());
//     }
//   }

//   // ======================================================
//   // ============== FETCH TRANSACTIONS HIVE ===============
//   // ======================================================

//   Future<void> fetchTransactionsFromHive() async {
//     final transactions = transactionHiveService.getTransactions(userId);

//     print("📦 HIVE TRANSACTIONS:");

//     for (final tx in transactions) {
//       print(tx.toJson());
//     }
//   }

//   // ======================================================
//   // ================== FETCH GOALS HIVE ==================
//   // ======================================================

//   Future<void> fetchGoalsFromHive() async {
//     final goals = goalHiveService.getGoals(userId);

//     print("📦 HIVE GOALS:");

//     for (final goal in goals) {
//       print(goal.toJson());
//     }
//   }

//   // ======================================================
//   // =================== FULL HIVE TEST ===================
//   // ======================================================

//   Future<void> runFullHiveTest() async {
//     print("========== HIVE DUMMY TEST START ==========");

//     final card = await createDummyCard();

//     print("✅ CARD CREATED");

//     await createDummyTransaction(card.id);

//     print("✅ TRANSACTION CREATED");

//     await createDummyGoal();

//     print("✅ GOAL CREATED");

//     print("========== FETCH FROM HIVE ==========");

//     await fetchCardsFromHive();

//     await fetchTransactionsFromHive();

//     await fetchGoalsFromHive();

//     print("========== HIVE TEST END ==========");
//   }

//   // ======================================================
//   // ================ FULL FIRESTORE TEST =================
//   // ======================================================

//   Future<void> runFullFirestoreTest() async {
//     print("========== FIRESTORE TEST START ==========");

//     final card = await createDummyCard();

//     print("✅ CARD CREATED");

//     await createDummyTransaction(card.id);

//     print("✅ TRANSACTION CREATED");

//     await createDummyGoal();

//     print("✅ GOAL CREATED");

//     print("========== FETCH FROM FIRESTORE ==========");

//     await fetchCardsFromFirestore();

//     await fetchTransactionsFromFirestore();

//     await fetchGoalsFromFirestore();

//     print("========== FIRESTORE TEST END ==========");
//   }

//   // ======================================================
//   // ================= COMPLETE TEST FLOW =================
//   // ======================================================

//   Future<void> runCompleteTest() async {
//     print("========== COMPLETE TEST START ==========");

//     final card = await createDummyCard();

//     print("✅ CARD CREATED");

//     await createDummyTransaction(card.id);

//     print("✅ TRANSACTION CREATED");

//     await createDummyGoal();

//     print("✅ GOAL CREATED");

//     // ================= HIVE =================

//     print("========== FETCH FROM HIVE ==========");

//     await fetchCardsFromHive();

//     await fetchTransactionsFromHive();

//     await fetchGoalsFromHive();

//     // ================= FIRESTORE =================

//     print("========== FETCH FROM FIRESTORE ==========");

//     await fetchCardsFromFirestore();

//     await fetchTransactionsFromFirestore();

//     await fetchGoalsFromFirestore();

//     print("========== COMPLETE TEST END ==========");
//   }
// }
