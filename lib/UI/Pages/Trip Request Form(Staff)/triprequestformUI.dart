import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Trip Request)/apiServiceTripRequest.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../Widgets/radiooption.dart';
import '../Staff Dashboard/staffdashboardUI.dart';

class TripRequestForm extends StatefulWidget {
  const TripRequestForm({super.key});

  @override
  State<TripRequestForm> createState() => _TripRequestFormState();
}

class _TripRequestFormState extends State<TripRequestForm> {
  late TextEditingController _StartTimecontroller = TextEditingController();
  late TextEditingController _EndTimecontroller = TextEditingController();
  late TextEditingController _Datecontroller = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _desinationController = TextEditingController();
  late TextEditingController _distanceController = TextEditingController();
  late TextEditingController _departmentController = TextEditingController();
  late TextEditingController _purposeController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _destinationfromController =
      TextEditingController();
  late TextEditingController _destinationtoController = TextEditingController();
  late String triptype = '';
  late String tripCatagory = '';
  late TripRequest _tripRequest;
  late DateTime? Date;
  File? _file;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Date = null;
    _tripRequest = TripRequest(
        name: '',
        designation: '',
        department: '',
        purpose: '',
        phone: '',
        destinationFrom: '',
        destinationTo: '',
        date: '',
        startTime: '',
        endTime: '',
        distance: '',
        type: '',
        category: '');
  }

  @override
  void dispose() {
    _StartTimecontroller.dispose();
    _EndTimecontroller.dispose();
    _Datecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InternetChecker(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
          titleSpacing: 5,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaffDashboard(
                              shouldRefresh: true,
                            )));
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: const Text(
            'New Trip Request',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'default',
            ),
          ),
          centerTitle: true,
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
                      Text('Trip Request Form',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'default',
                          )),
                      SizedBox(height: 20),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _nameController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
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
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            //floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _desinationController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your designation';
                            }
                            return null;
                          },
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
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _departmentController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the department you are affiliated with';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Department',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _purposeController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the purpose of your trip and trip details';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Purpose and Trip details',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Only allow digits
                            LengthLimitingTextInputFormatter(11),
                          ],
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your mobile number name';
                            }
                            if (input.length != 11) {
                              return 'Mobile number must be 11 digits';
                            }
                            return null; // Return null if the input is valid
                          },
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
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _destinationfromController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter where the trip will start';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Destination From',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _destinationtoController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the destination of the trip';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Destination To',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _StartTimecontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid time
                                if (value == null || value.isEmpty) {
                                  return 'Please select the start time';
                                }
                                // You can add more complex validation logic if needed
                                return null;
                              },
                              readOnly: true,
                              // Make the text field readonly
                              enableInteractiveSelection: false,
                              // Disable interactive selection
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Start Trip Time',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  // Adjust the padding as needed
                                  child: Icon(
                                    Icons.schedule_rounded,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show the time picker dialog
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      // Check if a time is selected
                                      if (selectedTime != null) {
                                        // Convert selectedTime to a formatted string
                                        /*String formattedTime =
                                            selectedTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                selectedTime.minute.toString().padLeft(2, '0');*/
                                        String formattedTime =
                                            DateFormat('h:mm a').format(
                                          DateTime(
                                              2020,
                                              1,
                                              1,
                                              selectedTime.hour,
                                              selectedTime.minute),
                                        );
                                        print(formattedTime);
                                        // Set the formatted time to the controller
                                        _StartTimecontroller.text =
                                            formattedTime;
                                        print(formattedTime);
                                      } else {
                                        print('No time selected');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _EndTimecontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid time
                                if (value == null || value.isEmpty) {
                                  return 'Please select the end time';
                                }
                                // You can add more complex validation logic if needed
                                return null;
                              },
                              readOnly: true,
                              // Make the text field readonly
                              enableInteractiveSelection: false,
                              // Disable interactive selection
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Stop Trip Time',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  // Adjust the padding as needed
                                  child: Icon(
                                    Icons.schedule_rounded,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show the time picker dialog
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      // Check if a time is selected
                                      if (selectedTime != null) {
                                        // Convert selectedTime to a formatted string
                                        /*String formattedTime =
                                            selectedTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                selectedTime.minute.toString().padLeft(2, '0');*/
                                        String formattedTime =
                                            DateFormat('h:mm a').format(
                                          DateTime(
                                              2020,
                                              1,
                                              1,
                                              selectedTime.hour,
                                              selectedTime.minute),
                                        );
                                        print(formattedTime);
                                        // Set the formatted time to the controller
                                        _EndTimecontroller.text = formattedTime;
                                        print(formattedTime);
                                      } else {
                                        print('No time selected');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _Datecontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid date
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                // You can add more complex validation logic if needed
                                return null;
                              },
                              readOnly: true,
                              // Make the text field readonly
                              enableInteractiveSelection: false,
                              // Disable interactive selection
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Trip Date',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  // Adjust the padding as needed
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show the date picker dialog
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    ).then((selectedDate) {
                                      // Check if a date is selected
                                      if (selectedDate != null) {
                                        // Format the selected date as needed
                                        final formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                        // Set the formatted date to the controller
                                        _Datecontroller.text = formattedDate;
                                        Date = DateTime.parse(formattedDate);
                                        print(formattedDate);
                                      } else {
                                        print('No date selected');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _distanceController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter approximate distance(in KM)';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Approx. Distance of the Trip (in KM)',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Trip Type',
                                //textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default')),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025),
                        child: RadioListTileGroup(
                          options: ['Personal', 'Official'],
                          selectedOption: tripCatagory,
                          onChanged: (String value) {
                            print('Selected option: $value');
                            tripCatagory = value;
                            setState(() {
                              tripCatagory = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Trip Mode',
                                //textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default')),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025),
                        child: RadioListTileGroup(
                          options: ['One-Way', 'Round-Trip'],
                          selectedOption: triptype,
                          onChanged: (String value) {
                            print('Selected option: $value');
                            triptype = value;
                          },
                        ),
                      ),
                      if (tripCatagory == 'Official') ...[
                        SizedBox(height: 15,),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.8,
                                        MediaQuery.of(context).size.height *
                                            0.075),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: _pickFile,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_file == null) ...[
                                        Icon(
                                          Icons.document_scanner,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Pick Attachment (If Any)',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                      ],
                                      if (_file != null) ...[
                                        Text('File Picked',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                      ]
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 192, 122, 1),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.9,
                                MediaQuery.of(context).size.height * 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _tripRequestForm();
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
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _file = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void _tripRequestForm() {
    // Validate and save form data
    if (_validateAndSave()) {
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('triggered Validation');

      // Print each field with its corresponding name
      print('Name: ${_nameController.text}');
      print('Designation: ${_desinationController.text}');
      print('Department: ${_departmentController.text}');
      print('Purpose: ${_purposeController.text}');
      print('Phone: ${_phoneController.text}');
      print('Destination From: ${_destinationfromController.text}');
      print('Destination To: ${_destinationtoController.text}');
      print('Date: ${_Datecontroller.text}');
      print('Start Time: ${_StartTimecontroller.text}');
      print('End Time: ${_EndTimecontroller.text}');
      print('Type: ${triptype}');
      print('Distance: ${_distanceController.text}');
      print('Trip Catagory: ${tripCatagory}');
      // Initialize connection request model
      _tripRequest = TripRequest(
          name: _nameController.text,
          designation: _desinationController.text,
          department: _departmentController.text,
          purpose: _purposeController.text,
          phone: _phoneController.text,
          destinationFrom: _destinationfromController.text,
          destinationTo: _destinationtoController.text,
          date: _Datecontroller.text,
          startTime: _StartTimecontroller.text,
          endTime: _EndTimecontroller.text,
          distance: _distanceController.text,
          type: triptype,
          category: tripCatagory);

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      APIServiceTripRequest().postTripRequest(_tripRequest, _file).then((response) {
        // Handle successful request
        print('Trip request sent successfully!!');
        print(response);
        if (response != null && response == "Trip request successfully") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StaffDashboard(
                      shouldRefresh: true,
                    )),
          );
          const snackBar = SnackBar(
            content: Text('Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        const snackBar = SnackBar(
          content: Text('Error while submitting request'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Handle error
        print('Error sending Trip request: $error');
      });
    } else {
      // Show error snackbar
      const snackBar = SnackBar(
        content: Text('Please fill all required fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return ;
    }
  }

  bool _validateAndSave() {
/*    final requestTypeIsValid = _requestType.isNotEmpty;*/
    final NameIsValid = _nameController.text.isNotEmpty;
    final DesignationIsValid = _desinationController.text.isNotEmpty;
    final DepartmentIsValid = _departmentController.text.isNotEmpty;
    final PurposeIsValid = _purposeController.text.isNotEmpty;
    final PhoneIsValid = _phoneController.text.isNotEmpty;
    final DestinationFromIsValid = _destinationfromController.text.isNotEmpty;
    final DestinationToIsValid = _destinationtoController.text.isNotEmpty;
    final TripStartTimeIsValid = _StartTimecontroller.text.isNotEmpty;
    final TripEndTimeIsValid = _EndTimecontroller.text.isNotEmpty;
    final DistanceIsValid = _distanceController.text.isNotEmpty;
    final TripCategoryIsValid = tripCatagory.isNotEmpty;
    final TripTypeIsValid = triptype.isNotEmpty;
    final DateIsValid = _Datecontroller.text.isNotEmpty;

    // Perform any additional validation logic if needed

    // Check if all fields are valid
    final allFieldsAreValid = NameIsValid &&
        DesignationIsValid &&
        DepartmentIsValid &&
        PurposeIsValid &&
        PhoneIsValid &&
        DestinationFromIsValid &&
        DestinationToIsValid &&
        TripStartTimeIsValid &&
        TripEndTimeIsValid &&
        DistanceIsValid &&
        TripCategoryIsValid &&
        TripTypeIsValid &&
        DateIsValid;

    return allFieldsAreValid;
  }
}
