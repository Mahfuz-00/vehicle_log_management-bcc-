import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../Data/API Service (Trip Request)/apiServiceTripRequest.dart';
import '../../Data/Models/tripRequestModel.dart';
import '../Staff Dashboard/staffdashboardUI.dart';
import '../Widgets/Connection Checker/internetconnectioncheck.dart';
import '../Widgets/radiooption.dart';

class TripRequestForm extends StatefulWidget {
  const TripRequestForm({super.key});

  @override
  State<TripRequestForm> createState() => _TripRequestFormState();
}

class _TripRequestFormState extends State<TripRequestForm> {
  late TextEditingController _Clockcontroller = TextEditingController();
  late TextEditingController _Datecontroller = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _desinationController = TextEditingController();
  late TextEditingController _departmentController = TextEditingController();
  late TextEditingController _purposeController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _destinationfromController =
      TextEditingController();
  late TextEditingController _destinationtoController = TextEditingController();
  late String triptype = '';
  late TripRequest _tripRequest;
  late DateTime? Date;

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
        time: '',
        type: '');
  }

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
                              controller: _Clockcontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid time
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
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
                                labelText: 'Trip Time',
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
                                        _Clockcontroller.text = formattedTime;
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
                          options: ['One Way', 'Two Way'],
                          selectedOption: triptype,
                          onChanged: (String value) {
                            print('Selected option: $value');
                            triptype = value;
                            // You can perform any other actions here based on the selected option
                          },
                        ),
                      ),
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
        print('Time: ${_Clockcontroller.text}');
        print('Type: ${triptype}');
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
          time: _Clockcontroller.text,
          type: triptype);

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      APIServiceTripRequest().postTripRequest(_tripRequest).then((response) {
        // Handle successful request
        print('Trip request sent successfully!!');
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
    final TripTimeIsValid = _Clockcontroller.text.isNotEmpty;
    final DateIsValid =  _Datecontroller.text.isNotEmpty;

    // Perform any additional validation logic if needed

    // Check if all fields are valid
    final allFieldsAreValid = NameIsValid &&
        DesignationIsValid &&
        DepartmentIsValid &&
        PurposeIsValid &&
        PhoneIsValid &&
        DestinationFromIsValid &&
        DestinationToIsValid &&
        TripTimeIsValid &&
        DateIsValid;

    return allFieldsAreValid;
  }
}
