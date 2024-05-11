import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Template Models/customclipperbottomnavbar.dart';
import '../Template Models/customnotchpainter.dart';
import '../Template Models/userdetailsrecenttrip.dart';
import '../Template Models/userdetailstilesDriverRecent.dart';
import '../Template Models/userinfodriver.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import 'driverdashboardUI.dart';

class DriverDashboardNoNewTrip extends StatefulWidget {
  const DriverDashboardNoNewTrip({super.key});

  @override
  State<DriverDashboardNoNewTrip> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboardNoNewTrip> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 28,),
            const Text(
              'Driver Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Column(
                  children: [
                    Text('New Trip',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'default',
                        )),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      height: screenHeight*0.4,
                      width: screenWidth*0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                              Radius.circular(10),
                        ),
                      ),
                      child: Center(child: Text('No New Trip',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'default',
                        ),
                      )),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text('Recent Trip',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'default',
                        )),
                    SizedBox(height: screenHeight * 0.01),
                    Column(
                      children: [
                        UserListTileRecent(staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Banani to Mirpur-10',
                          duration: '4',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoRecentDriver(staff: User(
                              name: 'Md. Sabbir Hossain',
                              designation: 'Jr Software Engineer',
                              department: 'IT',
                              tripType: 'One Way',
                              dateTime: DateTime(2024, 3, 20, 14, 30),
                              destination: 'Banani to Mirpur-10',
                              duration: '4',
                            ),)),
                          );
                        },),
                        UserListTileRecent(staff: User(
                          name: 'Md. Sajjad Hasan',
                          designation: 'Sr Software Engineer',
                          department: 'Software',
                          tripType: 'Two Way',
                          dateTime: DateTime(2024, 3, 20, 1, 30),
                          destination: 'Dhanmondi to Mirpur-1',
                          duration: '2',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoRecentDriver(staff: User(
                              name: 'Md. Sajjad Hasan',
                              designation: 'Sr Software Engineer',
                              department: 'Software',
                              tripType: 'Two Way',
                              dateTime: DateTime(2024, 3, 20, 1, 30),
                              destination: 'Dhanmondi to Mirpur-1', duration: '2',
                            ),)),
                          );
                        },),
                        UserListTileRecent(staff: User(
                          name: 'Md. habib Hossain',
                          designation: 'Software Engineer',
                          department: 'Sales',
                          tripType: 'One Way',
                          dateTime: DateTime(2024, 8, 20, 14, 30),
                          destination: 'Mirpur DOHS to Mirpur-1',
                          duration: '1',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoRecentDriver(staff: User(
                              name: 'Md. habib Hossain',
                              designation: 'Software Engineer',
                              department: 'Sales',
                              tripType: 'One Way',
                              dateTime: DateTime(2024, 8, 20, 14, 30),
                              destination: 'Mirpur DOHS to Mirpur-1', duration: '1',
                            ),)),
                          );
                        },),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
/*      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: screenWidth/2.85,
            child: Container(
              height: screenHeight*0.17,
              width: screenWidth*0.3,
              child: FloatingActionButton.large(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                      content: Container(
                        height: screenHeight*0.3,
                          width: screenWidth*0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Text(
                                'Warning!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'default',
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Text(
                              'No New Trip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'default',
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                                    fixedSize: Size(MediaQuery.of(context).size.width* 0.6, MediaQuery.of(context).size.height * 0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DriverDashboard()),
                                    );
                                  },
                                  child: Text('Retrun to Home',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'default',
                                    color: Colors.white,
                                  ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ),
                      );
                    },
                  );
                },
                tooltip: 'Start Engine',
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  'Assets/Images/Start Engine.png',
                  width: screenWidth*0.28,
                  height: screenWidth*0.28,
                  fit: BoxFit.cover,
                ),
                elevation: 0.0,
              ),
            ),
          ),
        ],
      ),*/
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 5,
        height: screenHeight * 0.08,
        padding: EdgeInsets.all(0),
        notchMargin: 10.0,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverDashboard()));
                },
                child: Container(
                  width: screenWidth / 3,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 192, 122, 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'default',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile()));
                },
                child: Container(
                  width: screenWidth / 3,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 192, 122, 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'default',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*      ClipPath(
                clipper: NotchClipper(),
                child: CustomPaint(
                  painter: NotchPainter(),
                  child: Container(
                    decoration: BoxDecoration(
                      //color: const Color.fromRGBO(25, 192, 122, 1),
                      border: Border(
                        left: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    width: screenWidth / 3,
                    height: screenHeight * 0.9,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: screenHeight * 0.01,
                          left: 0,
                          right: 0,
                          child: Text(
                            'Start Engine',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                      *//*  CustomPaint(
                          painter: NotchPainter(),
                        ),*//*
                      ],
                    ),
                  ),
                ),
              ),*/
              GestureDetector(
                onTap: (){
                  _showLogoutDialog(context);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      border: Border(
                        left: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      )),
                  width: screenWidth / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'default',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        height: screenHeight*0.08,
        style: TabStyle.custom,
        curveSize: 90,
        color: Colors.white,
        items: [
          TabItem(icon: Icons.home, title: 'Home', fontFamily: 'default'),
          TabItem(icon: Image.asset(
            'Assets/Images/Start Engine.png',
          ), title: 'Start Engine', fontFamily: 'default'),
          TabItem(icon: Icons.info, title: 'Information', fontFamily: 'default'),
        ],
        initialActiveIndex: 0,
        onTap: (int i) {
          if (i == 0) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VLMDashboard()));
          } else {
          print('Tab $i.title tapped');
          }
        },
      ),*/
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Logout Confirmation',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'default',
                ),),
              Divider()
            ],
          ),
          content: Text('Are you sure you want to log out?',
            style: TextStyle(
              color: const Color.fromRGBO(25, 192, 122, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  child: Text('Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),),
                ),
              ],
            )
          ],
        );
      },
    );
  }

}
