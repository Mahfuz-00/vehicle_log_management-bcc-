import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Login UI/loginUI.dart';
import '../Staff Dashboard/staffdashboardUI.dart';
import '../Template Models/dropdownmodel.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import 'radiooption.dart';

class TripRequestForm extends StatefulWidget {
  const TripRequestForm({super.key});

  @override
  State<TripRequestForm> createState() => _TripRequestFormState();
}

class _TripRequestFormState extends State<TripRequestForm> {
  late TextEditingController _Clockcontroller= TextEditingController();
  late TextEditingController _Datecontroller= TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _Clockcontroller.dispose();
    _Datecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<String> dropdownItems1 = [
      "Option 1", "Option 2", "Option 3",
    ];

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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text('New Trip Request',
                        style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'default',
                    )),
                    SizedBox(height: 20),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          border:  const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Designation',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          border:  const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownMenuModel(label: 'Department', options: dropdownItems1, onChanged: null,),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Purpose',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          border:  const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          border:  const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownMenuModel(label: 'Destination From', options: dropdownItems1, onChanged: null,),
                    SizedBox(height: 10),
                    DropdownMenuModel(label: 'Destination To', options: dropdownItems1, onChanged: null,),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _Clockcontroller,
                        readOnly: true, // Make the text field readonly
                        enableInteractiveSelection: false, // Disable interactive selection
                        enableSuggestions: false, // Disable suggestions
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          contentPadding: EdgeInsets.all(10),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((selectedTime) {
                                if (selectedTime != null) {
                                  _Clockcontroller.text = selectedTime.format(context);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                              child: Icon(Icons.schedule_rounded, size: 30,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.075,
                      child: TextFormField(
                        controller: _Datecontroller,
                        readOnly: true,
                        enableInteractiveSelection: false,
                        enableSuggestions: false,
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                                  _Datecontroller.text = formattedDate;
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                              child: Icon(Icons.calendar_today_outlined, size: 30,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Trip Type',
                              //textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default'
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.025),
                      child:
                      RadioListTileGroup(
                        options: ['One Way', 'Two Way'],
                        selectedOption: null,
                        onChanged: (String value) {
                          print('Selected option: $value');
                          // You can perform any other actions here based on the selected option
                        },),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width* 0.9, MediaQuery.of(context).size.height * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => StaffDashboard()));
                        },
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                      ),
                    ),
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
