// import 'package:get/get.dart';
// import '../../../data/models/card_model.dart';
// import '../../../data/repositories/card_repository.dart';

import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CardController extends GetxController {
  final CardRepository repository;

  CardController(this.repository);

  RxList<CardModel> cards = <CardModel>[].obs;

  final String userId = 'dummy_user_1';

  @override
  void onInit() {
    super.onInit();

    loadCards();
  }

  Future<void> loadCards() async {
    final result = await repository.getCards(userId);

    cards.value = result;
  }

  Future<void> addDummyCard() async {
    final card = CardModel(
      id: const Uuid().v4(),
      userId: userId,
      cardName: 'Personal Card',
      totalAmount: 50000,
      cardNumber: '1234 5678 9012 3456',
      expiryDate: '12/28',
      cvv: '123',
      cardHolderName: 'Muhammad Saad',
    );

    await repository.addCard(card);

    cards.add(card);
  }
}
