import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './login.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textEditingController = TextEditingController();
  int _currentCount = 0;
  int _maxCount = 150;

  void _updateCount() {
    setState(() {
      _currentCount = _textEditingController.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_updateCount);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_updateCount);
    _textEditingController.dispose();
    super.dispose();
  }

  void _deleteAccount() async {
    try {
      final User? user = _auth.currentUser;
      await user!.delete();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
      _showToast('Account deleted successfully.');
    } catch (e) {
      if (e.toString().contains('[firebase_auth/requires-recent-login]')) {
        _showToast('Please re-login to delete your account.');
      } else {
        _showToast('Error: $e');
      }
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

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Delete your account',
                style: GoogleFonts.dmSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                'Why are you deleting this account?',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 230, 230, 230)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffF6F8FC),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: null,
                      onChanged: (value) {
                        if (value.length <= _maxCount) {
                          _updateCount();
                        } else {
                          _textEditingController.text =
                              value.substring(0, _maxCount);
                          _textEditingController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _textEditingController.text.length),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your reason here...',
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$_currentCount/$_maxCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: TextButton(
                onPressed: () {
                  _confirmDeleteAccount();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Delete Account',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
