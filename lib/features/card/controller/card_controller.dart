// import 'package:get/get.dart';
// import '../../../data/models/card_model.dart';
// import '../../../data/repositories/card_repository.dart';

import 'dart:async';

import 'package:expence_management/features/auth/services/user_session_service.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';

class CardController extends GetxController {
  final CardRepository repository;

  CardController(this.repository);

  final RxList<CardModel> cards = <CardModel>[].obs;
  // final String userId = 'dummy_user_1';
  final userId = Get.find<UserSessionService>().userId;

  StreamSubscription? _cardSub;

  @override
  void onInit() {
    super.onInit();
    bindCards();
    for (var card in cards) {
      print(
        'Card ID: ${card.id}, Name: ${card.cardName}',
      ); // Customize with your CardModel fields
    }
  }

  void bindCards() {
    _cardSub?.cancel();

    _cardSub = repository.watchCards(userId).listen((data) {
      final unique = {for (var c in data) c.id: c}.values.toList();

      cards.assignAll(unique);
    });
  }

  // Future<void> addDummyCard() async {
  //   final card = CardModel(
  //     id: const Uuid().v4(),
  //     userId: userId,
  //     cardName: 'Personal Card',
  //     totalAmount: 50000,
  //     cardNumber: '1234 5678 9012 3456',
  //     expiryDate: '12/28',
  //     cvv: '123',
  //     cardHolderName: 'Muhammad Saad',
  //   );

  //   await repository.addCard(card);
  // }

  @override
  void onClose() {
    _cardSub?.cancel();
    super.onClose();
  }
}
