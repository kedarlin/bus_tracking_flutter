import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracking_system/screen/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late CollectionReference<Map<String, dynamic>> locationsCollection;
  bool showCards = false; // State variable to control card visibility

  @override
  void initState() {
    super.initState();
    locationsCollection = FirebaseFirestore.instance.collection('bus tracker');
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform logout operation
                Navigator.of(context).pop();
                // Add your logout logic here
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
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
        backgroundColor: Colors.white,
        title: Text(
          'Select Route',
          style: TextStyle(color: Colors.black),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Select Route'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _showLogoutConfirmationDialog,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Map Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/20240219_192930.jpg', // Replace with the actual path to your map image
              fit: BoxFit.cover,
            ),
          ),

          // Bus Icon
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showCards =
                      !showCards; // Toggle card visibility on bus icon click
                });
              },
              child: Icon(
                FontAwesomeIcons.bus,
                size: 30,
                color: Colors.blue,
              ),
            ),
          ),

          // Location Icon
          Positioned(
            top: MediaQuery.of(context).size.height * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    Colors.black.withOpacity(0.7), // Change the color as needed
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Live Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          // Cards at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: showCards,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: locationsCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final locations = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final locationData = locations[index].data()!;
                        return GestureDetector(
                          onTap: () {
                            // ... (unchanged code for on tap logic)
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.directions_bus,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      locationData['bus_route'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        locationData['passenger'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
