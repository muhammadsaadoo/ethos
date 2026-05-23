import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String cardName;

  @HiveField(3)
  final double totalAmount;

  @HiveField(4)
  final String cardNumber;

  @HiveField(5)
  final String expiryDate;

  @HiveField(6)
  final String cvv;

  @HiveField(7)
  final String cardHolderName;

  @HiveField(8)
  final bool isSynced;

  CardModel({
    required this.id,
    required this.userId,
    required this.cardName,
    required this.totalAmount,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
    this.isSynced = false,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      userId: json['userId'],
      cardName: json['cardName'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
      cardHolderName: json['cardHolderName'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardName': cardName,
      'totalAmount': totalAmount,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardHolderName': cardHolderName,
      'isSynced': isSynced,
    };
  }

  CardModel copyWith({bool? isSynced, double? totalAmount}) {
    return CardModel(
      id: id,
      userId: userId,
      cardName: cardName,
      totalAmount: totalAmount ?? this.totalAmount,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardHolderName: cardHolderName,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
