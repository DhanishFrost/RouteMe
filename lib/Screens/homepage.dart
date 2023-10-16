import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './favorites.dart';
import './mybooking.dart';
import './myprofile.dart';
import './hoteldetails.dart';

class HomePage extends StatefulWidget {
  final File? imageFile;
  const HomePage({Key? key, this.imageFile}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String currentAddress = 'Unknown';
  String? username;
  String search = '';
  File? _imageFile;
  late SharedPreferences _prefs;

  late List<Hotel> hotelList = [];

  List<Hotel> sortedHotelList = [];
  bool locationFetched = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchUsername();
    fetchHotels();
  }

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

  void fetchHotels() {
    FirebaseFirestore.instance
        .collection('Hotels')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Hotel hotel = Hotel(
          imageName: doc['imageName'],
          name: doc['hotelname'],
          description: doc['description'],
          city: doc['city'],
          country: doc['country'],
          rating: (doc['rating']).toDouble(),
          price: (doc['price']),
        );
        setState(() {
          hotelList.add(hotel);
          _sortHotelList();
        });
      });
    }).catchError((error) => print('Failed to fetch hotels: $error'));
  }

  Future<void> _fetchUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      final fetchedUsername = await _getUsername();
      setState(() {
        username = fetchedUsername;
      });
    }
  }

  Future<String?> _getUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      return user.displayName;
    }
    return null;
  }

  void _sortHotelList() {
    if (currentAddress != 'Unknown') {
      setState(() {
        sortedHotelList = List.from(hotelList);
        sortedHotelList.sort((a, b) {
          if (a.city == currentAddress.split(',')[0] &&
              a.country == currentAddress.split(',')[1]) {
            return -1;
          } else if (b.city == currentAddress.split(',')[0] &&
              b.country == currentAddress.split(',')[1]) {
            return 1;
          } else if (a.city == 'Colombo' &&
              a.country == 'Sri Lanka' &&
              b.city != currentAddress.split(',')[0] &&
              b.country != currentAddress.split(',')[1]) {
            return -1;
          } else if (b.city == 'Colombo' &&
              b.country == 'Sri Lanka' &&
              a.city != currentAddress.split(',')[0] &&
              a.country != currentAddress.split(',')[1]) {
            return 1;
          } else {
            return 0;
          }
        });
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
        // Already on the HomePage screen, no need to navigate
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Favorites()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyBooking()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyProfile()));
        break;
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: 'Please keep your location on',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
        msg: 'Location permission is denied',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: 'Location permission is denied forever',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        currentAddress = "${place.locality}, ${place.country}";
        locationFetched = true;
        _sortHotelList();
        print(currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.98,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 25, top: 10),
                              child: Text(
                                'Hello $username!',
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xFFDE7254),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _determinePosition();
                                    },
                                    child: Text(
                                      currentAddress,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFDE7254),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : null,
                          child: _imageFile == null
                              ? Icon(
                                  Icons.account_circle,
                                  color: Color(0xFFDE7254),
                                  size: 60,
                                )
                              : null,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[200],
                      ),
                      child: Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                              color: const Color(0xFFDE7254),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    search = value
                                        .toLowerCase(); // Convert the search query to lowercase
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Start searching here...',
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF828F9C),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_alt_rounded),
                              color: const Color(0xFFDE7254),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Categories',
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 45,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFDE7254),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(
                              Icons.category_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            label: Text(
                              'All',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Color(0xFFE7E7EF),
                                ),
                              ),
                            ),
                            icon: const Icon(
                              Icons.restaurant_rounded,
                              size: 20,
                              color: Color(0xFF828F9C),
                            ),
                            label: Text(
                              'Accommodations',
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF828F9C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Color(0xFFE7E7EF),
                                ),
                              ),
                            ),
                            icon: const Icon(
                              Icons.forest_rounded,
                              size: 20,
                              color: Color(0xFF828F9C),
                            ),
                            label: Text(
                              'Tours & Activities',
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF828F9C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotelList.length,
                        itemBuilder: (context, index) {
                          Hotel hotel = hotelList[index];

                          if (hotel.rating < 4.7) {
                            return SizedBox.shrink();
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelDetails(
                                    hotelName: hotel.name,
                                    imageName: hotel.imageName,
                                    description: hotel.description,
                                    city: hotel.city,
                                    country: hotel.country,
                                    rating: hotel.rating,
                                    price: hotel.price,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(hotel.imageName),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 12),
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 115, 5, 0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFAF9F9),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            hotel.name,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 15,
                                                color: Color(0xFF828F9C),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  hotel.city +
                                                      ', ' +
                                                      hotel.country,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF828F9C),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                size: 15,
                                                color: Color(0xFFDEB754),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${hotel.rating} | ${hotel.rating} Reviews',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF828F9C),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      child: locationFetched
                          ? sortedHotelList.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedHotelList.length,
                                  itemBuilder: (context, index) {
                                    final hotel = sortedHotelList[index];

                                    if (hotel.name
                                        .toLowerCase()
                                        .contains(search)) {
                                      return HotelCard(hotel: hotel);
                                    }
                                    return Container();
                                  },
                                )
                              : Container(
                                  child: const Text('No hotels found',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF828F9C),
                                      )),
                                )
                          : const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'homepage'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: ''),
        ],
      ),
    );
  }
}

class Hotel {
  final String imageName;
  final String name;
  final String description;
  final String city;
  final String country;
  final double rating;
  final int price;

  Hotel({
    required this.imageName,
    required this.name,
    required this.description,
    required this.city,
    required this.country,
    required this.rating,
    required this.price,
  });
}

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              hotel.imageName,
              width: 65,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    hotel.name.length > 8
                        ? '${hotel.name.substring(0, 8)}..'
                        : hotel.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBEEDA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restaurant_rounded,
                          size: 15,
                          color: Color(0xFFA56A12),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Accommodation',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: const Color(0xFFA56A12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 15,
                    color: Color(0xFF828F9C),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${hotel.city}, ${hotel.country}',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: const Color(0xFF828F9C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFDEB754),
                          ),
                        ),
                        TextSpan(
                          text: '${hotel.rating} |',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: const Color(0xFF828F9C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' LKR ${hotel.price}',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '/night',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: const Color(0xFF828F9C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 35,
            height: 80,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetails(
                      hotelName: hotel.name,
                      imageName: hotel.imageName,
                      description: hotel.description,
                      city: hotel.city,
                      country: hotel.country,
                      rating: hotel.rating,
                      price: hotel.price,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Color(0xFFE7E7EF),
                  ),
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFDE7254),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
