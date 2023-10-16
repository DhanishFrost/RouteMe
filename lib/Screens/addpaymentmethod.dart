import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  void saveCardDetails() async {
    if (_formKey.currentState!.validate()) {
      // Get the card details entered by the user
      String cardNumber = _cardNumberController.text;
      String cardHolderName = _cardHolderNameController.text;
      String expiryDate = _expiryDateController.text;
      String cvv = _cvvController.text;

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userEmail = user.email ?? '';

          // Create a document inside 'Card' with user email as the document ID
          DocumentReference cardRef =
              FirebaseFirestore.instance.collection('Card').doc(userEmail);

          await cardRef.update({
            cardNumber: {
              'cardNumber': cardNumber,
              'cardHolderName': cardHolderName,
              'expiryDate': expiryDate,
              'cvv': cvv,
            },
          });

          _showToast('Card details added successfully.');
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error adding card details: $e');
      }
    }
  }



  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  'Add payment Method',
                  style: GoogleFonts.dmSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 360,
                child: Image.asset(
                  'assets/images/card.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Card details',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: TextFormField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF828F9C),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 20, 0, 20),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                        onChanged: (value) {
                          value = value.replaceAll(
                              ' ', ' '); // Remove all spaces from the input
                          if (value.length >= 2 && value.length % 5 == 0) {
                            final lastChar = value.substring(value.length - 1);
                            if (lastChar != ' ') {
                              value = value.substring(0, value.length - 1) +
                                  ' ' +
                                  lastChar;
                            }
                          }
                          _cardNumberController.value =
                              _cardNumberController.value.copyWith(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a card number.';
                          }
                          value = value.replaceAll(
                              ' ', ''); // Remove all spaces from the input
                          if (value.length != 16) {
                            return 'Card number must have 16 digits.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: TextFormField(
                        controller: _cardHolderNameController,
                        decoration: InputDecoration(
                          labelText: 'Card Holder Name',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF828F9C),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 20, 0, 20),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the card holder name.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: TextFormField(
                                  controller: _expiryDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Expiration Date',
                                    hintStyle: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF828F9C),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 20, 0, 20),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  maxLength: 5,
                                  onChanged: (value) {
                                    value = value.replaceAll('/',
                                        ''); // Remove all slashes from the input
                                    if (value.length >= 2) {
                                      final firstTwoChars =
                                          value.substring(0, 2);
                                      final lastChars = value.substring(2);
                                      value = '$firstTwoChars/$lastChars';
                                    }
                                    if (value.length > 5) {
                                      value = value.substring(0, 5);
                                    } else if (value.length == 3 &&
                                        value[2] == '/') {
                                      value = value.substring(0, 2);
                                    }
                                    _expiryDateController.value =
                                        _expiryDateController.value.copyWith(
                                      text: value,
                                      selection: TextSelection.collapsed(
                                          offset: value.length),
                                    );
                                  },
                                ))),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: TextFormField(
                              controller: _cvvController,
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF828F9C),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(48),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 0, 20),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the CVV.';
                                }
                                if (value.length != 3) {
                                  return 'CVV must have 3 digits.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
                      child: ElevatedButton(
                        onPressed: saveCardDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE7254),
                          minimumSize: const Size(350, 60),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
