import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBooking extends StatefulWidget {
  const UpdateBooking(
      {Key? key,
      required this.city,
      required this.country,
      required this.hotelImage,
      required this.hotelName,
      required this.roomType,
      required this.noOfGuests,
      required this.noOfRooms,
      required this.checkInDate,
      required this.checkOutDate,
      required this.noOfNights,
      required this.totalPrice})
      : super(key: key);

  final String city;
  final String country;
  final String hotelImage;
  final String hotelName;
  final String roomType;
  final int noOfGuests;
  final int noOfRooms;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String noOfNights;
  final totalPrice;

  @override
  _UpdateBookingState createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking> {
  TextEditingController roomTypeController = TextEditingController();
  TextEditingController noOfguestsController = TextEditingController();
  TextEditingController noOfRoomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for the text fields
    roomTypeController.text = widget.roomType;
    noOfguestsController.text = widget.noOfGuests.toString();
    noOfRoomsController.text = widget.noOfRooms.toString();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    roomTypeController.dispose();
    noOfguestsController.dispose();
    noOfRoomsController.dispose();
    super.dispose();
  }

  void updateBooking() {
  String updatedRoomType = roomTypeController.text;
  int updatedGuests = int.parse(noOfguestsController.text);
  int updatedRooms = int.parse(noOfRoomsController.text);

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userEmail = user.email ?? '';

    // Prepare the updated booking data
    Map<String, dynamic> updatedData = {
      'roomType': updatedRoomType,
      'noOfGuests': updatedGuests,
      'noOfRooms': updatedRooms,
      'city' : widget.city,
      'country' : widget.country,
      'hotelImage' : widget.hotelImage,
      'hotelName' : widget.hotelName,
      'checkInDate' : widget.checkInDate,
      'checkOutDate' : widget.checkOutDate,
      'noOfNights' : widget.noOfNights,
      'totalPrice' : widget.totalPrice,
      
    };

    DocumentReference bookingRef = FirebaseFirestore.instance.collection('Bookings').doc(userEmail);

    // Update the booking data in Firestore
    bookingRef.update({
      widget.hotelName: updatedData,
    }).then((_) {
      _showToast('Booking updated successfully');
      Navigator.pop(context);
    }).catchError((error) {
      _showToast('Failed to update booking');
    });
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
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                child: Image.asset(
                  widget.hotelImage,
                  fit: BoxFit.cover,
                  height: screenHeight * 0.4,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 25,
                left: 20,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: 25,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 5),
            child: Text(
              'Booking details',
              style: GoogleFonts.dmSans(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 10),
            margin: EdgeInsets.only(right: 15, left: 15, bottom: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: roomTypeController,
                    decoration: InputDecoration(
                      hintText: 'Room Type',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.038,
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
                  SizedBox(height: 15),
                  TextFormField(
                    controller: noOfguestsController,
                    decoration: InputDecoration(
                      hintText: 'No. of guests',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.038,
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
                  SizedBox(height: 15),
                  TextFormField(
                    controller: noOfRoomsController,
                    decoration: InputDecoration(
                      hintText: 'No. of rooms',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.038,
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
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check-In',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Color(0xff828F9C),
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d, yyyy')
                                  .format(widget.checkInDate),
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check-Out',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Color(0xff828F9C),
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d, yyyy')
                                  .format(widget.checkOutDate),
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Total (LKR)',
                      style: GoogleFonts.dmSans(
                        fontSize: screenWidth * 0.038,
                        color: Color(0xff828F9C),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 2),
                    child: Row(
                      children: [
                        Text(
                          widget.noOfNights,
                          style: GoogleFonts.dmSans(
                            fontSize: screenWidth * 0.038,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          'Rs ${widget.totalPrice}',
                          style: GoogleFonts.dmSans(
                            fontSize: screenWidth * 0.038,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  updateBooking();
                },
                child: Text(
                  'Update Booking',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffDE7254),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(screenWidth * 0.92, screenHeight * 0.07),
                )),
          ),
        ],
      ),
    ));
  }
}
