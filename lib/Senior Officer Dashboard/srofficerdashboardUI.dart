import 'package:flutter/material.dart';

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
          'Sr Officer Dashboard',
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
