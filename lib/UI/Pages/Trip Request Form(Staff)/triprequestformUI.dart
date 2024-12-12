import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/NonPhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:vehicle_log_management/Data/Data%20Sources/API%20Service%20(Route%20and%20Stoppage)/apiserviceRouteandStoppage.dart';
import 'package:vehicle_log_management/UI/Pages/Trip%20Request%20Form(Staff)/paymentConfirmation.dart';
import 'package:vehicle_log_management/UI/Widgets/labelText.dart';
import 'package:vehicle_log_management/UI/Widgets/labelTextTemplate.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Payment Gateway)/apiServicePaymentGateway.dart';
import '../../../Data/Data Sources/API Service (Trip Request)/apiServiceTripRequest.dart';
import '../../../Data/Models/route.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/auth_email_cubit.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/DateRange.dart';
import '../../Widgets/dropdowns.dart';
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
  late TextEditingController _fareController = TextEditingController();
  late TextEditingController _destinationfromController =
      TextEditingController();
  late TextEditingController _destinationtoController = TextEditingController();
  late TextEditingController _startMonthController = TextEditingController();
  late TextEditingController _startYearController = TextEditingController();
  late TextEditingController _endYearController = TextEditingController();
  late TextEditingController _endMonthController = TextEditingController();
  late TextEditingController _TotalfareController = TextEditingController();
  late String triptype = '';
  late String paymentMethod = '';
  late String tripCatagory = '';
  late TripRequest _tripRequest;
  late DateTime? Date;
  File? _file;
  File? _challanfile;
  bool _isbuttonclicked = false;
  String? startMonthYear;
  String? startMonth;
  int? startYear;
  String? endMonthYear;
  String? endMonth;
  int? endYear;
  double totalFare = 0;

  List<Routes>? routes = [];
  List<Stoppages>? stoppages = [];
  String? selectedRoute;
  String? selectedStoppage;
  bool isLoadingRoute = false;
  bool isLoadingStoppage = false;
  late String _routeID = '';
  late String _stoppageID = '';
  late String _tripRequestID = '';

  // Define a list of month names in order
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  int? startMonthNumber;
  int? endMonthNumber;
  String? startMonthFormatted;
  String? endMonthFormatted;

// Use it in your code
  void convertMonths(String startM, String endM) {
    startMonthNumber = monthNames.indexOf(startMonth!) + 1;
    endMonthNumber = monthNames.indexOf(endMonth!) + 1;

    startMonthFormatted = startMonthNumber.toString().padLeft(2, '0');
    endMonthFormatted = endMonthNumber.toString().padLeft(2, '0');

    if (startMonthNumber == 0 || endMonthNumber == 0) {
      print('Invalid month name provided');
    } else {
      print('Start Month: $startMonthNumber, End Month: $endMonthNumber');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late RouteAndStoppageAPIService apiService;

  Future<RouteAndStoppageAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await RouteAndStoppageAPIService.create(token);
    return apiService;
  }

  Future<void> fetchRoute() async {
    setState(() {
      isLoadingRoute = true;
      selectedRoute = null;
      selectedStoppage = null;
      routes = null;
      stoppages = null;
      routes = [];
      _routeID = '';
      _stoppageID = '';
    });
    try {
      await initializeApiService();
      final List<Routes> fetchedRoutes = await apiService.fetchRoutes();
      setState(() {
        routes = fetchedRoutes;
        for (Routes routes in fetchedRoutes) {
          print('Route Start Point: ${routes.startpoint}');
          print('Route End Point: ${routes.endpoint}');
          print('Route ID: ${routes.id}');
        }
        isLoadingRoute = false;
        selectedRoute = null;
        selectedStoppage = null;
        stoppages = null;
        _routeID = '';
        _stoppageID = '';
      });
    } catch (e) {
      print('Error fetching routes: $e');
    }
  }

  Future<void> fetchStoppages(String routeId) async {
    print(routeId);
    setState(() {
      isLoadingStoppage = true;
      selectedStoppage = null;
      stoppages = null;
      _stoppageID = '';
    });
    try {
      final List<Stoppages> fetchedStoppages =
          await apiService.fetchStoppages(routeId);
      setState(() {
        stoppages = fetchedStoppages;
        for (Stoppages stoppages in fetchedStoppages) {
          print('Stoppage Name: ${stoppages.name}');
          print('Stoppage ID: ${stoppages.id}');
        }
        print(stoppages);
        isLoadingStoppage = false;
        selectedStoppage = null;
        _stoppageID = '';
      });
    } catch (e) {
      print('Error fetching Stoppages: $e');
    }
  }

  int calculatePayment({
    required int startMonth,
    required int startYear,
    required int endMonth,
    required int endYear,
    required int fareForEachDay,
  }) {
    // Calculate the total number of months between the start and end date
    int totalMonths = ((endYear - startYear) * 12) + (endMonth - startMonth + 1);

    // Calculate the total fare for the period
    int totalFare = totalMonths * fareForEachDay * 2;
    _TotalfareController.text = totalFare.toString();
    print(totalFare.toString());

    return totalFare;
  }

  void _recalculateFare() {
    // Parse values from text controllers
    int startMonth = int.tryParse(_startMonthController.text) ?? 0;
    int startYear = int.tryParse(_startYearController.text) ?? 0;
    int endMonth = int.tryParse(_endMonthController.text) ?? 0;
    int endYear = int.tryParse(_endYearController.text) ?? 0;
    int fareForEachDay = int.tryParse(_fareController.text) ?? 0;

    // Recalculate and update the total fare
    calculatePayment(
      startMonth: startMonth,
      startYear: startYear,
      endMonth: endMonth,
      endYear: endYear,
      fareForEachDay: fareForEachDay,
    );
  }


  @override
  void initState() {
    super.initState();
    // Add listeners to recalculate fare when any input changes
    _fareController.addListener(_recalculateFare);
    _startMonthController.addListener(_recalculateFare);
    _startYearController.addListener(_recalculateFare);
    _endMonthController.addListener(_recalculateFare);
    _endYearController.addListener(_recalculateFare);
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Trip Request Form',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'default',
                          )),
                    ),
                    SizedBox(height: 20),
                    LabeledTextWithAsterisk(text: 'Trip Type'),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: RadioListTileGroup(
                        options: ['Personal', 'Official', 'Pick-Drop'],
                        selectedOption: tripCatagory,
                        onChanged: (String value) {
                          print('Selected option: $value');
                          tripCatagory = value;
                          setState(() {
                            tripCatagory = value;
                            if (tripCatagory == 'Pick-Drop') {
                              fetchRoute();
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabeledTextWithAsterisk(text: 'Full Name'),
                          SizedBox(height: 5),
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
                          LabeledTextWithAsterisk(text: 'Designation'),
                          SizedBox(height: 5),
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
                          LabeledTextWithAsterisk(text: 'Department'),
                          SizedBox(height: 5),
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
                          LabeledTextWithAsterisk(text: 'Mobile Number'),
                          SizedBox(height: 5),
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
                        ],
                      ),
                    ),
                    if (tripCatagory != 'Pick-Drop') ...[
                      LabeledTextWithAsterisk(
                          text: 'Trip Purpose and Trip Details'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Pick up'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Destination'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Start Time'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Stop Time'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Date'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(
                          text: 'Approx. Distance of the Trip (in KM)'),
                      SizedBox(height: 5),
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
                      LabeledTextWithAsterisk(text: 'Trip Mode'),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: RadioListTileGroup(
                          options: ['One-Way', 'Round-Trip'],
                          selectedOption: triptype,
                          onChanged: (String value) {
                            print('Selected option: $value');
                            triptype = value;
                          },
                        ),
                      ),
                    ],
                    if (tripCatagory == 'Official') ...[
                      SizedBox(
                        height: 15,
                      ),
                      LabeledTextWithoutAsterisk(text: 'Pick a Attachment'),
                      SizedBox(
                        height: 5,
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
                    if (tripCatagory == 'Pick-Drop') ...[
                      LabeledTextWithAsterisk(text: 'Route'),
                      SizedBox(height: 5),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.075,
                            padding: EdgeInsets.only(left: 10, top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                DropdownFormField(
                                  hintText: 'Select Route',
                                  dropdownItems: routes != null
                                      ? routes!
                                          .map((route) =>
                                              (route.startpoint ?? 'N/A') +
                                              ' - ' +
                                              (route.endpoint ?? 'N/A'))
                                          .toList()
                                      : null,
                                  initialValue: selectedRoute,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedStoppage = null;
                                      stoppages = null;
                                      _routeID = '';
                                      _stoppageID = '';
                                      selectedRoute = newValue;
                                    });
                                    if (newValue != null) {
                                      // Find the selected Route object
                                      Routes selectedRouteObject =
                                          routes!.firstWhere(
                                        (routes) =>
                                            (routes.startpoint ?? 'N/A') +
                                                ' - ' +
                                                (routes.endpoint ?? 'N/A') ==
                                            newValue,
                                      );
                                      if (selectedRouteObject != null) {
                                        _routeID =
                                            selectedRouteObject.id.toString();
                                        print(_routeID);
                                        fetchStoppages(
                                            selectedRouteObject.id.toString());
                                      }
                                    }
                                  },
                                ),
                                if (isLoadingRoute)
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color:
                                          const Color.fromRGBO(25, 192, 122, 1),
                                    ),
                                  ),
                              ],
                            )),
                      ),
                      const SizedBox(height: 10),
                      LabeledTextWithAsterisk(text: 'Stoppage'),
                      SizedBox(height: 5),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.075,
                            padding: EdgeInsets.only(left: 10, top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                DropdownFormField(
                                  hintText: 'Select Stoppage',
                                  dropdownItems: stoppages != null
                                      ? stoppages!
                                          .map((Stoppages) => Stoppages.name)
                                          .toList()
                                      : null,
                                  initialValue: selectedStoppage,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _stoppageID = '';
                                      selectedStoppage = newValue;
                                      print(selectedStoppage);
                                    });
                                    if (newValue != null) {
                                      // Find the selected Route object
                                      Stoppages selectedStoppageObject =
                                          stoppages!.firstWhere(
                                        (Stoppages) =>
                                            Stoppages.name == newValue,
                                      );
                                      if (selectedStoppageObject != null) {
                                        _stoppageID = selectedStoppageObject.id
                                            .toString();
                                        print(_stoppageID);
                                        _fareController.text =
                                            selectedStoppageObject.fare
                                                .toString();
                                        print(_fareController.text);
                                      }
                                    }
                                  },
                                ),
                                if (isLoadingStoppage)
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color:
                                          const Color.fromRGBO(25, 192, 122, 1),
                                    ),
                                  ),
                              ],
                            )),
                      ),
                      const SizedBox(height: 10),
                      LabeledTextWithAsterisk(text: 'Select Date'),
                      SizedBox(height: 5),
                      DateRangeWithFareWidget(
                        farePerDay: 5.0,
                        onDateChange: (String? startM, int? startY,
                            String? endM, int? endY, double fare) {
                          setState(() {
                            startMonth = startM;
                            //_startMonthController.text = startMonth!;
                            startYear = startY;
                            //_startYearController.text = startYear.toString()!;
                            endMonth = endM;
                            //_endMonthController.text = endMonth!;
                            endYear = endY;
                            //_endYearController.text = endYear.toString()!;
                            totalFare = fare;
                            convertMonths(startMonth!, endMonth!);
                            startMonthYear = '$startYear-$startMonthFormatted-01';
                            endMonthYear = '$endYear-$endMonthFormatted-01';
                            _fareController.text = '${totalFare.toString()} TK';
                            print(
                                'Start Month: $startMonth, Start Year: $startYear, Start Month Year: $startMonthYear End Month: $endMonth, End Year: $endYear, End Month Year: $endMonthYear, Total Fare: $totalFare');
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      LabeledTextWithAsterisk(text: 'Fare'),
                      SizedBox(height: 5),
                      CustomTextFormField(
                        controller: _fareController,
                        labelText: 'Total Fare',
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter your designation';
                          }
                          return null;
                        },
                        prefixText: 'TK ',
                      ),
                      const SizedBox(height: 10),
                      LabeledTextWithAsterisk(text: 'Payment Mode'),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: RadioListTileGroup(
                          options: ['Online', 'Offline'],
                          selectedOption: paymentMethod,
                          onChanged: (String value) {
                            setState(() {
                              print(
                                  'Selected Payment option: $value and Trip Category: $tripCatagory');
                              paymentMethod = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (/*tripCatagory == 'Pick-Drop' &&*/ paymentMethod ==
                          'Offline') ...[
                        LabeledTextWithAsterisk(
                            text: 'Upload Necessary Document'),
                        SizedBox(
                          height: 5,
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
                                  onPressed: _pickChallanFile,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_challanfile == null) ...[
                                        Icon(
                                          Icons.document_scanner,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Upload File',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                      ],
                                      if (_challanfile != null) ...[
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
                        onPressed: tripCatagory != ''
                            ? () {
                                _tripRequestForm();
                              }
                            : null,
                        child: _isbuttonclicked
                            ? CircularProgressIndicator()
                            : Text('Submit',
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

  Future<void> _pickChallanFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _challanfile = File(result.files.single.path!);
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
    setState(() {
      _isbuttonclicked = true;
    });
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
      print('Route ID: ${_routeID}');
      print('Stoppage ID: ${_stoppageID}');
      print('Start Month: ${startMonthYear}');
      print('End Month: ${endMonthYear}');
      print('Payment Method: ${paymentMethod}');
      print('File: ${_file?.path}');
      print('Challan File: ${_challanfile?.path}');

      var tripCatagoryFinal;

      File? file;
      if (tripCatagory != 'Pick-Drop') {
        file = _file;
        tripCatagoryFinal = tripCatagory;
      } else if (tripCatagory == 'Pick-Drop') {
        file = _challanfile;
        _purposeController.text = 'Pick-Drop';
        tripCatagoryFinal = 'Pick Drop';
        triptype = paymentMethod;
      }

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
          category: tripCatagoryFinal,
          route: _routeID,
          stoppage: _stoppageID,
          startMonth: startMonthYear,
          endMonth: endMonthYear,
          paymentMode: paymentMethod);

      print(_tripRequest.startMonth);
      print(_tripRequest.endMonth);

      TripRequestAPIService()
          .postTripRequest(_tripRequest, file)
          .then((response) {
        setState(() {
          _isbuttonclicked = false;
        });
        print('Trip request sent successfully!!');
        print(response);
        if (response != null && response.startsWith("Trip request successfully")) {
          String message = response.split('(')[0].trim(); // Extracts the message part before 'Trip ID'
          String tripId = response.split('Trip ID: ')[1].replaceAll(')', '').trim(); // Extracts the trip_id

          print('Response message: $message');
          print('Trip ID: $tripId');
          _tripRequestID = tripId;
          if (tripCatagory != 'Pick-Drop') {
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
          }
          if (tripCatagory == 'Pick-Drop') {
            if (triptype == 'Online') {
              final email =
                  (context.read<AuthEmailCubit>().state as AuthEmailSaved)
                      .email;
              print('Retrieved email from Cubit: $email');
              startPayment(context, _nameController.text, email,
                  _phoneController.text, ', Dhaka');
            } else if (triptype == 'Offline') {
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
            }
          }
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
      setState(() {
        _isbuttonclicked = false;
      });
      const snackBar = SnackBar(
        content: Text('Please fill all required fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  bool _validateAndSave() {
    if (_formKey.currentState!.validate()) {
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
      final PaymentMethodIsValid = paymentMethod.isNotEmpty;
      final StartMonthIsValid = startMonthYear?.isNotEmpty;
      final EndMonthIsValid = endMonthYear?.isNotEmpty;
      final ChallanFileIsValid = _challanfile != null;
      final FileIsValid = _file != null;
      final RouteIsValid = _routeID.isNotEmpty;
      final StoppageIsValid = _stoppageID.isNotEmpty;

  /*    if(!FileIsValid && tripCatagory == 'Official'){
        const snackBar = SnackBar(
          content: Text('Please upload a file'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }*/

      if(!ChallanFileIsValid && tripCatagory == 'Pick-Drop' && paymentMethod == 'Offline'){
        const snackBar = SnackBar(
          content: Text('Please upload a Challan file/Bank Slip'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }

      if (tripCatagory == 'Pick-Drop') {
        final allFieldsAreValid = NameIsValid &&
            DesignationIsValid &&
            DepartmentIsValid &&
            PhoneIsValid &&
            RouteIsValid &&
            StoppageIsValid &&
            StartMonthIsValid! &&
            EndMonthIsValid! &&
            PaymentMethodIsValid;
        return allFieldsAreValid;
      } else {
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
    } else {
      return false;
    }
  }

  static const String storeId = "registrationbditecgovbdlive";
  static const String storePassword = "65A78606493BB44737";

/*  static const String storeId = "mrtou66baeda11df08";
  static const String storePassword = "mrtou66baeda11df08@ssl";*/
  static const String apiUrl =
      "https://sandbox.sslcommerz.com/gwprocess/v3/api.php";
  static const String requestedUrl =
      "https://sandbox.sslcommerz.com/validator/api/validationserverAPI.php?val_id=\$val_id&store_id=\$store_id&store_passwd=\$store_passwd&v=1&format=json";

  void startPayment(BuildContext context, String Name, String Email,
      String Mobile, String Address) async {
    print('Trip ID $_tripRequestID');
    String tranId = generateTransactionId();

    Sslcommerz sslcommerz = await Sslcommerz(
      initializer: SSLCommerzInitialization(
        ipn_url: "",
        multi_card_name: "visa,master,bkash,nagad,rocket",
        currency: SSLCurrencyType.BDT,
        product_category: "Exam Registration Fee",
        sdkType: SSLCSdkType.LIVE,
        store_id: storeId,
        store_passwd: storePassword,
        total_amount: totalFare,
        tran_id: tranId,
      ),
    )
      ..addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
          customerState: "Unknown",
          customerName: Name,
          customerEmail: Email,
          customerAddress1: Address,
          customerAddress2: "N/A",
          customerCity: "Unknown",
          customerPostCode: "Unknown",
          customerCountry: "Bangladesh",
          customerPhone: Mobile,
          customerFax: 'N/A',
        ),
      )
      ..addProductInitializer(
        sslcProductInitializer: SSLCProductInitializer(
          productName: "ICT Division Pick-Drop Fare Payment",
          productCategory: "Fare",
          general: General(
            productProfile: "ICT Division Pick-Drop Fare Payment",
            general: "Fare",
          ),
        ),
      )
      ..addProductInitializer(
          sslcProductInitializer:
              SSLCProductInitializer.WithNonPhysicalGoodsProfile(
                  productName: "ICT Division Pick-Drop Fare Payment",
                  productCategory: "Fare",
                  nonPhysicalGoods: NonPhysicalGoods(
                    productProfile: "ICT Division Pick-Drop Fare Payment",
                    nonPhysicalGoods: "Fare",
                  )))
      ..addAdditionalInitializer(
        sslcAdditionalInitializer: SSLCAdditionalInitializer(
          valueA: "N/A",
          valueB: "N/A",
          valueC: "N/A",
          valueD: "N/A",
          campaign_code: 'N/A',
          invoice_id: 'N/A',
          bill_number: 'N/A',
          no_offer: 0,
          user_refer: 'N/A',
          extras: {
            'extraInfo': 'N/A',
          },
        ),
      );

    try {
      var result = await sslcommerz.payNow();
      print("result :: ${jsonEncode(result)}");
      print("result status :: ${result.status ?? ""}");
      print(
          "Transaction is ${result.status} and Amount is ${result.amount ?? 0}");

      var jsonData = result.toJson();
      String transactionId = jsonData['tran_id'] ?? 'N/A';
      String transactionDate = jsonData['tran_date'] ?? 'N/A';
      String transactionType = jsonData['card_type'] ?? 'N/A';

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is Failed....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK Closed by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        await submitTransaction(_tripRequestID, transactionId, transactionDate,
                transactionType, totalFare)
            .then((_) {
          Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount ?? 0}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PaymentConfirmationUI()),
              (route) => false);
        });

        if (result.status!.toLowerCase() == "valid") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Payment successful!'),
          ));
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment error: $e'),
      ));
    }
  }

  String generateTransactionId() {
    const String chars = '0123456789';
    final Random random = Random();
    String randomId = '';

    for (int i = 0; i < 10; i++) {
      randomId += chars[random.nextInt(chars.length)];
    }

    String date = DateFormat('yyMMdd').format(DateTime.now());
    String transactionId = 'ICTVLM$date$randomId';

    print(transactionId);
    return transactionId;
  }

  bool _isSubmit = false;
  bool _isLoading = false;

  Future<void> submitTransaction(String TripID, String TransID,
      String TransDate, String TransType, double Amount) async {
    _isSubmit = false;
    if (_isSubmit) return;
    try {
      final apiService = await SubmitTransactionAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.submitTransaction(
              tripId: _tripRequestID,
              transactionId: TransID,
              transactionDate: TransDate,
              transactionType: TransType,
              transactionAmount: Amount);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final String message = dashboardData['message'];
      if (message == 'Transaction data save successfully') {
        print('Transaction data save successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction Completed'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      } else if (message == 'Transaction data save error') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction is not Completed'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (message == 'Trip is not found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip is not found'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {
        _isSubmit = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isSubmit = true;
    }
  }
}
