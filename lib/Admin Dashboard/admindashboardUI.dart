import 'package:flutter/material.dart';

import '../Login UI/loginUI.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'BCC Admin Dashboard',
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
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(25, 192, 122, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    radius: 30,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VLMDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Report',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BCCReport()));*/
              },
            ),
            Divider(),
            ListTile(
              title: Text('Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
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
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchUser()));*/
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
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Search',
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
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
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
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Information',
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
}
