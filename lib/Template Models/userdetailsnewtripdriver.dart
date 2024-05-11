import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Driver Dashboard/driverdashboardongoing.dart';
import '../Login UI/loginUI.dart';
import '../Template%20Models/userinfodriver.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import 'customclipperbottomnavbar.dart';
import 'customnotchpainter.dart';


class UserInfoNewDriver extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User staff;

  UserInfoNewDriver({
    Key? key,
    required this.staff
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        titleSpacing: 5,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
        title: const Text(
          'Trip Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const Center(
                  child: Text(
                    'New Trip Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: CircleAvatar(
                  child: Icon(Icons.person, size: 50,),
                  radius: 50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Name: ${staff.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Designation: ${staff.designation}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Department: ${staff.department}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Trip Type: ${staff.tripType}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Start Date and Time: ${DateFormat('yyyy-MM-dd hh:mm a').format(staff.dateTime)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Destination: ${staff.destination}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
            ],
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
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VLMDashboard()));
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
                              fontSize: 14,
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
              GestureDetector(
                onTap: (){
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchUser()));*/
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
            ],
          ),
        ),
      ),
    );
  }
}
