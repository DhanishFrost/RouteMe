import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './homepage.dart';
import './signup.dart';
import './welcomepage.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Snackbar
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void _resetPassword() async {
    try {
      if (emailController.text.isEmpty) {
        _showToast('Please enter your email');
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      _showToast('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        _showToast('No user found with this email');
      } else if (e.code == 'too-many-requests') {
        _showToast('Too many requests. Try again later');
      } else {
        _showToast('An error occurred. Please try again later');
      }
    }
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => welcomePage()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: GoogleFonts.dmSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  'Happy to see you again! Please enter your email and password to login to your account.',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: Color(0xFF828F9C),
                  ),
                ),
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 35, 20, 0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 20, 0),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _resetPassword();
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4D5761),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          _showToast('Please fill in all the required fields.');
                        } else {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          )
                              .then((value) {
                            print('Logged In');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }).catchError((error) {
                            if (error is FirebaseAuthException) {
                              if (error.code == 'user-not-found') {
                                _showToast(
                                    'Account does not exist. Please sign up.');
                              } else if (error.code == 'wrong-password') {
                                _showToast(
                                    'Incorrect password. Please try again.');
                              } else if (error.code ==
                                  'network-request-failed') {
                                _showToast(
                                    'Please check your internet connection and try again.');
                              } else {
                                _showToast(
                                    'An error occurred. Please try again.');
                              }
                            } else {
                              _showToast(
                                  'An error occurred. Please try again.');
                            }
                            print(error);
                          });
                        }
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFEAEAEA),
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OR',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFEAEAEA),
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(400, 60),
                              shape: const StadiumBorder(),
                              side: BorderSide(
                                color: const Color(0xFFE7E7EF),
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Login with Google',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF828F9C),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF101018),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
