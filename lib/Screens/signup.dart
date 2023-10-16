import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login.dart';
import './homepage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int _selectedOption = 0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validation error messages
  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';

  // Validate username field
  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  // Validate email field
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email address is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  // Validate password field
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  // Display message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 30, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
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
                  'Welcome! Please enter your Name, email and password to create your account.',
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
                      margin: EdgeInsets.fromLTRB(0, 25, 20, 0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF828F9C),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 23, 0, 23),
                          errorText:
                              _usernameError.isNotEmpty ? _usernameError : null,
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
                      child: TextFormField(
                        controller: _emailController,
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
                              const EdgeInsets.fromLTRB(30, 23, 0, 23),
                          errorText:
                              _emailError.isNotEmpty ? _emailError : null,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF828F9C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(30, 23, 0, 23),
                          errorText:
                              _passwordError.isNotEmpty ? _passwordError : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _selectedOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    ),
                    Text(
                      'Traveler',
                      style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101018),
                      ),
                    ),
                    SizedBox(width: 50),
                    Radio(
                      value: 1,
                      groupValue: _selectedOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    ),
                    Text(
                      'Merchant',
                      style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101018),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
                child: ElevatedButton(
                  onPressed: () {
                    // Reset previous error messages
                    setState(() {
                      _usernameError = '';
                      _emailError = '';
                      _passwordError = '';
                    });

                    // Field validations
                    final String? usernameError =
                        _validateUsername(_usernameController.text);
                    final String? emailError =
                        _validateEmail(_emailController.text);
                    final String? passwordError =
                        _validatePassword(_passwordController.text);

                    if (usernameError != null ||
                        emailError != null ||
                        passwordError != null) {
                      // Update error messages
                      setState(() {
                        _usernameError = usernameError ?? '';
                        _emailError = emailError ?? '';
                        _passwordError = passwordError ?? '';
                      });
                    } else {
                      // Field validations passed, create user
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then((userCredential) {
                        // Save the username to the user's profile
                        User? user = userCredential.user;
                        if (user != null) {
                          user
                              .updateDisplayName(_usernameController.text)
                              .then((_) {
                            print('Created New Account');
                            _showSnackBar('Account created successfully');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }).catchError((error) {
                            _showSnackBar(
                                'An error occurred. Please try again.');
                            print(error);
                          });
                        }
                      }).catchError((error) {
                        if (error is FirebaseAuthException) {
                          if (error.code == 'email-already-in-use') {
                            _showSnackBar(
                                'An account with this email already exists');
                          } else {
                            _showSnackBar(
                                'An error occurred. Please try again.');
                          }
                        } else {
                          _showSnackBar('An error occurred. Please try again.');
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
                    'Sign Up',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF828F9C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: Text(
                        'Login',
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
      ),
    );
  }
}
