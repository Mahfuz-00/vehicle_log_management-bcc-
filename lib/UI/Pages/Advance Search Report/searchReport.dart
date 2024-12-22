import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Data/Data Sources/API Service (Advance Search)/apiserviceAdvanceSearch.dart';
import '../../../Data/Data Sources/API Service (Download Report)/apiserviceDownloadReport.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/labelTextTemplate.dart';
import '../../Widgets/searchCard.dart';

class AdvancedSearchUI extends StatefulWidget {
  @override
  _AdvancedSearchUIState createState() => _AdvancedSearchUIState();
}

class _AdvancedSearchUIState extends State<AdvancedSearchUI> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _driverController = TextEditingController();
  final _routeLocationController = TextEditingController();
  final _dateController = TextEditingController();
  final _reportTypeController = TextEditingController();
  String? name;
  bool isLoading = false;
  String? vehicleName;
  String? driverNumber;
  String? routeLocation;
  String? selectedDate;
  String? TripType = '';
  String? dateType = ''; // For route/location condition
  String? selectedLocationType = ''; // 'Stoppage' or 'Location'
  final List<String> reportFields = [];
  final List<String> availableFields = [
    'Name',
    'Vehicle Name',
    'Driver Number',
    'Route/Location',
    'Date',
  ];

  List<Map<String, dynamic>> searchResults = []; // API result placeholder

  void fetchSearchResults() async {
    setState(() {
      isLoading = true; // Set loading state to true while fetching data
    });

    try {
      print('Name : ${_nameController.text}');
      print('Vehicle Name : ${_vehicleController.text}');
      print('Driver Number : ${_driverController.text}');
      print('Route/Location : ${_routeLocationController.text}');
      print('Date : ${_dateController.text}');
      print('Trip Type : ${TripType}');
      print('Pickup/Drop Point : ${selectedLocationType}');
      print('Date Type : ${dateType}');
      // Initialize the SearchService inside the function
      final searchService = await AdvanceSearchAPIService
          .create(); // Create an instance of SearchService

      // Call the API to fetch search results with dynamic data
      final results = await searchService.searchAPI(
        name: _nameController.text,
        // Replace with actual data (e.g., from text controllers)
        vehicleName: _vehicleController.text,
        driverName: _driverController.text,
        locationName: _routeLocationController.text,
        locationDate: _dateController.text,
        locationType: TripType,
        stoppageName: selectedLocationType,
        date: _dateController.text,
      );

      setState(() {
        searchResults =
            results; // Update the search results with the API response
        isLoading = false; // Set loading state to false after fetching data
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading state to false if there's an error
      });
      print('Error: $e');
    }
  }

  Future<void> downloadReport(String format) async {
    const snackBar = SnackBar(
      content: Text('Sending Request, Please wait'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    print('Print Triggered!!');
    try {
      // Initialize the SearchService inside the function
      final searchService = await ReportDownloadAPIService
          .create(); // Create an instance of SearchService

      String LocationName = '';
      String StoppageName = '';

      if (selectedLocationType == 'Stoppage') {
        StoppageName = _routeLocationController.text;
      } else if (selectedLocationType == 'Location') {
        LocationName = _routeLocationController.text;
      } else {}
      // Call the API to fetch search results with dynamic data
      final dashboardData = await searchService.DownloadReport(
        name: _nameController.text,
        vehicleName: _vehicleController.text,
        driverName: _driverController.text,
        locationName: LocationName,
        locationDate: _dateController.text,
        locationType: TripType,
        stoppageName: StoppageName,
        printType: format,
        stoppagedate: _dateController.text,
        routeType: selectedLocationType,
      );

      print('Print Triggered!!');
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      /*    final Map<String, dynamic>? records = dashboardData['data'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }*/

      String link = dashboardData['download_url'];
      if (format == 'PDF') {
        const snackBar = SnackBar(
          content: Text('Printing PDF. Please wait...'),
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        print('Print Triggered!!');
        print('PDF generated successfully. Download URL: ${link}');
        try {
          print('PDF generated successfully. Download URL: ${link}');
          final Uri url = Uri.parse(link);
          var data = await http.get(url);
          await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => data.bodyBytes);
        } catch (e) {
          const snackBar = SnackBar(
            content: Text('Download Failed. Please try again'),
          );
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
          print('Error generating PDF: $e');
        }
      }

      if (format == 'Excel') {
        const snackBar = SnackBar(
          content: Text('Downloading Excel File. Please wait...'),
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        print('Excel download URL: $link');
        try {
          // Request storage permission
          if (await Permission.storage.request().isGranted) {
            // Download the file
            final Uri url = Uri.parse(link);
            var response = await http.get(url);
            /*    final snackBar = SnackBar(
              content: Text('Response: $response'),
            );
            ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);*/
            if (response.statusCode == 200) {
              // Get the Downloads directory
              final directory = Directory('/storage/emulated/0/Download');
              if (!await directory.exists()) {
                await directory.create(recursive: true);
              }

              // Save the file
              final filePath =
                  '${directory.path}/ict_division_vehicle_report_file.xlsx';
              final file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);
              print('Excel downloaded successfully: $filePath');

              final snackBar = SnackBar(
                content: Text('File downloaded in $filePath'),
              );
              ScaffoldMessenger.of(context as BuildContext)
                  .showSnackBar(snackBar);

              // Open the file
              await OpenFile.open(filePath);
            } else {
              print(
                  'Failed to download file. Status code: ${response.statusCode}');
              /*   final snackBar = SnackBar(
                content: Text('Failed to download file. Status code: ${response.statusCode}'),
              );
              ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);*/
            }
          } else {
            requestStoragePermission();
            final snackBar = SnackBar(
              content: Text('Storage permission denied.'),
            );
            ScaffoldMessenger.of(context as BuildContext)
                .showSnackBar(snackBar);
            print('Storage permission denied.');
          }
        } catch (e) {
          final snackBar = SnackBar(
            content: Text('Download Failed.'),
          );
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
          print('Error downloading or opening Excel file: $e');
        }
      }

      /*  final Map<String, dynamic>? records = dashboardData['data'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }*/
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> requestStoragePermission() async {
    // Check current permission status
    var status = await Permission.storage.status;
    print("Storage permission status: $status");

    if (status.isDenied || status.isRestricted || status.isLimited) {
      // Explicitly request the permission
      status = await Permission.storage.request();
    }

    // Check the result after the request
    if (status.isGranted) {
      print("Storage permission granted.");
      return true;
    } else if (status.isPermanentlyDenied) {
      final snackBar = SnackBar(
        content: Text('Download Failed.'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      // If permission is permanently denied, open app settings
      print("Storage permission permanently denied.");
      await openAppSettings();
    } else {
      print("Storage permission denied.");
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Advanced Search & Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Filters',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              LabeledTextWithoutAsterisk(text: 'Staff Name'),
              SizedBox(height: 5),
              CustomTextFormField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              LabeledTextWithoutAsterisk(text: 'Vehicle Name'),
              SizedBox(height: 5),
              CustomTextFormField(
                controller: _vehicleController,
                labelText: 'Vehicle Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              LabeledTextWithoutAsterisk(text: 'Driver Name'),
              SizedBox(height: 5),
              CustomTextFormField(
                controller: _driverController,
                labelText: 'Driver Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a driver name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              // Radio buttons for Stoppage/Location selection
              Text(
                'Select Route/Location:',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Stoppage',
                    groupValue: selectedLocationType,
                    onChanged: (value) {
                      setState(() {
                        selectedLocationType = value;
                        dateType =
                            'Month-Year'; // For Stoppage, select Month-Year
                      });
                    },
                  ),
                  Text(
                    'Pickup/Drop Point',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                  Radio<String>(
                    value: 'Location',
                    groupValue: selectedLocationType,
                    onChanged: (value) {
                      setState(() {
                        selectedLocationType = value;
                        dateType = 'Date'; // For Location, select full Date
                      });
                    },
                  ),
                  Text(
                    'Location',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (selectedLocationType == 'Location') ...[
                LabeledTextWithoutAsterisk(text: 'Location Name'),
                SizedBox(height: 5),
                CustomTextFormField(
                  controller: _routeLocationController,
                  labelText: 'Location Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
              ],
              if (selectedLocationType == 'Stoppage') ...[
                LabeledTextWithoutAsterisk(text: 'Pickup/Drop Point'),
                SizedBox(height: 5),
                CustomTextFormField(
                  controller: _routeLocationController,
                  labelText: 'Pickup/Drop Point',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Pickup/Drop Point';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
              ],
              SizedBox(
                height: 10,
              ),
              // Dynamic Date Picker
              selectedLocationType == 'Stoppage'
                  ? _buildDropdownDate('Month-Year', (value) {
                      _dateController.text = value!;
                    })
                  : _buildDateField('Date', (value) {
                      _dateController.text = value!;
                    }),

              if (selectedLocationType != 'Stoppage') ...[
                LabeledTextWithoutAsterisk(text: 'Trip Category'),
                SizedBox(height: 5),
                _buildDropdown(
                  'Type',
                  ['Personal', 'Official'],
                  (value) => TripType = value,
                ),
              ],

              SizedBox(height: 20),

              // Search Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                        MediaQuery.of(context).size.height * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: fetchSearchResults,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'default',
                          ),
                        ),
                ),
              ),

              SizedBox(height: 30),

              // Search Results
              if (searchResults.isNotEmpty) ...[
                Text(
                  'Search Results',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
                Divider(),
                ...searchResults.map((result) => SearchResultCard(result)),
                // Call the SearchResultCard widget
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => downloadReport('PDF'),
                        child: Text(
                          'Download PDF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => downloadReport('Excel'),
                        child: Text(
                          'Download Excel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ] else ...[
                Text(
                  'Search Results',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'No Data Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'default',
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'default',
          ),
          border: OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'default',
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField(String label, Function(String?) onSaved) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextWithoutAsterisk(text: 'Select a date'),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'default',
              ),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2050),
                  );
                  if (pickedDate != null) {
                    onSaved(DateFormat('yyyy-MM-dd').format(pickedDate));
                  }
                },
              ),
            ),
            controller: _dateController,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownDate(String label, Function(String?) onSaved) {
    // Generate list of months
    List<String> months = List.generate(
        12, (index) => DateFormat('MMMM').format(DateTime(2024, index + 1)));

    // Generate list of years (for example, 10 years from 2014 to 2024)
    List<String> years =
        List.generate(27, (index) => (2024 + index).toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextWithoutAsterisk(text: 'Select a month'),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Month Dropdown
            Expanded(
              child: _buildDropdown(
                'Select Month',
                months,
                (value) {
                  // Combine month with selected year for the final value
                  String finalDate =
                      '${value ?? ''} ${years[0]}'; // Using first year for now, adjust logic for real use
                  onSaved(finalDate);
                },
              ),
            ),
            SizedBox(width: 10), // Space between the dropdowns
            // Year Dropdown
            Expanded(
              child: _buildDropdown(
                'Select Year',
                years,
                (value) {
                  // Combine year with selected month for the final value
                  onSaved(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFieldsDialog(BuildContext context, String downloadtype) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Fields to Include in Report',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'default',
            ),
          ),
          content: Container(
            height: screenHeight * 0.4,
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: availableFields.map((field) {
                  return CheckboxListTile(
                    title: Text(
                      field,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                    checkColor: Colors.white,
                    activeColor: Color.fromRGBO(25, 192, 122, 1),
                    value: reportFields.contains(field),
                    onChanged: (isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          reportFields.add(field);
                        } else {
                          reportFields.remove(field);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(25, 192, 122, 1)),
                fixedSize: MaterialStateProperty.all(Size(100, 30)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Set the corner radius
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(25, 192, 122, 1)),
                fixedSize: MaterialStateProperty.all(Size(100, 30)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Set the corner radius
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Handle the download logic after selecting fields
                if (downloadtype == 'PDF') {
                  downloadReport('PDF');
                } else if (downloadtype == 'Excel') {
                  downloadReport('Excel');
                }
              },
              child: Text(
                'Download',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
