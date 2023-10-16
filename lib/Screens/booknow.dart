import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import './booknowpayment.dart';

class BookNow extends StatefulWidget {
  const BookNow({
    Key? key,
    required this.hotelName,
    required this.imageName,
    required this.hotelPrice,
    required this.city,
    required this.country,
  }) : super(key: key);

  final String hotelName;
  final String imageName;
  final int hotelPrice;
  final String city;
  final String country;

  @override
  State<BookNow> createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  final TextEditingController _NoOfGuestsController = TextEditingController();
  final TextEditingController _NoOfRoomsController = TextEditingController();

  List<String> roomTypes = [
    'Single Room',
    'Double Room',
    'Suite',
    'Deluxe King Room',
    'Deluxe Queen Room',
    'Deluxe Twin Room',
  ];

  String? _selectedRoomType;
  String? username;
  String? email;
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('E dd MMMM yyyy');
    return formatter.format(date);
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedCheckInDate = pickedDate;
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedCheckOutDate = pickedDate;
      });
    }
  }

  String calculateTotalPrice() {
  if (_selectedCheckInDate != null && _selectedCheckOutDate != null) {
    int numberOfNights = _selectedCheckOutDate!.difference(_selectedCheckInDate!).inDays;
    int totalPrice = widget.hotelPrice * numberOfNights;
    return '$totalPrice';
  }
  return '0.00';
}

  Future<void> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      final fetchedUsername = await _getUsername(user);
      final fetchedEmail = await _getEmail(user);
      setState(() {
        username = fetchedUsername;
        email = fetchedEmail;
      });
    }
  }

  Future<String?> _getUsername(User user) async {
    return user.displayName;
  }

  Future<String?> _getEmail(User user) async {
    return user.email;
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
        child: Column(
          children: [
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
                      backgroundColor: Color(0xffDE7254),
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
                          color: Color(0xffDE7254)),
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
                      backgroundColor: Color.fromARGB(137, 158, 158, 158),
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
                          color: Colors.black),
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
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 140,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage(widget.imageName),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        widget.hotelName,
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact details',
                style: GoogleFonts.dmSans(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, left: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 25,
                                color: Color(0xFFDE7254),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '$username',
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.mail_rounded,
                                size: 25,
                                color: Color.fromARGB(181, 222, 114, 84),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$email',
                                style: GoogleFonts.dmSans(
                                  fontSize: 17,
                                  color: const Color(0xFF828F9C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                'Booking details',
                style: GoogleFonts.dmSans(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 10),
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
                    DropdownButtonFormField<String>(
                      value: _selectedRoomType,
                      items: roomTypes.map((String roomType) {
                        return DropdownMenuItem<String>(
                          value: roomType,
                          child: Text(roomType),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRoomType = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Room Type',
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
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _NoOfGuestsController,
                      decoration: InputDecoration(
                        hintText: 'No. of guests',
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
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _NoOfRoomsController,
                      decoration: InputDecoration(
                        hintText: 'No. of rooms',
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectCheckInDate();
                            },
                            child: Column(
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
                                  _selectedCheckInDate != null
                                      ? formatDate(_selectedCheckInDate!)
                                      : 'Select date',
                                  style: GoogleFonts.dmSans(
                                    fontSize: screenWidth * 0.038,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectCheckOutDate();
                            },
                            child: Column(
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
                                  _selectedCheckOutDate != null
                                      ? formatDate(_selectedCheckOutDate!)
                                      : 'Select date',
                                  style: GoogleFonts.dmSans(
                                    fontSize: screenWidth * 0.038,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            'Rs ${widget.hotelPrice.toStringAsFixed(2)} x ${_selectedCheckOutDate?.difference(_selectedCheckInDate ?? DateTime.now()).inDays ?? 0} Nights',
                            style: GoogleFonts.dmSans(
                              fontSize: screenWidth * 0.038,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 35),
                          Text(
                            'Rs ${calculateTotalPrice()}',
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
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_selectedCheckInDate == null ||
                          _selectedCheckOutDate == null ||
                          _selectedRoomType == null ||
                          _NoOfGuestsController.text.isEmpty ||
                          _NoOfRoomsController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookNowPayment(
                              city: widget.city,
                              country: widget.country,
                              hotelImage: widget.imageName,
                              hotelName: widget.hotelName,
                              hotelPrice: widget.hotelPrice,
                              checkInDate: _selectedCheckInDate!,
                              checkOutDate: _selectedCheckOutDate!,
                              roomType: _selectedRoomType!,
                              noOfGuests: int.parse(_NoOfGuestsController.text),
                              noOfRooms: int.parse(_NoOfRoomsController.text),
                              noOfNights: 'Rs ${widget.hotelPrice.toStringAsFixed(2)} x ${_selectedCheckOutDate?.difference(_selectedCheckInDate ?? DateTime.now()).inDays ?? 0} Nights',
                              totalPrice: calculateTotalPrice(),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Book Now',
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
                      minimumSize:
                          Size(screenWidth * 0.92, 50),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
