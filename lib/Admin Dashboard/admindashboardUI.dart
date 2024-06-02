import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/Connection%20Checker/internetconnectioncheck.dart';
import 'package:vehicle_log_management/Profile UI/profileUI.dart';
import 'package:vehicle_log_management/Template%20Models/RecentTripDetails.dart';
import 'package:vehicle_log_management/Template%20Models/staffTripTile.dart';

import '../API Model and Service (Dashboard)/apiserviceDashboard.dart';
import '../API Model and Service (Dashboard)/tripRequestModel.dart';
import '../API Model and Service (Dashboard)/tripRequestModelOngingTrip.dart';
import '../API Model and Service (Dashboard)/tripRequestModelRecent.dart';
import '../API Model and Service (Dashboard)/tripRequestModelSROfficer.dart';
import '../API Service (Notification)/apiServiceNotificationRead.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/AdminPendingTripDetails.dart';
import '../Template Models/AvailableDriverDetails.dart';
import '../Template Models/Logoutalert.dart';
import '../Template Models/OngoingTripDetails.dart';
import '../Template Models/SrOfficerPendingTripDetails.dart';
import '../Template Models/driverlist.dart';
import '../Template Models/staffPendingTripDetails.dart';
import '../Template Models/templateerrorcontainer.dart';

class AdminDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const AdminDashboard({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> recentRequests = [];
  List<Widget> drivers = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      organizationName = prefs.getString('organizationName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      photoUrl = 'https://bcc.touchandsolve.com' + photoUrl;
      print('User Name: $userName');
      print('Organization Name: $organizationName');
      print('Photo URL: $photoUrl');
      print('User profile got it!!!!');
    });
  }

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 3));

      final List<dynamic> driverData = records['Available_Driver'] ?? [];
      for (var index = 0; index < driverData.length; index++) {
        print('Pending Request at index $index: ${driverData[index]}\n');
      }

      // Map pending requests to widgets
      final List<Widget> driverWidgets = driverData.map((request) {
        return DriverInfoCard(
          Name: request['name'],
          MobileNo: request['phone'],
          CarName: request['car_name'],
        );
      }).toList();

      final List<dynamic> pendingRequestsData = records['New_Trip'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Ongoing'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }
      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Pending Request at index $index: ${recentTripData[index]}\n');
      }

      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        print('Pending Trip');
        print(request['name']);
        print(request['designation']);
        print(request['department']);
        print(request['purpose']);
        print(request['phone']);
        print(request['destination_from']);
        print(request['destination_to']);
        print(request['date']);
        print(request['time']);
        print(request['trip_type']);
        return StaffTile(
          staff: TripRequest(
              name: request['name'],
              designation: request['designation'],
              department: request['department'],
              purpose: request['purpose'],
              phone: request['phone'],
              destinationFrom: request['destination_from'],
              destinationTo: request['destination_to'],
              date: request['date'],
              time: request['time'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingTripAdmin(
                  shouldRefresh: true,
                  staff: TripRequestSROfficer(
                      id: request['trip_id'],
                      name: request['name'],
                      designation: request['designation'],
                      department: request['department'],
                      purpose: request['purpose'],
                      phone: request['phone'],
                      destinationFrom: request['destination_from'],
                      destinationTo: request['destination_to'],
                      date: request['date'],
                      time: request['time'],
                      type: request['trip_type']),
                ),
              ),
            );
          },
        );
      }).toList();

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return StaffTile(
          staff: TripRequest(
              name: request['name'],
              designation: request['designation'],
              department: request['department'],
              purpose: request['purpose'],
              phone: request['phone'],
              destinationFrom: request['destination_from'],
              destinationTo: request['destination_to'],
              date: request['date'],
              time: request['time'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OngoingTrip(
                  staff: TripRequestOngoing(
                      driver: request['driver'],
                      Car: request['car'],
                      name: request['name'],
                      designation: request['designation'],
                      department: request['department'],
                      purpose: request['purpose'],
                      phone: request['phone'],
                      destinationFrom: request['destination_from'],
                      destinationTo: request['destination_to'],
                      date: request['date'],
                      time: request['time'],
                      type: request['trip_type'],
                      id: request['trip_id']),
                ),
              ),
            );
          },
        );
      }).toList();

      final List<Widget> recentWidgets = recentTripData.map((request) {
        return StaffTile(
          staff: TripRequest(
              name: request['name'],
              designation: request['designation'],
              department: request['department'],
              purpose: request['purpose'],
              phone: request['phone'],
              destinationFrom: request['destination_from'],
              destinationTo: request['destination_to'],
              date: request['date'],
              time: request['time'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  RecentTripDetails(
                  staff: TripRecent(
                      name: request['name'],
                      designation: request['designation'],
                      department: request['department'],
                      purpose: request['purpose'],
                      phone: request['phone'],
                      destinationFrom: request['destination_from'],
                      destinationTo: request['destination_to'],
                      date: request['date'],
                      time: request['time'],
                      type: request['trip_type'],
                      driver: request['driver'],
                      Car: request['car'],
                      id: request['trip_id'],
                      Duration: request['duration']),
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
        drivers = driverWidgets;
        pendingRequests = pendingWidgets;
        acceptedRequests = acceptedWidgets;
        recentRequests = recentWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetched = true;
      //_errorOccurred = true;
      // Handle error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    loadUserProfile();
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        // connectionRequests = [];
        if (!_isFetched) {
          fetchConnectionRequests();
          //_isFetched = true; // Set _isFetched to true after the first call
        }
      }
      // After 5 seconds, set isLoading to false to stop showing the loading indicator
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
              // Show circular loading indicator while waiting
              child: CircularProgressIndicator(),
            ),
          )
        : InternetChecker(
            child: PopScope(
              canPop: false,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                  titleSpacing: 5,
                  automaticallyImplyLeading: false,
                  title: const Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _showNotificationsOverlay(context);
                            var notificationApiService =
                                await NotificationReadApiService.create();
                            notificationApiService.readNotification();
                          },
                        ),
                        if (notifications.isNotEmpty)
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${notifications.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Column(
                          children: [
                            Center(
                              child: Text('Welcome, $userName',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    fontFamily: 'default',
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Available Drivers',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (drivers.isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: drivers.length > 10
                                                    ? 10
                                                    : drivers.length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return drivers[index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              /*if (shouldShowSeeAllButton(
                                                    pendingRequests))
                                                  buildSeeAllButtonRequestList(
                                                      context)*/
                                            ],
                                          ),
                                        );
                                      } else if (drivers.isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'No Available Driver.');
                                      }
                                    }
                                    // Return a default widget if none of the conditions above are met
                                    return SizedBox(); // You can return an empty SizedBox or any other default widget
                                  }),
                            ),
                            SizedBox(height: screenHeight * 0.02),
/*                      Text('Available Cars',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'default',
                          )),
                      SizedBox(height: screenHeight * 0.01),
                      Text('Available Cars Info will be here!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'default',
                          )),
                      SizedBox(height: screenHeight * 0.03),*/
                            Text('New Trip',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (pendingRequests.isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    pendingRequests.length > 10
                                                        ? 10
                                                        : pendingRequests
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return pendingRequests[index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              /*if (shouldShowSeeAllButton(
                                                    pendingRequests))
                                                  buildSeeAllButtonRequestList(
                                                      context)*/
                                            ],
                                          ),
                                        );
                                      } else if (pendingRequests.isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'You haven\'t created any trip request yet.');
                                      }
                                    }
                                    // Return a default widget if none of the conditions above are met
                                    return SizedBox(); // You can return an empty SizedBox or any other default widget
                                  }),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text('Ongoing Trip',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (acceptedRequests.isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    acceptedRequests.length > 10
                                                        ? 10
                                                        : acceptedRequests
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return acceptedRequests[
                                                      index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              /*if (shouldShowSeeAllButton(
                                                    pendingRequests))
                                                  buildSeeAllButtonRequestList(
                                                      context)*/
                                            ],
                                          ),
                                        );
                                      } else if (acceptedRequests.isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth, 'No trip onging.');
                                      }
                                    }
                                    // Return a default widget if none of the conditions above are met
                                    return SizedBox(); // You can return an empty SizedBox or any other default widget
                                  }),
                            ),
                            Divider(),
                            SizedBox(height: screenHeight * 0.02),
                            Text('Recent Trip',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Divider(),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (recentRequests.isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    recentRequests.length > 10
                                                        ? 10
                                                        : recentRequests.length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return recentRequests[index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              /*if (shouldShowSeeAllButton(
                                                    pendingRequests))
                                                  buildSeeAllButtonRequestList(
                                                      context)*/
                                            ],
                                          ),
                                        );
                                      } else if (recentRequests.isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth, 'No Recent Trip.');
                                      }
                                    }
                                    // Return a default widget if none of the conditions above are met
                                    return SizedBox(); // You can return an empty SizedBox or any other default widget
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: screenHeight * 0.08,
                  color: const Color.fromRGBO(25, 192, 122, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminDashboard(shouldRefresh: true)));
                        },
                        child: Container(
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile(shouldRefresh: true,)));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )),
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
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
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )),
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Logout',
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

  void _showNotificationsOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 10.0,
        right: 10.0,
        width: 250,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: notifications.isEmpty
                ? Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'No new notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(notifications[index]),
                            onTap: () {
                              // Handle notification tap if necessary
                              overlayEntry.remove();
                            },
                          ),
                          if (index < notifications.length - 1) Divider()
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // Remove the overlay when tapping outside
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'Logout Confirmation',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'default',
                ),
              ),
              Divider()
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: const Color.fromRGBO(25, 192, 122, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
