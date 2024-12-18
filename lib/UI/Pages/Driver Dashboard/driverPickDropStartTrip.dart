import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_log_management/Data/Models/driverstaffModel.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Start Trip)/apiServicePickDropStartTrip.dart';
import '../../../Data/Data Sources/API Service (Start Trip)/apiServiceStartTrip.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../Widgets/customclipperbottomnavbar.dart';
import '../../Widgets/customnotchpainter.dart';
import '../Profile UI/profileUI.dart';
import 'driverPickDropStopTrip.dart';
import 'driverStopTrip.dart';
import 'driverdashboardUI.dart';

/// The [DriverPickDropStartTripUI] class is a StatefulWidget that represents the
/// user interface for drivers to start a trip. It takes in a
/// [shouldRefresh] boolean to determine if the page should refresh and
/// an [ApprovedStaffModel] object [staff] that contains the trip
/// details.
///
/// Key variables:
/// - [scaffoldKey]: A GlobalKey for the Scaffold to manage its state.
/// - [staff]: Holds the trip details passed from the parent widget.
/// - [_isFetched]: Indicates whether the trip data has been fetched.
/// - [_isLoading]: Indicates if the loading state is active.
/// - [_pageLoading]: Controls the loading state of the page.
/// - [_errorOccurred]: Indicates if an error has occurred during the
///   fetching process.
///
/// Key actions:
/// - [StartTrip]: Starts the trip by calling the API and navigating
///   to the [DriverStopTripUI] on success.
/// - [showTopToast]: Displays a temporary toast message at the top of
///   the screen.
/// - [_buildRowTime]: Builds a row to display time in a formatted
///   manner.
class DriverPickDropStartTripUI extends StatefulWidget {
  final bool shouldRefresh;
  final DriveTripRoute staff;

  const DriverPickDropStartTripUI(
      {Key? key, this.shouldRefresh = false, required this.staff})
      : super(key: key);

  @override
  State<DriverPickDropStartTripUI> createState() =>
      _DriverPickDropStartTripUIState();
}

class _DriverPickDropStartTripUIState extends State<DriverPickDropStartTripUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DriveTripRoute staff;
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;

  @override
  void initState() {
    super.initState();
    staff = widget.staff;
    print('initState called');
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh) {
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
    return _pageLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : InternetConnectionChecker(
            child: Scaffold(
              backgroundColor: Colors.grey[100],
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
                  'New Trip',
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
                  child: SafeArea(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Trip Details',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Divider(),
                            SizedBox(height: screenHeight * 0.01),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    _buildRow('Route', staff.name),
                                    _buildRowTime('Date', staff.date!),
                                    _buildRowTime(
                                        'Start Time', staff.startTime),
                                    _buildRowTime('End Time', staff.endTime!),
                                    SizedBox(height: 20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Stoppage Name',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(25, 192, 122, 1),
                                                    fontSize: 19,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "::",
                                            style: TextStyle(
                                              color: Color.fromRGBO(25, 192, 122, 1),
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Staff(s)',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(25, 192, 122, 1),
                                                    fontSize: 19,
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
                                    ),
                                    _buildStoppages(staff.stoppages),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Divider(),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${staff.name}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.03),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Start Time: ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Engine Warming Up',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 25,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text('Duration',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text('0:00',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'default',
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    right: screenWidth / 2.85,
                    child: Container(
                      height: screenHeight * 0.17,
                      width: screenWidth * 0.3,
                      child: FloatingActionButton.large(
                        onPressed: () {
                          StartTrip();
                        },
                        tooltip: 'Stop Engine',
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          'Assets/Images/Start Engine.png',
                          width: screenWidth * 0.28,
                          height: screenWidth * 0.28,
                          fit: BoxFit.cover,
                        ),
                        elevation: 0.0,
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.transparent,
                elevation: 5,
                height: screenHeight * 0.08,
                padding: EdgeInsets.all(0),
                notchMargin: 10.0,
                shape: CircularNotchedRectangle(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverDashboardUI(
                                        shouldRefresh: true,
                                      )));
                        },
                        child: Container(
                          width: screenWidth / 3,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(25, 192, 122, 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipPath(
                        clipper: NotchClipper(),
                        child: CustomPaint(
                          painter: NotchPainter(),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            width: screenWidth / 3,
                            height: screenHeight * 0.9,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: screenHeight * 0.01,
                                  left: 0,
                                  right: 0,
                                  child: Text(
                                    'Stop Engine',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileUI(
                                        shouldRefresh: true,
                                      )));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(25, 192, 122, 1),
                              border: Border(
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              )),
                          width: screenWidth / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> StartTrip() async {
    showTopToast(context, 'Processing...');
    print('Trip Id: ${staff.routeId}');
    if (staff.routeId > 0) {
      final apiService = await PickDropStartTripAPIService.create();
      bool checker = await apiService.TripStarted(
        tripId: staff.routeId,
      );
      if (checker == true) {
        showTopToast(context, 'Trip Started successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DriverPickDropStopTripUI(
                    shouldRefresh: true,
                    staff: staff,
                  )),
        );
      } else if (checker == false) {
        showTopToast(context, 'The trip failed to start. Try again.');
      }
    } else {
      print('Trip ID is missing');
    }
  }

  void showTopToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }

  Widget _buildStoppages(Map<String, dynamic> stoppages) {
    List<Widget> stoppageWidgets = [];
    stoppages.forEach((stoppage, description) {
      stoppageWidgets.add(
        _buildRow(
          stoppage,
          description.isEmpty
              ? 'N/A'
              : description, // Display N/A if description is empty
        ),
      );
    });

    return Column(
      children: stoppageWidgets,
    );
  }

  Widget _buildRowTime(String label, String value) {
    String formattedDate = 'Invalid date';

    try {
      if (value == 'N/A' || value == 'None') {
        // Handle the "N/A" case explicitly
        formattedDate = 'N/A';
      }
      /*else if (staff.category == 'Pick Drop') {
        // Parse the date using the appropriate format for 'Pick Drop'
        DateTime dateTime = DateFormat('yyyy-MM-dd').parse(value);
        // Format the parsed date into "MMMM yyyy" (e.g., "January 2024")
        formattedDate = DateFormat.yMMMM('en_US').format(dateTime);
      }*/
      else {
        DateTime dateTime;

        // Identify if the input contains date only, time only, or both
        if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
          // Input contains only a date (e.g., "2024-01-01")
          dateTime = DateFormat('yyyy-MM-dd').parse(value);
          formattedDate = DateFormat.yMMMMd('en_US')
              .format(dateTime); // e.g., "January 1, 2024"
        } else if (RegExp(r'^\d{1,2}:\d{2}([ ]?[APap][Mm])?$')
            .hasMatch(value)) {
          // Input contains only a time (e.g., "10:30" or "10:30:00")
          dateTime = DateFormat('HH:mm').parse(value, true);
          formattedDate = DateFormat.jm().format(dateTime); // e.g., "10:30 AM"
        } else if (RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2})?$')
            .hasMatch(value)) {
          // Input contains both date and time (e.g., "2024-01-01 10:30:00")
          dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(value);
          String formattedDatePart =
              DateFormat.yMMMMd('en_US').format(dateTime);
          String formattedTimePart = DateFormat.jm().format(dateTime);
          formattedDate =
              '$formattedDatePart, $formattedTimePart'; // Combine date and time
        } else {
          throw FormatException('Unsupported date/time format: $value');
        }
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

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
            formattedDate, // Display the formatted date
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
