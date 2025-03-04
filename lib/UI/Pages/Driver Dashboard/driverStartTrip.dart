import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Start Trip)/apiServiceStartTrip.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../Widgets/customclipperbottomnavbar.dart';
import '../../Widgets/customnotchpainter.dart';
import '../Profile UI/profileUI.dart';
import 'driverStopTrip.dart';
import 'driverdashboardUI.dart';

/// The [DriverStartTripUI] class is a StatefulWidget that represents the
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
class DriverStartTripUI extends StatefulWidget {
  final bool shouldRefresh;
  final ApprovedStaffModel staff;

  const DriverStartTripUI(
      {Key? key, this.shouldRefresh = false, required this.staff})
      : super(key: key);

  @override
  State<DriverStartTripUI> createState() => _DriverStartTripUIState();
}

class _DriverStartTripUIState extends State<DriverStartTripUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ApprovedStaffModel staff;
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
                                  if(staff.category != 'Pick Drop') ...[
                                    Text(
                                        '${staff.destinationFrom} to ${staff.destinationTo}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontFamily: 'default',
                                        )),
                                  ],
                                  if(staff.category == 'Pick Drop') ...[
                                    Text(
                                        '${staff.route}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontFamily: 'default',
                                        )),
                                  ],
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
          );
  }

  Future<void> StartTrip() async {
    showTopToast(context, 'Processing...');
    print('Trip Id: ${staff.id}');
    if (staff.id > 0) {
      final apiService = await StartTripAPIService.create();
      bool checker = await apiService.TripStarted(tripId: staff.id,);
      if(checker == true){
        showTopToast(context, 'Trip Started successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverStopTripUI(shouldRefresh: true, staff: staff,)),
        );
      }
      else if(checker == false){
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
