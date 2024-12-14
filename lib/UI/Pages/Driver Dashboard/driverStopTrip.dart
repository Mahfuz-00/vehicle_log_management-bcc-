import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Stop Trip)/apiServiceStopTrip.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../Widgets/customclipperbottomnavbar.dart';
import '../../Widgets/customnotchpainter.dart';
import '../Profile UI/profileUI.dart';
import 'driverdashboardUI.dart';

/// The [DriverStopTripUI] class represents the UI for the driver's trip stop
/// interface. It allows the driver to view current trip details, elapsed
/// time, and stop the trip when necessary.
///
/// This widget takes the following parameters:
///
/// - [shouldRefresh]: A boolean value indicating whether to refresh the page
///   on initialization (default is false).
/// - [staff]: An instance of [ApprovedStaffTripRequest] representing the
///   details of the staff member for the current trip.
///
/// The state class [_DriverStartTripState] manages the following variables:
///
/// - [_scaffoldKey]: A GlobalKey for the Scaffold widget to manage the
///   state of the scaffold.
/// - [staff]: An instance of [ApprovedStaffTripRequest] representing the
///   details of the staff member for the current trip.
/// - [_isFetched]: A boolean indicating whether data has been fetched.
/// - [_isLoading]: A boolean indicating whether the loading indicator is
///   active.
/// - [_pageLoading]: A boolean indicating whether the page is currently
///   loading.
/// - [_errorOccurred]: A boolean indicating whether an error has occurred.
/// - [_startTime]: A DateTime object representing the start time of the trip.
/// - [_stopwatch]: A Stopwatch to track the elapsed time.
/// - [_timer]: A Timer to update the elapsed time periodically.
/// - [_elapsed]: A Duration object representing the total elapsed time since
///   the trip started.
class DriverStopTripUI extends StatefulWidget {
  final bool shouldRefresh;
  final ApprovedStaffTripRequest staff;

  const DriverStopTripUI(
      {Key? key, this.shouldRefresh = false, required this.staff})
      : super(key: key);

  @override
  State<DriverStopTripUI> createState() => _DriverStartTripState();
}

class _DriverStartTripState extends State<DriverStopTripUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ApprovedStaffTripRequest staff;
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late DateTime _startTime;
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    staff = widget.staff;
    _loadStartTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_startTime != null) {
          _elapsed = DateTime.now().difference(_startTime!);
        }
      });
    });
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);
  }

  Future<void> _loadStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startTimeStr = prefs.getString('startTime');
    int? elapsedMilliseconds = prefs.getInt('elapsedDuration');

    if (startTimeStr != null) {
      _startTime = DateTime.parse(startTimeStr);
      _elapsed = Duration(milliseconds: elapsedMilliseconds ?? 0);
      setState(() {
        _elapsed += DateTime.now().difference(_startTime!);
      });
    } else {
      _startTime = DateTime.now();
      await _saveStartTime();
    }
  }

  Future<void> _saveStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('startTime', _startTime!.toIso8601String());
  }

  Future<void> _saveElapsedDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('elapsedDuration', _elapsed.inMilliseconds);
  }

  Future<void> _clearStartTimeAndDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('startTime');
    await prefs.remove('elapsedDuration');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            titleSpacing: 5,
            automaticallyImplyLeading: false,
            title: const Text(
              'Current Trip',
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
                                _buildRow('Name', staff.name),
                                _buildRow('Designation', staff.designation),
                                _buildRow('Department', staff.department),
                                _buildRow('Mobile Number', staff.phone),
                                _buildRow('Trip Category', staff.category),
                                if(staff.category != 'Pick Drop')...[
                                  _buildRow('Trip Type', staff.type!),
                                  _buildRowTime('Date', staff.date!),
                                  _buildRow('Start Time', staff.startTime!),
                                  _buildRow('End Time', staff.endTime!),
                                  _buildRow('Destination From', staff.destinationFrom!),
                                  _buildRow('Destination To', staff.destinationTo!),
                                  _buildRow('Distance', '${staff.distance} KM'),
                                ], if(staff.category == 'Pick Drop') ...[
                                  _buildRow('Route', staff.route!),
                                  // _buildRow('Stoppage', staff.stoppage!),
                                  _buildRowTime('Start Month', staff.startMonth!),
                                  _buildRowTime('End Month', staff.endMonth!),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Divider(),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          width: screenWidth*0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  '${staff.destinationFrom} to ${staff.destinationTo}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: 'default',
                                  )),
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                'Start Time: ${_formatDateTime(_startTime!)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'default',
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Duration',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'default',
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                _formatDuration(_elapsed),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'default',
                                ),
                              ),
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
                      StopTrip();
                    },
                    tooltip: 'Stop Engine',
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      'Assets/Images/Stop Engine.png',
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
                              builder: (context) => DriverDashboardUI(shouldRefresh: true,)));
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
                              builder: (context) => const ProfileUI(shouldRefresh: true,)));
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
      ),
    );
  }

  Future<void> StopTrip() async {
    showTopToast(context, 'Processing...');
    print('Trip Id: ${staff.id}');
    if (staff.id > 0) {
      final apiService = await StopTripAPIService.create();
      bool checker = await apiService.TripStopped(tripId: staff.id,);
      if(checker == true){
        showTopToast(context, 'Trip Finished successfully!');
        _clearStartTimeAndDuration();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverDashboardUI(shouldRefresh: true,)),
        );
      }
      else if(checker == false){
        showTopToast(context, 'Failed to stop the trip. Please try again.');
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

  Widget _buildRowTime(String label, String value) {
    //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM
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
