import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
/*
 im creating the Expence management App
 app has following scanario
 multiple Users
 each user has multiple cards
 each card has multiple Transactions
 each transaction has transaction amount, transaction category(where money spanding like food)
 and transaction date
 each user can set goals (save money ) like goal to save money for iphone or car 
 each goal has amount to be saved , deadline(expiry date) , category like phone and goal name 
 this date will store in Hive and firestore both
 first store in hive then in firestore
 if internet connected than use firestore otherwise use Hive
 as internet available the new category in hive will be pass to the firestore
 use Getx for proper statemanagement

 models
       card-> store card info and total amount
       Transaction --> transactions details
       Goals--> goals details
controller
       Card COntroller
       Transaction Controller
       Goals Controller
Services
      Card Service
      Transaction Service
      Goals service

Both Hive and firestore use same model and controller 
but different service


card 
  card number
  expiry date 
  CVV
  cardHolder Name



 
*/

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"), centerTitle: true),
    );
  }
}
