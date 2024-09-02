import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Data/Data Sources/API Service (Fetch Drivers)/apiServiceFetchDrivers.dart';
import '../../Data/Data Sources/Api Service (Assign Driver)/apiServiceAssignDriver.dart';
import '../../Data/Models/tripRequestModelSROfficer.dart';
import '../Pages/Admin Dashboard/admindashboardUI.dart';
import 'dropdownmodel.dart';

/// [PendingTripAdmin] is a [StatefulWidget] that manages the UI and functionality
/// for viewing and assigning drivers to pending trips for an admin.
///
/// The class handles fetching available drivers, displaying trip details,
/// and assigning a driver to the selected trip. It also manages the loading states
/// and error handling for the data fetching process.
///
/// Variables:
/// - [shouldRefresh]: A [bool] that indicates whether the page should refresh upon loading.
/// - [staff]: An instance of [TripRequestSROfficer] representing the staff associated with the trip.
/// - [_scaffoldKey]: A [GlobalKey] used to manage the [ScaffoldState].
/// - [drivers]: A [List] of [String] that stores the names of available drivers.
/// - [_isFetched]: A [bool] indicating if the driver data has been fetched.
/// - [_isLoading]: A [bool] indicating if data is currently being fetched.
/// - [_pageLoading]: A [bool] indicating if the page is still loading.
/// - [_errorOccurred]: A [bool] indicating if an error occurred while fetching data.
/// - [carID]: An [int] representing the ID of the selected car.
class PendingTripAdmin extends StatefulWidget {
  final bool shouldRefresh;
  final TripRequestSROfficer staff;

  PendingTripAdmin({Key? key, this.shouldRefresh = false, required this.staff})
      : super(key: key);

  @override
  State<PendingTripAdmin> createState() => _PendingTripAdminState();
}

class _PendingTripAdminState extends State<PendingTripAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TripRequestSROfficer staff;

  List<String> drivers = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late int carID = 0;

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final apiService = await FetchDriverAPIService.create();

      final Map<String, dynamic>? dashboardData = await apiService.fetchDrivers();
      if (dashboardData == null || dashboardData.isEmpty) {
        print('No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> driverData = dashboardData['records']['Available_Driver'] ?? [];
      final List<String> driverNames = driverData.map<String>((data) {
        final carId = data['car_id'].toString();
        return '${data['name']} - ${data['car_name']} - $carId';
      }).toList();

      setState(() {
        drivers = driverNames.isNotEmpty
            ? driverNames
            : ['No driver available'];
        _isFetched = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching driver data: $e');
      _isFetched = false;
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    staff = widget.staff;
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        print('Page Loading Done!!');
      }
      setState(() {
        print('Page Loading');
        _pageLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    late TextEditingController _driverController = TextEditingController();

    return _pageLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : InternetChecker(
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
                      SizedBox(
                        height: 40,
                      ),
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
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      _buildRow('Name', staff.name),
                      _buildRow('Designation', staff.designation),
                      _buildRow('Department', staff.department),
                      _buildRowTime('Date', staff.date),
                      _buildRow('Start Time', staff.startTime),
                      _buildRow('End Time', staff.endTime),
                      _buildRow('Distance', '${staff.distance} KM'),
                      _buildRow('Trip Type', staff.category),
                      _buildRow('Trip Mode', staff.type),
                      _buildRow('Destination From', staff.destinationFrom),
                      _buildRow('Destination To', staff.destinationTo),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 20,),
                      Text('Assign Driver',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'default',
                      ),),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          DropdownMenuModel(
                            label: 'Driver',
                            options: drivers,
                            onChanged: (selectedDriver) {
                              print('Selected driver: $selectedDriver');
                            },
                            onCarIdChanged:(selectedDriver){
                              print('Selected driver ID: $selectedDriver');
                              setState(() {
                                carID = int.parse(selectedDriver!);
                                print('Car ID: $carID');
                              });
                            }
                          ),
                          if (_isLoading)
                            Padding(
                              padding: const EdgeInsets.only(top:15.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color:
                                  const Color.fromRGBO(25, 192, 122, 1),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 192, 122, 1),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.8,
                                MediaQuery.of(context).size.height * 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                              assignDriver(carID);
                          },
                          child: Text('Submit',
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
          );
  }

  Future<void> assignDriver(int driver) async {
    const snackBar = SnackBar(
      content: Text('Processing...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print('CAR Id: $driver');
    print('Trip Id: ${staff.id}');
    if (staff.id > 0 && driver > 0) {
      final apiService = await AssignCarAPIService.create();
      bool checker = await apiService.assignCarToTrip(tripId: staff.id, carId: driver);
      if(checker == true){
        const snackBar = SnackBar(
          content: Text('Car assigned successfully!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard(shouldRefresh: true)),
        );
      }
      else if(checker == false){
        const snackBar = SnackBar(
          content: Text('Car assigned failed. Try again.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print('CarID or Trip ID is missing');
    }
  }

  Widget _buildRowTime(String label, String? value) {
    if (value == null || value.isEmpty) {
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
              "No Date", // Display "No Date" if value is null
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


    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(value);
    String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
    DateTime date = DateTime.parse(value);
    DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    DateFormat timeFormat = DateFormat.jm();
    String formattedDate = dateFormat.format(date);
    String formattedTime = timeFormat.format(date);
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
}
