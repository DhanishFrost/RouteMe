import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './addpaymentmethod.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  late List<Card> cardList = [];

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  void fetchCards() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        // Retrieve the favorites for the current user
        DocumentSnapshot cardsnapshot = await FirebaseFirestore.instance
            .collection('Card')
            .doc(userEmail)
            .get();

        if (cardsnapshot.exists) {
          Map<String, dynamic> cardData =
              cardsnapshot.data() as Map<String, dynamic>;

          // Iterate through each card in the Card and add it to the list
          cardData.forEach((key, value) {
            Map<String, dynamic> cardItemData = value as Map<String, dynamic>;

            cardList.add(Card(
              cardHolderName: cardItemData['cardHolderName'] ?? '',
              cardNumber: cardItemData['cardNumber'] ?? '',
              cvv: cardItemData['cvv'] ?? '',
              expiryDate: cardItemData['expiryDate'] ?? '',
            ));
          });
          print('cardList: $cardList');

          // Update the state to trigger a re-render of the UI
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20, top: 20),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 30, top: 10),
            child: Text(
              'Payment Methods',
              style: GoogleFonts.dmSans(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/images/card.png',
            width: 380,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'Your Payment Methods',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
              color: Color(0xffF6F8FC),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                height: 100.0,
                child: ListView.builder(
                  itemCount: cardList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 40.0,
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            cardList[index].cardNumber,
                            style: GoogleFonts.dmSans(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Edit card functionality
                          },
                          icon: Icon(Icons.edit),
                          color: Color(0xffDE7254),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Container(
            margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPaymentMethod(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(350, 60),
                shape: const StadiumBorder(),
                side: BorderSide(
                  color: const Color(0xFFE7E7EF),
                  width: 2.0,
                ),
              ),
              child: Text(
                'Add Payment Method',
                style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(Colors.black.value)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDE7254),
                minimumSize: const Size(350, 60),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ])));
  }
}

class Card {
  final String cardHolderName;
  final String cardNumber;
  final String cvv;
  final String expiryDate;

  Card({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cvv,
    required this.expiryDate,
  });

  @override
  String toString() {
    return 'Card: {cardHolderName: $cardHolderName, cardNumber: $cardNumber, cvv: $cvv, expiryDate: $expiryDate}';
  }
}
