import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './homepage.dart';

class BookNowComplete extends StatefulWidget {
  const BookNowComplete(
      {Key? key,
      required this.hotelImage,
      required this.hotelName,
      required this.hotelPrice,
      required this.roomType,
      required this.noOfGuests,
      required this.noOfRooms,
      required this.checkInDate,
      required this.checkOutDate,
      required this.noOfNights,
      required this.totalPrice});

  final String hotelImage;
  final String hotelName;
  final int hotelPrice;
  final String roomType;
  final int noOfGuests;
  final int noOfRooms;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String noOfNights;
  final totalPrice;

  @override
  State<BookNowComplete> createState() => _BookNowCompleteState();
}

class _BookNowCompleteState extends State<BookNowComplete> {
  String? username;
  String? email;

  void requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
    } else {
      print('Permission denied');
      _showToast('Permission denied');
    }
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

  Future<pw.Document> generatePDF() async {
    final pdf = pw.Document();

    // Create a page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'RouteMe',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Container(
                  width: 800,
                  height: 1,
                  color: PdfColors.grey400,
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Paid By',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        username ?? '',
                        style: pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      pw.Text(
                        email ?? '',
                        style: pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text(
                        'Booking Details',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Hotel Name:                                     ${widget.hotelName}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        'Room Type:                                      ${widget.roomType}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        'Number of Guests:                            ${widget.noOfGuests}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        'Number of Rooms:                            ${widget.noOfRooms}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        'Check-in Date:                                  ${DateFormat('dd/MM/yyyy').format(widget.checkInDate)}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        'Check-out Date:                                ${DateFormat('dd/MM/yyyy').format(widget.checkOutDate)}',
                        style: pw.TextStyle(fontSize: 16),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        'Total Price: LKR                                ${widget.totalPrice}',
                        style: pw.TextStyle(fontSize: 16),
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

    return pdf;
  }

  

  Future<void> generateReceipt() async {

    await _fetchUserData();

    final pdf = await generatePDF();

    // Request permission to access external storage (Android specific)
    await Permission.storage.request();

    // Get the directory for saving the file
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/receipt.pdf';

      // Save the PDF file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Show a toast or dialog to notify the user about the successful download
      Fluttertoast.showToast(msg: 'PDF saved to device');

      // Open the gallery or file manager to view the downloaded file (optional)
      OpenFile.open(filePath);
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
            child: Column(children: [
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 30, top: 60),
        child: Text(
          'Complete',
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
                    color: Color(0xffDE7254)),
              ),
            ),
            Positioned(
              top: screenHeight * 0.015,
              left: screenWidth * 0.8,
              child: CircleAvatar(
                radius: screenWidth * 0.03,
                backgroundColor: Color(0xffDE7254),
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
      Container(
        margin: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xffDE7254),
                    size: 100,
                  ),
                  Text(
                    'Payment Success',
                    style: GoogleFonts.dmSans(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Payment have been complete, enjoy your stay!',
                    style: GoogleFonts.dmSans(
                      fontSize: screenWidth * 0.036,
                      color: Color(0xff828F9C),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 20),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: AssetImage(widget.hotelImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    child: Text(
                      widget.hotelName,
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 340,
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, bottom: 15),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xffDE7254),
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(widget.checkInDate),
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(widget.checkOutDate),
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          color: Color(0xffDE7254),
                          size: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. ${widget.totalPrice}',
                              style: GoogleFonts.dmSans(
                                fontSize: screenWidth * 0.036,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDE7254),
            minimumSize: const Size(350, 60),
            shape: const StadiumBorder(),
          ),
          child: Text(
            'Back to home',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        margin: EdgeInsets.fromLTRB(18, 0, 18, 10),
        child: TextButton(
          onPressed: () async {
            await generateReceipt();
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
            'Download Reciept',
            style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(Colors.black.value)),
          ),
        ),
      ),
    ])));
  }
}
