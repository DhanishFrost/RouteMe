import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './deleteaccount.dart';

class PrivacySharing extends StatefulWidget {
  const PrivacySharing({super.key});

  @override
  State<PrivacySharing> createState() => _PrivacySharingState();
}

class _PrivacySharingState extends State<PrivacySharing> {
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Privacy & Sharing',
                style: GoogleFonts.dmSans(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Manage your account data',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 10, right: 20),
              child: Text(
                'You can make a request to delete your personal data from RouteMe.',
                style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff828F9C)),
              ),
            ),
            SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeleteAccount()),
                  );
                },
                style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                ),
                child: Container(
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
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delete your account',
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffDE7254),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'By doing this your account and data will be permanently deleted.',
                                 style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff828F9C)),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),


        ])));
  }
}
