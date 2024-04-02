import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text(
          'Admin Dashboard',
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
            Container(
              width: screenWidth / 3,
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              )),
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
            Container(
              decoration: BoxDecoration(
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
                        Icons.search,
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
                    'Search',
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
            Container(
              decoration: BoxDecoration(
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
    );
  }
}
