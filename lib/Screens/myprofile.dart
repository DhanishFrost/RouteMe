import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './homepage.dart';
import './favorites.dart';
import './mybooking.dart';
import './personalinfo.dart';
import './paymentmethod.dart';
import './privacysharing.dart';
import './login.dart';

class MyProfile extends StatefulWidget {
  final File? imageFile;

  const MyProfile({Key? key, this.imageFile}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int _currentIndex = 3;
  String? username;
  String? email;
  File? _imageFile;
  late SharedPreferences _prefs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPrefs();
  }


  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final imagePath = _prefs.getString('imagePath') ?? '';
    if (imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }



  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens based on the selected tab index
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(
              imageFile: widget.imageFile
            )));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Favorites(imageFile: widget.imageFile)));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyBooking(imageFile: widget.imageFile)));
        break;
      case 3:
        // Already on the MyProfile screen, no need to navigate
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
                'My Profile',
                style: GoogleFonts.dmSans(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(
                            Icons.account_circle,
                            color: Color(0xFF81361E),
                            size: 60,
                          )
                        : null,
                  ),
                  Text(
                    '$username',
                    style: GoogleFonts.dmSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$email',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Color(0xFF828F9C),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  buildButton(
                    Icons.person,
                    'Personal Info',
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  buildButton(
                    Icons.credit_card,
                    'Payment Methods',
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  buildButton(
                    Icons.privacy_tip,
                    'Privacy & Sharing',
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  buildButton(
                    Icons.logout,
                    'Log Out',
                    color: Color(0xFFDE7254),
                  ),
                ],
              ),
            )
          ],
        ),
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

  Widget buildButton(IconData icon, String label, {Color? color}) {
    return TextButton(
      onPressed: () {
        switch (label) {
          case 'Personal Info':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalInfo(),
              ),
            );
            break;
          case 'Payment Methods':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethod(),
              ),
            );
            break;
          case 'Privacy & Sharing':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacySharing(),
              ),
            );
            break;
          case 'Log Out':
            FirebaseAuth.instance.signOut().then((value) {
              print('Logged Out');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            }).catchError((e) {
              print(e);
            });
            break;
        }
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: color ?? Colors.black,
          ),
          SizedBox(width: 30),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
