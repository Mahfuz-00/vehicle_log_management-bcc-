import 'package:flutter/material.dart';

class DateRangeWithFareWidget extends StatefulWidget {
  final double farePerMonth;
  final Function(String? startMonth, int? startYear, String? endMonth,
      int? endYear, double totalFare) onDateChange;

  const DateRangeWithFareWidget({
    Key? key,
    required this.farePerMonth,
    required this.onDateChange,
  }) : super(key: key);

  @override
  _DateRangeWithFareWidgetState createState() =>
      _DateRangeWithFareWidgetState();
}

class _DateRangeWithFareWidgetState extends State<DateRangeWithFareWidget> {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  final List<int> years = List.generate(27, (index) => 2024 + index);

  String? startMonth;
  int? startYear;
  String? endMonth;
  int? endYear;
  double totalFare = 0;

  void calculateFare() {
    if (startMonth != null &&
        startYear != null &&
        endMonth != null &&
        endYear != null) {
      int startIndex = months.indexOf(startMonth!);
      int endIndex = months.indexOf(endMonth!);
      int yearDiff = endYear! - startYear!;
      int totalMonths = (yearDiff * 12) + (endIndex - startIndex + 1);

      setState(() {
        totalFare = totalMonths * widget.farePerMonth;
      });

      // Pass data to parent widget
      widget.onDateChange(startMonth, startYear, endMonth, endYear, totalFare);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                )),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the Row contents
              children: [
                // Month Dropdown
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
             /*         isExpanded: true,*/
                      decoration: InputDecoration(
                        hintText: 'Month',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      value: startMonth,
                      items: months
                          .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          month,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          startMonth = value;
                        });
                        calculateFare();
                      },
                    )
                  ),
                ),
                SizedBox(width: 6), // Space between Month and Year dropdown
                // Year Dropdown
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: DropdownButtonFormField<int>(
                     /* isExpanded: true,*/
                      decoration: InputDecoration(
                        hintText: 'Year',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      value: startYear,
                      items: years
                          .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          startYear = value;
                        });
                        calculateFare();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),

        SizedBox(height: 10),

        // End Date Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('End Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                )),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the Row contents
              children: [
                // End Month Dropdown
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Month',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      value: endMonth,
                      items: months
                          .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          month,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          endMonth = value;
                        });
                        calculateFare();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 6), // Space between Month and Year dropdown
                // End Year Dropdown
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        hintText: 'Year',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: OutlineInputBorder(),
                      ),
                      value: endYear,
                      items: years
                          .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          endYear = value;
                        });
                        calculateFare();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}



