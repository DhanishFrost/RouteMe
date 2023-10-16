import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import './homepage.dart';
import './favorites.dart';
import './myprofile.dart';
import './bookingdetailscompleted.dart';
import './bookingdetailsinprogress.dart';

class MyBooking extends StatefulWidget {
  final File? imageFile;
  const MyBooking({Key? key, this.imageFile}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  int _selectedButtonIndex = 0;
  int _currentIndex = 2;

  late List<Booking> bookingList = [];

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }
  

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens based on the selected tab index
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(imageFile: widget.imageFile)));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Favorites(imageFile: widget.imageFile)));
        break;
      case 2:
        // Already in the MYbooking screen
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyProfile(imageFile: widget.imageFile)));
        break;
    }
  }

  void fetchBookings() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        // Retrieve the favorites for the current user
        DocumentSnapshot bookingsSnapshot = await FirebaseFirestore.instance
            .collection('Bookings')
            .doc(userEmail)
            .get();

        if (bookingsSnapshot.exists) {
          Map<String, dynamic> bookingsData =
              bookingsSnapshot.data() as Map<String, dynamic>;

          // Iterate through each hotel in the favorites and add it to the list
          bookingsData.forEach((key, value) {
            Map<String, dynamic> bookingData = value as Map<String, dynamic>;

            bookingList.add(
              Booking(
                city: bookingData['city'] ?? '',
                country: bookingData['country'] ?? '',
                hotelImage: bookingData['hotelImage'] ?? '',
                hotelName: bookingData['hotelName'] ?? '',
                checkInDate:
                    (bookingData['checkInDate'] as Timestamp).toDate() ??
                        DateTime.now(),
                checkOutDate:
                    (bookingData['checkOutDate'] as Timestamp).toDate() ??
                        DateTime.now(),
                roomType: bookingData['roomType'] ?? 0,
                noOfGuests: bookingData['noOfGuests'] ?? 0,
                noOfRooms: bookingData['noOfRooms'] ?? 0,
                noOfNights: bookingData['noOfNights'] ?? 0,
                totalPrice: bookingData['totalPrice'] ?? '',
              ),
            );
          });
          // Update the state to trigger a re-render of the UI
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  void refreshBookings() {
    setState(() {
      fetchBookings();
    });
  }

  

  @override
  Widget build(BuildContext context) {
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
          Text(
            'My Bookings',
            style: GoogleFonts.dmSans(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 244, 244, 244),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: TextButton(
                    onPressed: () {
                      _onButtonPressed(0);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              _selectedButtonIndex == 0) {
                            return Colors.white;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        'Overall',
                        style: GoogleFonts.dmSans(
                          color: _selectedButtonIndex == 0
                              ? Color(0xFFDE7254)
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: TextButton(
                    onPressed: () {
                      _onButtonPressed(1);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              _selectedButtonIndex == 1) {
                            return Colors.white;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        'In Progress',
                        style: GoogleFonts.dmSans(
                          color: _selectedButtonIndex == 1
                              ? Color(0xFFDE7254)
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: TextButton(
                    onPressed: () {
                      _onButtonPressed(2);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              _selectedButtonIndex == 2) {
                            return Colors.white;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        'Completed',
                        style: GoogleFonts.dmSans(
                          color: _selectedButtonIndex == 2
                              ? Color(0xFFDE7254)
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                return BookingCard(
                  booking: bookingList[index],
                  refreshCallback: refreshBookings,
                );
              },
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFFAF9F9),
        selectedItemColor: const Color(0xFFDE7254),
        unselectedItemColor: const Color.fromARGB(255, 142, 142, 142),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ''),
        ],
      ),
    );
  }
}

class Booking {
  final String hotelImage;
  final String city;
  final String country;
  final String hotelName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String roomType;
  final int noOfGuests;
  final int noOfRooms;
  final String noOfNights;
  final String totalPrice;

  Booking(
      {required this.hotelImage,
      required this.city,
      required this.country,
      required this.hotelName,
      required this.checkInDate,
      required this.checkOutDate,
      required this.roomType,
      required this.noOfGuests,
      required this.noOfRooms,
      required this.noOfNights,
      required this.totalPrice});
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback refreshCallback;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.refreshCallback,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    String getStatus() {
      if (currentDate.isBefore(booking.checkOutDate)) {
        return 'In Progress';
      } else {
        return 'Completed';
      }
    }

    String status = getStatus();

    Color getStatusColor() {
      if (status == 'In Progress') {
        return Color(0xFFA59826); // Custom color for "In Progress" status
      } else {
        return Colors.green; // Green color for "Completed" status
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          if (status == 'In Progress') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDetailsInProgress(
                        city: booking.city,
                        country: booking.country,
                        hotelImage: booking.hotelImage,
                        hotelName: booking.hotelName,
                        checkInDate: booking.checkInDate,
                        checkOutDate: booking.checkOutDate,
                        roomType: booking.roomType,
                        noOfGuests: int.parse(booking.noOfGuests.toString()),
                        noOfRooms: int.parse(booking.noOfRooms.toString()),
                        noOfNights: booking.noOfNights,
                        totalPrice: booking.totalPrice,
                        refreshCallback: refreshCallback,
                      )),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDetailsCompleted(
                        city: booking.city,
                        country: booking.country,
                        hotelImage: booking.hotelImage,
                        hotelName: booking.hotelName,
                        checkInDate: booking.checkInDate,
                        checkOutDate: booking.checkOutDate,
                        roomType: booking.roomType,
                        noOfGuests: int.parse(booking.noOfGuests.toString()),
                        noOfRooms: int.parse(booking.noOfRooms.toString()),
                        noOfNights: booking.noOfNights,
                        totalPrice: booking.totalPrice,
                      )),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Container(
          height: 170,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: AssetImage(booking.hotelImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  booking.hotelName,
                  style: GoogleFonts.dmSans(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  DateFormat('MMMM d, yyyy \'at\' hh:mm:ss a')
                      .format(booking.checkInDate),
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
