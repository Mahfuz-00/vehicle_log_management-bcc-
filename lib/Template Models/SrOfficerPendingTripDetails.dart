import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_log_management/API%20Model%20and%20Service%20(Dashboard)/tripRequestModelSROfficer.dart';
import 'package:vehicle_log_management/API%20Model%20and%20Service%20(Dashboard)/tripRequestModel.dart';
import 'package:vehicle_log_management/Connection%20Checker/internetconnectioncheck.dart';
import 'package:vehicle_log_management/Senior%20Officer%20Dashboard/srofficerdashboardUI.dart';

import '../API Model and Service (Auth SR Officer)/apiServiceSROfficerAuth.dart';

class PendingTripSROfficer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TripRequestSROfficer staff;

  PendingTripSROfficer({Key? key, required this.staff}) : super(key: key);

  late String action;

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
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: const Text(
            'Pending Trip',
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: const Center(
                    child: Text(
                      'Trip Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 20),
                _buildRow('Name', staff.name),
                //Divider(),
                _buildRow('Designation', staff.designation),
                // Divider(),
                _buildRow('Department', staff.department),
                _buildRow('Mobile Number', staff.phone),
                //  Divider(),
                _buildRow('Trip Type', staff.type),
                // Divider(),
                _buildRowTime('Date', staff.date),
                // Divider(),
                _buildRow('Time', staff.time),
                //  Divider(),
                _buildRow('Destination From', staff.destinationFrom),
                // Divider(),
                _buildRow('Destination To', staff.destinationTo),
                //  Divider(),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.425,
                            MediaQuery.of(context).size.height * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        action = 'accepted';
                        handleAcceptOrReject(action);
                        const snackBar = SnackBar(
                          content: Text('Processing...'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SROfficerDashboard(shouldRefresh: true)),
                          );
                          const snackBar = SnackBar(
                            content: Text('Request Accepted!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: Text('Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          )),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.425,
                            MediaQuery.of(context).size.height * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        action = 'rejected';
                        handleAcceptOrReject(action);
                        const snackBar = SnackBar(
                          content: Text('Processing...'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                SROfficerDashboard(shouldRefresh: true)),
                          );
                          const snackBar = SnackBar(
                            content: Text('Request Declined!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });// Validation complete, hide circular progress indicator
                      },
                      child: Text('Decline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowTime(String label, String value) {
    //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

    // Parse the date and time string
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(value);

    // Format the date and time
    String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
    DateTime date = DateTime.parse(value);
    DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    DateFormat timeFormat = DateFormat.jm();
    String formattedDate = dateFormat.format(date);
    String formattedTime = timeFormat.format(date);
    //String formattedDateTime = '$formattedDate, $formattedTime';
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
                    fontSize: 18,
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
          child: Text(
            formattedDate, // Format date as DD/MM/YYYY
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              height: 1.6,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
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
                    fontSize: 18,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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

  // Function to handle accept or reject action
  Future<void> handleAcceptOrReject(String Action) async {
    final apiService = await TripAcceptRejectAPIService.create();

    print(Action);
    print(staff.id);
    if (action.isNotEmpty && staff.id > 0) {
      await apiService.acceptOrRejectTrip(type: Action, tripId: staff.id);
    } else {
      print('Action or Trip ID is missing');
    }
  }

}
