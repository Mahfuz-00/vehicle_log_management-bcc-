import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Trip Request)/apiServiceTripRequest.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/radiooption.dart';
import '../Staff Dashboard/staffdashboardUI.dart';

/// [TripRequestFormUI] is a StatefulWidget that represents the user interface for submitting a new trip request.
///
/// It provides input fields for trip details such as [Full Name], [Designation], [Department],
/// [Purpose], [Mobile Number], [Destination From], [Destination To], [Start Time],
/// [End Time], [Trip Date], and [Approx. Distance of the Trip].
///
/// This widget also allows users to select the trip type and mode using radio buttons,
/// and it includes a file picker for official trip requests.
///
/// The state of the widget is managed using a private state class [_TripRequestFormUIState].
///
/// Variables:
/// - [_StartTimecontroller]: Controller for the start time input field.
/// - [_EndTimecontroller]: Controller for the end time input field.
/// - [_Datecontroller]: Controller for the date input field.
/// - [_nameController]: Controller for the full name input field.
/// - [_desinationController]: Controller for the designation input field.
/// - [_distanceController]: Controller for the distance input field.
/// - [_departmentController]: Controller for the department input field.
/// - [_purposeController]: Controller for the purpose input field.
/// - [_phoneController]: Controller for the mobile number input field.
/// - [_destinationfromController]: Controller for the starting destination input field.
/// - [_destinationtoController]: Controller for the destination input field.
/// - [triptype]: Stores the selected trip mode (e.g., One-Way, Round-Trip).
/// - [tripCatagory]: Stores the selected trip type (e.g., Personal, Official).
/// - [_tripRequest]: Instance of [TripRequest] model used to hold trip details.
/// - [Date]: Stores the selected trip date.
/// - [_file]: Holds the selected file for official trip requests.
/// - [_scaffoldKey]: Global key for the scaffold to manage state and display snack bars.
class TripRequestFormUI extends StatefulWidget {
  const TripRequestFormUI({super.key});

  @override
  State<TripRequestFormUI> createState() => _TripRequestFormUIState();
}

class _TripRequestFormUIState extends State<TripRequestFormUI> {
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

    return InternetConnectionChecker(
      child: Scaffold(
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
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _desinationController,
                        labelText: 'Designation',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter your designation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _departmentController,
                        labelText: 'Department',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter the department you are affiliated with';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _purposeController,
                        labelText: 'Purpose and Trip details',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter the purpose of your trip and trip details';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _phoneController,
                        labelText: 'Mobile Number',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (input.length != 11) {
                            return 'Mobile number must be 11 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _destinationfromController,
                        labelText: 'Destination From',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter where the trip will start';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _destinationtoController,
                        labelText: 'Destination To',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter the destination of the trip';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _StartTimecontroller,
                        labelText: 'Start Trip Time',
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the start time';
                          }
                          return null;
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedTime) {
                            if (selectedTime != null) {
                              String formattedTime =
                                  DateFormat('h:mm a').format(
                                DateTime(
                                  2020,
                                  1,
                                  1,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                ),
                              );
                              _StartTimecontroller.text = formattedTime;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _EndTimecontroller,
                        labelText: 'Stop Trip Time',
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the end time';
                          }
                          return null;
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectedTime) {
                            if (selectedTime != null) {
                              String formattedTime =
                                  DateFormat('h:mm a').format(
                                DateTime(
                                  2020,
                                  1,
                                  1,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                ),
                              );
                              _EndTimecontroller.text = formattedTime;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _Datecontroller,
                        labelText: 'Trip Date',
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              _Datecontroller.text = formattedDate;
                            }
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _distanceController,
                        labelText: 'Approx. Distance of the Trip (in KM)',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter approximate distance(in KM)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                        SizedBox(
                          height: 15,
                        ),
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
        const snackBar = SnackBar(
          content: Text('File is not available'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void _tripRequestForm() {
    if (_validateAndSave()) {
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('triggered Validation');

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

      TripRequestAPIService()
          .postTripRequest(_tripRequest, _file)
          .then((response) {
        print('Trip request sent successfully!!');
        print(response);
        if (response != null && response == "Trip request successfully") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => StaffDashboardUI(
                      shouldRefresh: true,
                    )),
            (route) => false,
          );
          const snackBar = SnackBar(
            content: Text('Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            content: Text('$response'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        const snackBar = SnackBar(
          content: Text('Error while submitting request'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Error sending Trip request: $error');
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Please fill all required fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  bool _validateAndSave() {
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
