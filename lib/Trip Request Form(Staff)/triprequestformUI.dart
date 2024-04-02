import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text(
          'Staff Dashboard',
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
                              child: Icon(Icons.schedule_rounded, size: 40,),
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
                              child: Icon(Icons.calendar_today_outlined, size: 40,),
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
