import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
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
  String? vehicleName;
  String? driverNumber;
  String? routeLocation;
  String? selectedDate;
  String? reportType;
  String? dateType; // For route/location condition
  String? selectedLocationType; // 'Stoppage' or 'Location'
  final List<String> reportFields = [];
  final List<String> availableFields = [
    'Name',
    'Vehicle Name',
    'Driver Number',
    'Route/Location',
    'Date',
  ];

  List<Map<String, dynamic>> searchResults = []; // API result placeholder

  void fetchSearchResults() {
    // Call API with search parameters
    setState(() {
      searchResults = [
        {
          'name': 'John Doe',
          'vehicle': 'Car A',
          'driverNumber': '1234',
          'route': 'Route 1',
          'date': '2024-12-01',
        }
      ];
    });
  }

  void downloadReport(String format) {
    debugPrint('Download report in $format');
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
                    'Stoppage',
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
              if(selectedLocationType == 'Location')...[
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
              if(selectedLocationType == 'Stoppage')...[
                LabeledTextWithoutAsterisk(text: 'Stoppage Name'),
                SizedBox(height: 5),
                CustomTextFormField(
                  controller: _routeLocationController,
                  labelText: 'Stoppage Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Stoppage name';
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

              if(selectedLocationType != 'Stoppage')...[
                LabeledTextWithoutAsterisk(text: 'Trip Category'),
                SizedBox(height: 5),
                _buildDropdown(
                  'Type',
                  ['Personal', 'Official'],
                      (value) => reportType = value,
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
                  child: Text(
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
                          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _showFieldsDialog(context, 'PDF'),
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
                          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _showFieldsDialog(context, 'Excel'),
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
