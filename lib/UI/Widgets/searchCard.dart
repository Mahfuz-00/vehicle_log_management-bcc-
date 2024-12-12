import 'package:flutter/material.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> result;

  SearchResultCard(this.result);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow('Name', result['name']),
            _buildResultRow('Phone', result['phone']),
            _buildResultRow('Designation', result['designation']),
            _buildResultRow('Department', result['department']),
            _buildResultRow('Purpose', result['purpose']),
            _buildResultRow('Vehicle', result['vehicle_name']),
            _buildResultRow('Driver', result['driver_name']),
            _buildResultRow('Trip Category', result['trip_category']),
            if(result['trip_category'] != 'Pick-Drop')...[
              _buildResultRow('From', result['destination_from']),
              _buildResultRow('To', result['destination_to']),
              _buildResultRow('Date', result['date']),
              _buildResultRow('Start Time', result['start_time']),
              _buildResultRow('End Time', result['end_time']),
              _buildResultRow('Distance', result['approx_distance']),
              _buildResultRow('Trip Type', result['type']),
              _buildResultRow('Start Trip', result['start_trip']),
              _buildResultRow('Stop Trip', result['stop_trip']),
            ],
            if(result['trip_category'] == 'Pick-Drop') ...[
              _buildResultRow('Stoppage Name', result['stoppage_name']),
              _buildResultRow('Stoppage Distance', result['stoppage_distance']),
              _buildResultRow('Stoppage Fare', result['stoppage_fare']),
              _buildResultRow('Start Month & Year', result['start_month_and_year']),
              _buildResultRow('End Month & Year', result['end_month_and_year']),
              _buildResultRow('Payment Method', result['type']),
            ],
            _buildResultRow('Attachment File', result['attachment_file']),
            _buildResultRow('Status', result['status']),

          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, dynamic? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value.toString() ?? 'N/A',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildResultNumberRow(String label, dynamic? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value.toString() ?? 'N/A',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
