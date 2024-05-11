import 'package:flutter/material.dart';
import 'package:vehicle_log_management/Profile UI/profileUI.dart';

import '../Login UI/loginUI.dart';
import '../Template Models/Logoutalert.dart';
import '../Template Models/driverlist.dart';
import '../Template Models/userdetailsnewtripAdmin.dart';
import '../Template Models/userdetailsongoingtripAdmin.dart';
import '../Template Models/userdetailstilesAdmin.dart';
import '../Template Models/userinfoAdmin.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 28,),
            const Text(
              'BCC Admin Dashboard',
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Column(
                children: [
                  Text('Available Drivers',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'default',
                      )),
                  SizedBox(height: screenHeight * 0.01),
                  DriverInfo(
                    driverName: 'Md. Abbas Hossain',
                    driverMobileNumber: '011324234',
                    carName: 'Ford',
                  ),
                  DriverInfo(
                    driverName: 'Md. Akbar Ullah',
                    driverMobileNumber: '0113242432334',
                    carName: 'BMW',
                  ),
                  DriverInfo(
                    driverName: 'Md. Habib',
                    driverMobileNumber: '01132423445445',
                    carName: 'Nissan',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Available Cars',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'default',
                      )),
                  SizedBox(height: screenHeight * 0.01),
                  Text('Available Cars Info will be here!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'default',
                      )),
                  SizedBox(height: screenHeight * 0.03),
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
                      UserListTile(
                        staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Dhaka to Cumilla',
                          driver: '',
                          car: '',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoNew(
                                      staff: User(
                                        name: 'Md. Sabbir Hossain',
                                        designation: 'Jr Software Engineer',
                                        department: 'IT',
                                        tripType: 'One Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 3, 20, 14, 30),
                                        destination: 'Dhaka to Cumilla',
                                        driver: '',
                                        car: '',
                                      ),
                                    )),
                          );
                        },
                      ),
                      UserListTile(
                        staff: User(
                          name: 'Md. Sajjad Hasan',
                          designation: 'Sr Software Engineer',
                          department: 'Software',
                          tripType: 'Two Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 3, 20, 1, 30),
                          destination: 'Dhaka to Mirpur',
                          driver: '',
                          car: '',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoNew(
                                      staff: User(
                                        name: 'Md. Sajjad Hasan',
                                        designation: 'Sr Software Engineer',
                                        department: 'Software',
                                        tripType: 'Two Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 3, 20, 1, 30),
                                        destination: 'Dhaka to Mirpur',
                                        driver: '',
                                        car: '',
                                      ),
                                    )),
                          );
                        },
                      ),
                      UserListTile(
                        staff: User(
                          name: 'Md. habib Hossain',
                          designation: 'Software Engineer',
                          department: 'Sales',
                          tripType: 'One Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 8, 20, 14, 30),
                          destination: 'Banani to Mirpur',
                          driver: '',
                          car: '',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoNew(
                                      staff: User(
                                        name: 'Md. habib Hossain',
                                        designation: 'Software Engineer',
                                        department: 'Sales',
                                        tripType: 'One Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 8, 20, 14, 30),
                                        destination: 'Banani to Mirpur',
                                        driver: '',
                                        car: '',
                                      ),
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Ongoing Trip',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'default',
                      )),
                  SizedBox(height: screenHeight * 0.01),
                  Column(
                    children: [
                      UserListTile(
                        staff: User(
                          name: 'Md. Labib Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Banani',
                          driver: 'Md. Jubair Hossain',
                          car: 'BMW',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoOngoingAdmin(
                                      staff: User(
                                        name: 'Md. Labib Hossain',
                                        designation: 'Jr Software Engineer',
                                        department: 'IT',
                                        tripType: 'One Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 3, 20, 14, 30),
                                        destination: 'Banani',
                                        driver: 'Md. Jubair Hossain',
                                        car: 'BMW',
                                      ),
                                    )),
                          );
                        },
                      ),
                      UserListTile(
                        staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Banani',
                          driver: 'Md. Jubair Hossain',
                          car: 'Ford',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoOngoingAdmin(
                                      staff: User(
                                        name: 'Md. Sabbir Hossain',
                                        designation: 'Jr Software Engineer',
                                        department: 'IT',
                                        tripType: 'One Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 3, 20, 14, 30),
                                        destination: 'Banani',
                                        driver: 'Md. Jubair Hossain',
                                        car: 'Ford',
                                      ),
                                    )),
                          );
                        },
                      ),
                      UserListTile(
                        staff: User(
                          name: 'Md. Sabbir Hossain',
                          designation: 'Jr Software Engineer',
                          department: 'IT',
                          tripType: 'One Way',
                          purpose: 'Office Work',
                          dateTime: DateTime(2024, 3, 20, 14, 30),
                          destination: 'Banani',
                          driver: 'Md. Jubair Hossain',
                          car: 'Nissan',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoOngoingAdmin(
                                      staff: User(
                                        name: 'Md. Sabbir Hossain',
                                        designation: 'Jr Software Engineer',
                                        department: 'IT',
                                        tripType: 'One Way',
                                        purpose: 'Office Work',
                                        dateTime: DateTime(2024, 3, 20, 14, 30),
                                        destination: 'Banani',
                                        driver: 'Md. Jubair Hossain',
                                        car: 'Nissan',
                                      ),
                                    )),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color.fromRGBO(25, 192, 122, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminDashboard()));
              },
              child: Container(
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Profile()));
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                _showLogoutDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Logout',
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
