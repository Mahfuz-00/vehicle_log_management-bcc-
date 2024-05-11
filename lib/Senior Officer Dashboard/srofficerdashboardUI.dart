import 'package:flutter/material.dart';
import 'package:vehicle_log_management/Profile UI/profileUI.dart';

import '../Login UI/loginUI.dart';
import '../Template Models/userdetailsnewtripSrOfficer.dart';
import '../Template Models/userdetailsongoingtripSrOfficer.dart';
import '../Template Models/userdetailstilesSrOfficer.dart';
import '../Template Models/userinfoSrOfficer.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class SROfficerDashboard extends StatefulWidget {
  const SROfficerDashboard({super.key});

  @override
  State<SROfficerDashboard> createState() => _SROfficerDashboardState();
}

class _SROfficerDashboardState extends State<SROfficerDashboard> {
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
              'Sr Officer Dashboard',
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
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoNewSRO(staff: User(
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
                          ),)),
                        );
                      },),
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoNewSRO(staff: User(
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
                          ),)),
                        );
                      },),
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoNewSRO(staff: User(
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
                          ),)),
                        );
                      },),
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
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoOngoingSRO(staff: User(
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
                          ),)),
                        );
                      },),
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoOngoingSRO(staff: User(
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
                          ),)),
                        );
                      },),
                      UserListTile(staff: User(
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
                      ), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoOngoingSRO(staff: User(
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
                          ),)),
                        );
                      },),
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
                        builder: (context) => SROfficerDashboard()));
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
