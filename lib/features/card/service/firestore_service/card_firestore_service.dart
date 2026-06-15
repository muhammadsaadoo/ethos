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

  Future<void> updateCard(CardModel card) async {
    await firestore
        .collection('users')
        .doc(card.userId)
        .collection('cards')
        .doc(card.id)
        .update(card.toJson());
  }

  Future<void> deleteCard({
    required String userId,
    required String cardId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .delete();

    // delete all transactions under this card
    final txSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('cardId', isEqualTo: cardId)
        .get();

    for (final doc in txSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearAll(String userId) async {
    final cards = await firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .get();

    for (final doc in cards.docs) {
      await doc.reference.delete();
    }
  }
}
