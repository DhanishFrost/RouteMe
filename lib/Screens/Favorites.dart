import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './homepage.dart';
import './mybooking.dart';
import './myprofile.dart';
import './hoteldetails.dart';

class Favorites extends StatefulWidget {
  final File? imageFile;
  const Favorites({Key? key, this.imageFile}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int _currentIndex = 1;
  late List<Hotel> hotelfavlist = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        // Retrieve the favorites for the current user
        DocumentSnapshot favoritesSnapshot = await FirebaseFirestore.instance
            .collection('Favorites')
            .doc(userEmail)
            .get();

        if (favoritesSnapshot.exists) {
          Map<String, dynamic> favoritesData =
              favoritesSnapshot.data() as Map<String, dynamic>;

          // Iterate through each hotel in the favorites and add it to the list
          favoritesData.forEach((key, value) {
            Map<String, dynamic> hotelData = value as Map<String, dynamic>;

            hotelfavlist.add(Hotel(
              imageName: hotelData['imageName'] ?? '',
              name: hotelData['hotelName'] ?? '',
              description: hotelData['description'] ?? '',
              city: hotelData['city'] ?? '',
              country: hotelData['country'] ?? '',
              rating: hotelData['rating']?.toDouble() ?? 0.0,
              price: hotelData['price'] ?? 0,
            ));
          });
          // Update the state to trigger a re-render of the UI
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  void removeFavorite(String hotelName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        await FirebaseFirestore.instance
            .collection('Favorites')
            .doc(userEmail)
            .update({
          hotelName: FieldValue.delete(),
        });

        // Remove the hotel from the list
        setState(() {
          hotelfavlist.removeWhere((hotel) => hotel.name == hotelName);
        });
      }
    } catch (e) {
      print('Error removing favorite: $e');
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
            context, MaterialPageRoute(builder: (context) => HomePage(imageFile: widget.imageFile)));
        break;
      case 1:
        // Already in the Favorites screen
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyBooking(imageFile: widget.imageFile)));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyProfile(imageFile: widget.imageFile)));
        break;
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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 20, top: 20),
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Favorites',
              style: GoogleFonts.dmSans(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hotelfavlist.length,
                  itemBuilder: (context, index) {
                    return HotelCard(
                      hotel: hotelfavlist[index],
                      onRemoveFavorite: (hotelName) {
                        removeFavorite(hotelName);
                      },
                    );
                  },
                )),
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
  final Function(String) onRemoveFavorite;

  const HotelCard({
    Key? key,
    required this.hotel,
    required this.onRemoveFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(hotel.name),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onRemoveFavorite(hotel.name);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
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
      ),
    );
  }
}
