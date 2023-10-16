import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './booknow.dart';

class HotelDetails extends StatefulWidget {
  const HotelDetails({
    Key? key,
    required this.imageName,
    required this.hotelName,
    required this.description,
    required this.city,
    required this.country,
    required this.rating,
    required this.price,
  }) : super(key: key);

  final String imageName;
  final String hotelName;
  final String description;
  final String city;
  final String country;
  final double rating;
  final int price;

  @override
  _HotelDetailsState createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  void addToFavorites() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        // Create a document inside 'Favorites' with user email as the document ID
        DocumentReference hotelRef =
            FirebaseFirestore.instance.collection('Favorites').doc(userEmail);

        // Set the data for the hotel document
        await hotelRef.set({
          widget.hotelName: {
            'imageName': widget.imageName,
            'hotelName': widget.hotelName,
            'description': widget.description,
            'city': widget.city,
            'country': widget.country,
            'rating': widget.rating,
            'price': widget.price,
          },
        }, SetOptions(merge: true));
        _showToast('Added to favorites');
      }
    } catch (e) {
      print('Error booking: $e');
      _showToast('Error adding to favorites');
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
    body: OrientationBuilder(
      builder: (context, orientation) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        widget.imageName,
                        fit: BoxFit.cover,
                        height: orientation == Orientation.portrait
                            ? screenHeight * 0.52
                            : screenHeight * 0.8, // Adjust the height for landscape orientation
                        width: screenWidth,
                      ),
                    ),
                    Positioned(
                      top: orientation == Orientation.portrait
                          ? screenHeight * 0.43
                          : screenHeight * 0.6, // Adjust the position for landscape orientation
                      right: screenWidth * 0.05,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                            color: Color(0xffDE7254),
                          ),
                          onPressed: () {
                            addToFavorites();
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 16,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 25,
                      right: 16,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.call),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Color(0xFFDE7254),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.city + ', ' + widget.country,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        color: const Color(0xFFDE7254),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.hotelName,
                  style: GoogleFonts.dmSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 5, right: 15),
                child: Text(
                  widget.description,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Color(0xff828F9C),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Container(
                      width: screenWidth * 0.22,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Icon(
                              Icons.credit_card,
                              color: Color(0xff8DBCE8),
                              size: 40,
                            ),
                            Text(
                              'Affordable',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.22,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_parking_rounded,
                              color: Color(0xffFFC187),
                              size: 40,
                            ),
                            Text(
                              'Parking',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.22,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Icon(
                              Icons.restaurant_rounded,
                              color: Color(0xff81D4A3),
                              size: 40,
                            ),
                            Text(
                              'Full Board',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.22,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Icon(
                              Icons.health_and_safety_rounded,
                              color: Color(0xffA8BAC5),
                              size: 40,
                            ),
                            Text(
                              'Insurance',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'LKR',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                color: Color(0xffFD881C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.price.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 30,
                                color: Color(0xffFD881C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          'per night',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Color(0xffA8BAC5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookNow(
                              hotelName: widget.hotelName,
                              imageName: widget.imageName,
                              hotelPrice: widget.price,
                              city: widget.city,
                              country: widget.country,
                            ),
                          ),
                        );
                      },
                      child: Text('Book Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDE7254),
                        textStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize:
                            Size(screenWidth * 0.45, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
}