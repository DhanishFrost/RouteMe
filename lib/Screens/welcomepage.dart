import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './login.dart';
import './signup.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({super.key});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/welcomepage.jpg',
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.58,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Discover new places !',
              style: GoogleFonts.dmSans(
                textStyle: const TextStyle(color: Colors.black),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(27, 5, 27, 20),
              child: Text(
                'Find the best hotels in the country to make your stay more memorable and enjoy the luxury of food and culture.',
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(color: Color(0xFF828F9C)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => login()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDE7254),
                  minimumSize: const Size(350, 60),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
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
                  'Sign Up',
                  style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black.value)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
