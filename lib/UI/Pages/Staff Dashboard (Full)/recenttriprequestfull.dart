import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/UI/Widgets/requestWidgetShowAll.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboardFull.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../../Data/Models/tripRequestModelRecent.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/RecentTripDetails.dart';
import '../../Widgets/StaffApprovedTripDetails.dart';
import '../../Widgets/requestWidget.dart';
import '../../Widgets/staffPendingTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Trip Request Form(Staff)/triprequestformUI.dart';


class StaffDashboardRecentTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const StaffDashboardRecentTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<StaffDashboardRecentTripsUI> createState() => _StaffDashboardRecentTripsUIState();
}

class _StaffDashboardRecentTripsUIState extends State<StaffDashboardRecentTripsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> recentRequests = [];
  bool _isFetched = false;
  bool _isFetchedFull = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];

  late Pagination recentPagination;

  bool canFetchMoreRecent = false;

  late String recentNext = '';
  late String recentPrev = '';

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

      final Map<String, dynamic> pagination = records['pagination'] ?? {};

      recentPagination = Pagination.fromJson(pagination['recent']);

      print(recentPagination.nextPage);
      setState(() {
        recentNext = recentPagination.nextPage as String;
      });
      print(recentPagination.previousPage);
      setState(() {
        recentPrev = recentPagination.previousPage as String;
      });

      canFetchMoreRecent = recentPagination.canFetchNext;
      print(canFetchMoreRecent);

      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Recent Trip at index $index: ${recentTripData[index]}\n');
      }

      // Map accepted requests to widgets
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
              startTime: request['start_time'],
              endTime: request['end_time'],
              distance: request['approx_distance'],
              category: request['trip_category'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecentTripDetails(
                  staff: RecentTrip(
                      name: request['name'],
                      designation: request['designation'],
                      department: request['department'],
                      purpose: request['purpose'],
                      phone: request['phone'],
                      destinationFrom: request['destination_from'],
                      destinationTo: request['destination_to'],
                      date: request['date'],
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      distance: request['approx_distance'],
                      category: request['trip_category'],
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
        recentRequests = recentWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetched = true;
    }
  }

  Future<void> fetchConnectionRequestsPagination(String url) async {
    if (_isFetchedFull) return;
    try {
      final apiService = await DashboardFullAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
      await apiService.fetchDashboardItemsFull(url);
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

      final Map<String, dynamic> pagination = records['pagination'] ?? {};

      recentPagination = Pagination.fromJson(pagination['recent']);
      print(recentPagination.nextPage);

      recentNext = recentPagination.nextPage as String;

      print(recentPagination.previousPage);
      recentPrev = recentPagination.previousPage as String;

      canFetchMoreRecent = recentPagination.canFetchNext;
      print(canFetchMoreRecent);

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
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
              startTime: request['start_time'],
              endTime: request['end_time'],
              distance: request['approx_distance'],
              category: request['trip_category'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingStaffTrip(
                  staff: TripRequest(
                      name: request['name'],
                      designation: request['designation'],
                      department: request['department'],
                      purpose: request['purpose'],
                      phone: request['phone'],
                      destinationFrom: request['destination_from'],
                      destinationTo: request['destination_to'],
                      date: request['date'],
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      distance: request['approx_distance'],
                      category: request['trip_category'],
                      type: request['trip_type']),
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
        pendingRequests = pendingWidgets;
        _isFetchedFull = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetchedFull = true;
      //_errorOccurred = true;
      // Handle error as needed
    }
  }

  // Function to check if more than 10 items are available in the list
  bool shouldShowSeeAllButton(List list) {
    return list.length > 10;
  }

  @override
  void initState() {
    super.initState();
    if (!_isFetched) {
      fetchConnectionRequests();
      //_isFetched = true; // Set _isFetched to true after the first call
    }
    recentPagination = Pagination(nextPage: null, previousPage: null);
    print('initState called');
    loadUserProfile();
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        // connectionRequests = [];

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
        : BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userProfile = state.userProfile;
          return InternetConnectionChecker(
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                titleSpacing: 5,
                automaticallyImplyLeading: false,
                title: const Text(
                  'Staff Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Column(
                          children: [
                            Center(
                              child: Text('Welcome, ${userProfile.name}',
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
                            /*    Text('Pending Trip',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: 'default',
                          )),
                      SizedBox(height: screenHeight * 0.01),
                      Divider(),
                      RequestsWidget(
                          loading: _isLoading,
                          fetch: _isFetched,
                          errorText: 'You haven\'t created any trip request yet.',
                          listWidget: pendingRequests,
                          fetchData: fetchConnectionRequests(),
                          numberOfWidgets: 10,
                          showSeeAllButton: shouldShowSeeAllButton(
                              pendingRequests),
                          seeAllButtonText: '',
                          nextPage: null),*/
                            /* Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height:
                                            200, // Adjust height as needed
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
                                      return buildNoRequestsWidget(
                                          screenWidth,
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
                                                itemCount: pendingRequests
                                                            .length >
                                                        10
                                                    ? 10
                                                    : pendingRequests.length,
                                                itemBuilder:
                                                    (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return pendingRequests[
                                                      index];
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                            height: 10),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              *//*if (shouldShowSeeAllButton(
                                                  pendingRequests))
                                                buildSeeAllButtonRequestList(
                                                    context)*//*
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
                            ),*/
                            /*   Divider(),
                      SizedBox(height: screenHeight * 0.02),
                      Text('Approved Trip',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: 'default',
                          )),
                      SizedBox(height: screenHeight * 0.01),
                      Divider(),
                      RequestsWidget(
                          loading: _isLoading,
                          fetch: _isFetched,
                          errorText: 'No trip request reviewed yet.',
                          listWidget: acceptedRequests,
                          fetchData: fetchConnectionRequests(),
                          numberOfWidgets: 10,
                          showSeeAllButton: shouldShowSeeAllButton(
                              acceptedRequests),
                          seeAllButtonText: '',
                          nextPage: null),
                      Divider(),
                      SizedBox(height: screenHeight * 0.02),*/
                            Text('Recent Trip',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'default',
                                )),
                            SizedBox(height: screenHeight * 0.01),
                            Divider(),
                            AllRequestsWidget(
                              loading: _isLoading,
                              fetch: _isFetched,
                              errorText: 'You haven\'t take any trip yet.',
                              listWidget: recentRequests,
                              fetchData: fetchConnectionRequests(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: (recentPrev.isNotEmpty && recentPrev != 'None' && _isLoading)
                                        ? const Color.fromRGBO(25, 192, 122, 1)
                                        : Colors.grey, // Disabled color
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.35,
                                        MediaQuery.of(context).size.height * 0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: (recentPrev.isNotEmpty && recentPrev != 'None' && _isLoading)
                                      ? () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('Loading...'),
                                      ),
                                    );
                                    print('Prev: $recentPrev');
                                    setState(() {
                                      _isFetchedFull = false;
                                      fetchConnectionRequestsPagination(recentPrev);
                                      recentPrev = '';
                                    });
                                  }
                                      : null,
                                  child: Text('Previous',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: (recentNext.isNotEmpty && recentNext != 'None' && _isLoading)
                                        ? const Color.fromRGBO(25, 192, 122, 1)
                                        : Colors.grey, // Disabled color
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.35,
                                        MediaQuery.of(context).size.height * 0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: (recentNext.isNotEmpty && recentNext != 'None' && _isLoading)
                                      ? () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('Loading...'),
                                      ),
                                    );
                                    print('Next: $recentNext');
                                    setState(() {
                                      _isFetchedFull = false;
                                      fetchConnectionRequestsPagination(recentNext);
                                      recentNext = '';
                                    });
                                  }
                                      : null,
                                  child: Text('Next',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ],
                            ),
                            //    Divider(),
                            /*      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromRGBO(25, 192, 122, 1),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.8,
                                MediaQuery.of(context).size.height *
                                    0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TripRequestForm()));
                          },
                          child: const Text('New Trip Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                        ),
                      )*/
                          ],
                        ),
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
                                builder: (context) => StaffDashboardRecentTripsUI(
                                  shouldRefresh: true,
                                )));
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
                                builder: (context) =>
                                const TripRequestFormUI()));
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
                              Icons.add_circle_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Trip Request',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileUI(shouldRefresh:  true,)));
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
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
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
                  onPressed: () async {
                    // Clear user data from SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userName');
                    await prefs.remove('organizationName');
                    await prefs.remove('photoUrl');
                    // Create an instance of LogOutApiService
                    var logoutApiService = await LogOutApiService.create();

                    // Wait for authToken to be initialized
                    logoutApiService.authToken;

                    // Call the signOut method on the instance
                    if (await logoutApiService.signOut()) {
                      Navigator.pop(context);
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginUI())); // Close the drawer
                    }
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
