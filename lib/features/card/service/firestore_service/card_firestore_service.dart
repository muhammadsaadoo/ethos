import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_management/features/card/model/card_model.dart';

// import '../../models/card_model.dart';

class CardFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCard(CardModel card) async {
    await firestore
        .collection('users')
        .doc(card.userId)
        .collection('cards')
        .doc(card.id)
        .set(card.toJson());
  }

  Future<List<CardModel>> getCards(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .get();

    return snapshot.docs.map((e) => CardModel.fromJson(e.data())).toList();
  }
}
