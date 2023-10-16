import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingDetailsCompleted extends StatefulWidget {
  const BookingDetailsCompleted({
    Key? key,
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
      required this.totalPrice});

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
  State<BookingDetailsCompleted> createState() =>
      _BookingDetailsCompletedState();
}

class _BookingDetailsCompletedState extends State<BookingDetailsCompleted> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
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
                  height: screenHeight * 0.5,
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
          Container(
            margin:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
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
                    margin: const EdgeInsets.only(top: 20, left: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hotelName,
                          style: GoogleFonts.dmSans(
                            fontSize: screenWidth * 0.065,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 15,
                              color: Color(0xFF828F9C),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.city}, ${widget.country}',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: const Color(0xFF828F9C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Completed',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.037,
                                color: const Color(0xFF26A551),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.circle,
                              color: Color.fromARGB(255, 118, 118, 118),
                              size: 7,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('MMMM d, yyyy \'at\' hh:mm:ss a')
                                    .format(widget.checkInDate),
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.037,
                                color: Colors.black,
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
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 35),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Travel Date',
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
                                'Number of Rooms',
                                style: GoogleFonts.dmSans(
                                  fontSize: screenWidth * 0.038,
                                  color: Color(0xff828F9C),
                                ),
                              ),
                              Text(
                                '${widget.noOfRooms} Room - ${widget.noOfGuests} People',
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
                      width: screenWidth * 0.8,
                      height: 1,
                      color: Colors.grey,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35),
                      child: Text(
                        'Total (LKR)',
                        style: GoogleFonts.dmSans(
                          fontSize: screenWidth * 0.038,
                          color: Color(0xff828F9C),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 2),
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
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5, left: 20),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Completed',
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
              ],
            ),
          )
        ]),
      ),
    );
  }
}
