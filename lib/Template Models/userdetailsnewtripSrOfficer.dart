import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Login UI/loginUI.dart';
import '../Template%20Models/userinfoSrOfficer.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class UserInfoNewSRO extends StatelessWidget{
  final User staff;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserInfoNewSRO({
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
                'Purpose: ${staff.purpose}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Date and Time: ${DateFormat('yyyy-MM-dd hh:mm a').format(staff.dateTime)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              Text(
                'Destination: ${staff.destination}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'default',),
              ),
              Divider(),
              SizedBox(height: 40),
              Center(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width* 0.4, MediaQuery.of(context).size.height * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          )),
                    ),
                    SizedBox(width: screenWidth*0.1,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: Size(MediaQuery.of(context).size.width* 0.4, MediaQuery.of(context).size.height * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Decline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
