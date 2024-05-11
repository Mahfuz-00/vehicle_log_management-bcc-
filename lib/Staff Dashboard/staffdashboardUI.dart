import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/Profile UI/profileUI.dart';

import '../API Service (Log Out)/apiServiceLogOut.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/userdetailsongoingtripSrOfficer.dart';
import '../Template Models/userdetailstilesSrOfficer.dart';
import '../Template Models/userinfoSrOfficer.dart';
import '../Trip Request Form(Staff)/triprequestformUI.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
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
            SizedBox(
              width: 28,
            ),
            const Text(
              'Staff Dashboard',
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
            icon: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
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
                    fontFamily: 'default',
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const VLMDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Report',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  )),
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
                    fontFamily: 'default',
                  )),
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
                    fontFamily: 'default',
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
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
                    Text('Pending Trip',
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
                            destination: 'Banani to Mirpur-10',
                            driver: 'Md. Jubair Hossain',
                            car: 'NOVA 123',
                            driverNumber: 01234566667,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sabbir Hossain',
                                          designation: 'Jr Software Engineer',
                                          department: 'IT',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 14, 30),
                                          destination: 'Banani to Mirpur-10',
                                          driver: 'Md. Jubair Hossain',
                                          car: 'NOVA 123',
                                          driverNumber: 01234566667,
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
                            destination: 'Dhanmondi to Mirpur-1',
                            driver: 'Md. Salauddin',
                            car: 'KIA 12345',
                            driverNumber: 09124466332,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sajjad Hasan',
                                          designation: 'Sr Software Engineer',
                                          department: 'Software',
                                          tripType: 'Two Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 1, 30),
                                          destination: 'Dhanmondi to Mirpur-1',
                                          driver: 'Md. Salauddin',
                                          car: 'KIA 12345',
                                          driverNumber: 09124466332,
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
                            destination: 'Mirpur DOHS to Mirpur-1',
                            driver: 'Md. Abul hasan',
                            car: 'Toyota 123',
                            driverNumber: 09348928934,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. habib Hossain',
                                          designation: 'Software Engineer',
                                          department: 'Sales',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 8, 20, 14, 30),
                                          destination:
                                              'Mirpur DOHS to Mirpur-1',
                                          driver: 'Md. Abul hasan',
                                          car: 'Toyota 123',
                                          driverNumber: 09348928934,
                                        ),
                                      )),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text('Approved Trip',
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
                            destination: 'Banani to Cumilla',
                            driver: 'Md. Jubair Hossain',
                            car: 'Ford SV 2',
                            driverNumber: 934274564646,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Labib Hossain',
                                          designation: 'Jr Software Engineer',
                                          department: 'IT',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 14, 30),
                                          destination: 'Banani to Cumilla',
                                          driver: 'Md. Jubair Hossain',
                                          car: 'Ford SV 2',
                                          driverNumber: 934274564646,
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
                            destination: 'Shamoli to Banani',
                            driver: 'Md. Jubairuddin',
                            car: 'BMW 88',
                            driverNumber: 34375657567,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sabbir Hossain',
                                          designation: 'Jr Software Engineer',
                                          department: 'IT',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 14, 30),
                                          destination: 'Shamoli to Banani',
                                          driver: 'Md. Jubairuddin',
                                          car: 'BMW 88',
                                          driverNumber: 34375657567,
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
                            destination: 'Old Dhaka to Banani',
                            driver: 'Md. Jubair Hossain',
                            car: 'Nissan 989',
                            driverNumber: 3247829749,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sabbir Hossain',
                                          designation: 'Jr Software Engineer',
                                          department: 'IT',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 14, 30),
                                          destination: 'Old Dhaka to Banani',
                                          driver: 'Md. Jubair Hossain',
                                          car: 'Nissan 989',
                                          driverNumber: 3247829749,
                                        ),
                                      )),
                            );
                          },
                        ),
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
                        UserListTile(
                          staff: User(
                            name: 'Md. Sabbir Hossain',
                            designation: 'Jr Software Engineer',
                            department: 'IT',
                            tripType: 'One Way',
                            purpose: 'Office Work',
                            dateTime: DateTime(2024, 3, 20, 14, 30),
                            destination: 'Banani to Mirpur-10',
                            driver: 'Md. Jubair Hossain',
                            car: 'NOVA 123',
                            driverNumber: 01234566667,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sabbir Hossain',
                                          designation: 'Jr Software Engineer',
                                          department: 'IT',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 14, 30),
                                          destination: 'Banani to Mirpur-10',
                                          driver: 'Md. Jubair Hossain',
                                          car: 'NOVA 123',
                                          driverNumber: 01234566667,
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
                            destination: 'Dhanmondi to Mirpur-1',
                            driver: 'Md. Salauddin',
                            car: 'KIA 12345',
                            driverNumber: 09124466332,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. Sajjad Hasan',
                                          designation: 'Sr Software Engineer',
                                          department: 'Software',
                                          tripType: 'Two Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 3, 20, 1, 30),
                                          destination: 'Dhanmondi to Mirpur-1',
                                          driver: 'Md. Salauddin',
                                          car: 'KIA 12345',
                                          driverNumber: 09124466332,
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
                            destination: 'Mirpur DOHS to Mirpur-1',
                            driver: 'Md. Abul hasan',
                            car: 'Toyota 123',
                            driverNumber: 09348928934,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoOngoingSRO(
                                        staff: User(
                                          name: 'Md. habib Hossain',
                                          designation: 'Software Engineer',
                                          department: 'Sales',
                                          tripType: 'One Way',
                                          purpose: 'Office Work',
                                          dateTime:
                                              DateTime(2024, 8, 20, 14, 30),
                                          destination:
                                              'Mirpur DOHS to Mirpur-1',
                                          driver: 'Md. Abul hasan',
                                          car: 'Toyota 123',
                                          driverNumber: 09348928934,
                                        ),
                                      )),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TripRequestForm()));
                        },
                        child: const Text('New Trip Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                      ),
                    )
                  ],
                ),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StaffDashboard()));
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TripRequestForm()));
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
                      Icons.add_circle_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'New Request',
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
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
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'Logout Confirmation',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'default',
                ),
              ),
              Divider()
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: const Color.fromRGBO(25, 192, 122, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Clear user data from SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userName');
                    await prefs.remove('organizationName');
                    await prefs.remove('photoUrl');
                    // Create an instance of LogOutApiService
                    var logoutApiService = await LogOutApiService.create();

                    // Wait for authToken to be initialized
                    logoutApiService.authToken;

                    // Call the signOut method on the instance
                    if (await logoutApiService.signOut()) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login())); // Close the drawer
                    }
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
