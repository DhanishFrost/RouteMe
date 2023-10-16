import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './booknowcomplete.dart';

class BookNowPayment extends StatefulWidget {
  const BookNowPayment(
      {Key? key,
      required this.city,
      required this.country,
      required this.hotelImage,
      required this.hotelName,
      required this.hotelPrice,
      required this.checkInDate,
      required this.checkOutDate,
      required this.roomType,
      required this.noOfGuests,
      required this.noOfRooms,
      required this.noOfNights,
      required this.totalPrice});

  final String hotelImage;
  final String city;
  final String country;
  final String hotelName;
  final int hotelPrice;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String roomType;
  final int noOfGuests;
  final int noOfRooms;
  final String noOfNights;
  final totalPrice;

  @override
  State<BookNowPayment> createState() => _BookNowPaymentState();
}

class _BookNowPaymentState extends State<BookNowPayment> {

  void saveBookingData() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userEmail = user.email ?? '';

    DocumentReference bookingsCollection =
        FirebaseFirestore.instance.collection('Bookings').doc(userEmail);

    // Check if the document already exists
    bool documentExists = await bookingsCollection.get().then((snapshot) => snapshot.exists);

    if (documentExists) {
      // Update existing document with hotel details
      await bookingsCollection.update({
        widget.hotelName: {
          'city': widget.city,
          'country': widget.country,
          'hotelName': widget.hotelName,
          'hotelImage': widget.hotelImage,
          'roomType': widget.roomType,
          'noOfGuests': widget.noOfGuests,
          'noOfRooms': widget.noOfRooms,
          'checkInDate': widget.checkInDate,
          'checkOutDate': widget.checkOutDate,
          'noOfNights': widget.noOfNights,
          'totalPrice': widget.totalPrice,
        }
      }).then((value) {
        // Data saved successfully
        print('Booking data saved!');
        _showToast('Booking Successful! Thank you for your booking');
      }).catchError((error) {
        // Error occurred while saving data
        print('Failed to save booking data: $error');
        _showToast('Failed to Book! Please try again');
      });
    } else {
      // Create a new document with hotel details
      await bookingsCollection.set({
        '${widget.hotelName}': {
          'city': widget.city,
          'country': widget.country,
          'hotelName': widget.hotelName,
          'hotelImage': widget.hotelImage,
          'roomType': widget.roomType,
          'noOfGuests': widget.noOfGuests,
          'noOfRooms': widget.noOfRooms,
          'checkInDate': widget.checkInDate,
          'checkOutDate': widget.checkOutDate,
          'noOfNights': widget.noOfNights,
          'totalPrice': widget.totalPrice,
        }
      }).then((value) {
        // Data saved successfully
        print('Booking data saved!');
        _showToast('Booking Successful! Thank you for your booking');
      }).catchError((error) {
        // Error occurred while saving data
        print('Failed to save booking data: $error');
        _showToast('Failed to Book! Please try again');
      });
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
              'Booking Details',
              style: GoogleFonts.dmSans(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.015,
                  left: screenWidth * 0.08,
                  child: CircleAvatar(
                    radius: screenWidth * 0.03,
                    backgroundColor: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.022,
                  left: screenWidth * 0.094,
                  child: CircleAvatar(
                    radius: screenWidth * 0.016,
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.056,
                  left: screenWidth * 0.065,
                  child: Text(
                    'Booking',
                    style: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.024,
                  right: screenWidth * 0.530,
                  child: Container(
                    height: 2,
                    color: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.034,
                  right: screenWidth * 0.530,
                  child: Container(
                    height: 2,
                    color: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.015,
                  left: screenWidth * 0.44,
                  child: CircleAvatar(
                    radius: screenWidth * 0.03,
                    backgroundColor: Color(0xffDE7254),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.022,
                  left: screenWidth * 0.455,
                  child: CircleAvatar(
                    radius: screenWidth * 0.016,
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.056,
                  left: screenWidth * 0.39,
                  child: Text(
                    'Payment',
                    style: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffDE7254)),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.490,
                  top: screenHeight * 0.024,
                  right: screenWidth * 0.19,
                  child: Container(
                    height: 2,
                    color: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.490,
                  top: screenHeight * 0.034,
                  right: screenWidth * 0.19,
                  child: Container(
                    height: 2,
                    color: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.056,
                  left: screenWidth * 0.75,
                  child: Text(
                    'Complete',
                    style: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.015,
                  left: screenWidth * 0.8,
                  child: CircleAvatar(
                    radius: screenWidth * 0.03,
                    backgroundColor: Color.fromARGB(137, 158, 158, 158),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.022,
                  left: screenWidth * 0.814,
                  child: CircleAvatar(
                    radius: screenWidth * 0.016,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(134, 179, 178, 178),
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
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: TextFormField(
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
                      contentPadding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 15, 25, 0),
                  child: TextFormField(
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
                      contentPadding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 15, 15, 0),
                        child: TextFormField(
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 25, 0),
                        child: TextFormField(
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
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      saveBookingData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookNowComplete(
                                hotelImage: widget.hotelImage,
                                hotelName: widget.hotelName,
                                hotelPrice: widget.hotelPrice,
                                roomType: widget.roomType,
                                noOfGuests: widget.noOfGuests,
                                noOfRooms: widget.noOfRooms,
                                checkInDate: widget.checkInDate,
                                checkOutDate: widget.checkOutDate,
                                noOfNights: widget.noOfNights,
                                totalPrice: widget.totalPrice, 
                              )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE7254),
                      minimumSize: const Size(360, 60),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Pay Now',
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
        ])));
  }
}
