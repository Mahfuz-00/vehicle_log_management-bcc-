import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../Template Models/customclipperbottomnavbar.dart';
import '../Template Models/customnotchpainter.dart';
import '../Template Models/userdetailsnewtripdriver.dart';
import '../Template Models/userdetailsrecenttrip.dart';
import '../Template Models/userdetailstilesDriverNew.dart';
import '../Template Models/userdetailstilesDriverRecent.dart';
import '../Template Models/userinfodriver.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import 'driverdashboardongoing.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fabHeight = 56.0; // Default FAB height is 56, adjust if your FAB size is different
    double containerHeight = screenHeight * 0.08; // Your container height

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text(
          'Driver Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
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
                    Column(
                      children: [
                        UserListTileNew(staff: User(
                          name: 'Md. Labib Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Banani to Cumilla', duration: '',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoNewDriver(staff: User(
                              name: 'Md. Labib Hossain',
                              designation: 'Jr Software Engineer',
                              department: 'IT',
                              tripType: 'One Way',
                              dateTime: DateTime(2024, 3, 20, 14, 30),
                              destination: 'Banani to Cumilla',
                              duration: '',
                            ),)),
                          );
                        },),
                        UserListTileNew(staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Shamoli to Banani',
                          duration: '',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoNewDriver(staff: User(
                              name: 'Md. Sabbir Hossain',
                              designation: 'Jr Software Engineer',
                              department: 'IT',
                              tripType: 'One Way',
                              dateTime: DateTime(2024, 3, 20, 14, 30),
                              destination: 'Shamoli to Banani', duration: '',
                            ),)),
                          );
                        },),
                        UserListTileNew(staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Old Dhaka to Banani',
                          duration: '',
                        ), onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfoNewDriver(staff: User(
                              name: 'Md. Sabbir Hossain',
                              designation: 'Jr Software Engineer',
                              department: 'IT',
                              tripType: 'One Way',
                              dateTime: DateTime(2024, 3, 20, 14, 30),
                              destination: 'Old Dhaka to Banani',
                              duration: '',
                            ),)),
                          );
                        },),
                      ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DriverDashboardOngoing()),
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
      ),
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
              Container(
                width: screenWidth / 3,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 192, 122, 1),
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.025,
                      width: screenWidth * 0.04,
                      child: IconButton(
                        icon: const Icon(
                          Icons.home,
                          size: 20,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VLMDashboard()));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
              ClipPath(
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
                              fontSize: 12,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                      /*  CustomPaint(
                          painter: NotchPainter(),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
              Container(
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
                    SizedBox(
                      height: screenHeight * 0.025,
                      width: screenWidth * 0.04,
                      child: IconButton(
                        icon: const Icon(
                          Icons.info,
                          size: 20,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ));*/
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
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
}
