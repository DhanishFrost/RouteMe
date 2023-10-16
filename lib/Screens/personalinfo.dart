import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import './myprofile.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _auth = FirebaseAuth.instance;
  late User _currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> cameras = [];

  late SharedPreferences _prefs;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initPrefs();
    _reauthenticateAndSaveChanges();
    _currentUser = _auth.currentUser!;
    _nameController.text = _currentUser.displayName ?? '';
    _emailController.text = _currentUser.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _reauthenticateAndSaveChanges() async {
    // Prompt the user to reauthenticate before updating the email
    try {
      final authCredential = EmailAuthProvider.credential(
        email: _currentUser.email!,
        password: _passwordController.text,
      );
      await _currentUser.reauthenticateWithCredential(authCredential);

      // Update the user's email address
      await _currentUser.updateEmail(_emailController.text);

      // Update the user's display name
      await _currentUser.updateDisplayName(_nameController.text);

      // Update the user's password
      if (_passwordController.text.isNotEmpty) {
        await _currentUser.updatePassword(_passwordController.text);
      }

      Navigator.pop(context);
    } catch (error) {
      // Handle reauthentication errors
      print('Reauthentication failed: $error');
      // Display an error message to the user or take appropriate action
    }
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Retrieve the image path from shared preferences
    _imagePath = _prefs.getString('imagePath') ?? '';
    if (_imagePath.isNotEmpty) {
      // If there's an image path, load the image file using the path
      setState(() {
        _imageFile = XFile(_imagePath);
      });
    }
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Choose an option",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _openCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text(
                      "Camera",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _openGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text(
                      "Gallery",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // Save the image path to shared preferences
      _prefs.setString('imagePath', pickedFile.path);
      setState(() {
        _imageFile = pickedFile;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(imageFile: File(_imageFile!.path)),
          ),
        );
      });
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Save the image path to shared preferences
      _prefs.setString('imagePath', pickedFile.path);
      setState(() {
        _imageFile = pickedFile;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(imageFile: File(_imageFile!.path)),
          ),
        );
      });
    }
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
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 30, top: 10),
            child: Text(
              'Personal Info',
              style: GoogleFonts.dmSans(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF81361E),
                  width: 2,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _showImagePickerDialog();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : null,
                  child: _imageFile == null
                      ? Icon(
                          Icons.account_circle,
                          color: Color(0xFF81361E),
                          size: 60,
                        )
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Form(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 18, 25, 0),
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
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF828F9C),
                        ),
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(30, 20, 0, 20),
                        filled: true,
                        fillColor: Color(0xFFF6F8FC),
                        suffixIcon: Container(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit),
                              color: Color(0xffDE7254),
                            ),
                          ),
                        )),
                    keyboardType: TextInputType.name,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 18, 25, 0),
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
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF828F9C),
                        ),
                        labelText: 'Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(30, 20, 0, 20),
                        filled: true,
                        fillColor: Color(0xFFF6F8FC),
                        suffixIcon: Container(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit),
                              color: Color(0xffDE7254),
                            ),
                          ),
                        )),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 18, 25, 0),
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
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF828F9C),
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(30, 20, 0, 20),
                        filled: true,
                        fillColor: Color(0xFFF6F8FC),
                        suffixIcon: Container(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit),
                              color: Color(0xffDE7254),
                            ),
                          ),
                        )),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    _currentUser.updateDisplayName(_nameController.text);
                    _currentUser.updateEmail(_emailController.text);
                    _currentUser.updatePassword(_passwordController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDE7254),
                    minimumSize: Size(screenWidth * 0.92, 50),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ])));
  }
}
