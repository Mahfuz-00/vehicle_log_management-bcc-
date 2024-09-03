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

class StaffDashboardPendingTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const StaffDashboardPendingTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<StaffDashboardPendingTripsUI> createState() => _StaffDashboardPendingTripsUIState();
}

class _StaffDashboardPendingTripsUIState extends State<StaffDashboardPendingTripsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> recentRequests = [];
  bool _isFetched = false;
  bool _isFetchedFull = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _buttonpressed = false;
  bool _errorOccurred = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];
  late Pagination pendingPagination;
  late Pagination acceptedPagination;
  late Pagination recentPagination;

  // Example to check if more data can be fetched
  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;
  bool canFetchMoreRecent = false;

  late String pendingNext = '';
  late String acceptedNext = '';
  late String recentNext = '';
  late String pendingPrev = '';
  late String acceptedPrev = '';
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

      pendingPagination = Pagination.fromJson(pagination['pending']);
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
      recentPagination = Pagination.fromJson(pagination['recent']);

      print(pendingPagination.nextPage);
      print(acceptedPagination.nextPage);
      print(recentPagination.nextPage);
      setState(() {
        pendingNext = pendingPagination.nextPage as String;
        print('Next: $pendingNext');
        acceptedNext = acceptedPagination.nextPage as String;
        recentNext = recentPagination.nextPage as String;
      });
      print(pendingPagination.previousPage);
      print(acceptedPagination.previousPage);
      print(recentPagination.previousPage);
      setState(() {
        pendingPrev = pendingPagination.previousPage as String;
        print('Prev: $pendingPrev');
        acceptedPrev = acceptedPagination.previousPage as String;
        recentPrev = recentPagination.previousPage as String;
      });

      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      canFetchMoreRecent = recentPagination.canFetchNext;
      print(canFetchMorePending);
      print(canFetchMoreAccepted);
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
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetched = true;
      //_errorOccurred = true;
      // Handle error as needed
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

      pendingPagination = Pagination.fromJson(pagination['pending']);
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
      recentPagination = Pagination.fromJson(pagination['recent']);

      print(pendingPagination.nextPage);
      print(acceptedPagination.nextPage);
      print(recentPagination.nextPage);
      pendingNext = pendingPagination.nextPage as String;
      acceptedNext = acceptedPagination.nextPage as String;
      recentNext = recentPagination.nextPage as String;
      print(pendingPagination.previousPage);
      print(acceptedPagination.previousPage);
      print(recentPagination.previousPage);
      pendingPrev = pendingPagination.previousPage as String;
      acceptedPrev = acceptedPagination.previousPage as String;
      recentPrev = recentPagination.previousPage as String;

      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      canFetchMoreRecent = recentPagination.canFetchNext;
      print(canFetchMorePending);
      print(canFetchMoreAccepted);
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
    // Initialize the pagination with default values
    pendingPagination = Pagination(nextPage: null, previousPage: null);
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    recentPagination = Pagination(nextPage: null, previousPage: null);
    if (!_isFetched) {
      fetchConnectionRequests();
      //_isFetched = true; // Set _isFetched to true after the first call
    }
    print('initState called');
    loadUserProfile();
    Future.delayed(Duration(seconds: 2), () {
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
                                  Text('Pending Trip',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  Divider(),
                                  AllRequestsWidget(
                                    loading: _isLoading,
                                    fetch: _isFetched,
                                    errorText:
                                        'You haven\'t created any trip request yet.',
                                    listWidget: pendingRequests,
                                    fetchData: fetchConnectionRequests(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: (pendingNext
                                                      .isNotEmpty &&
                                                  pendingPrev != 'None' &&
                                                  _isLoading)
                                              ? const Color.fromRGBO(
                                                  25, 192, 122, 1)
                                              : Colors.grey, // Disabled color
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: (pendingNext.isNotEmpty &&
                                                pendingPrev != 'None' &&
                                                _isLoading)
                                            ? () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Loading...'),
                                                  ),
                                                );
                                                print('Prev: $pendingPrev');
                                                setState(() {
                                                  _buttonpressed = true;
                                                  _isFetchedFull = false;
                                                  fetchConnectionRequestsPagination(
                                                      pendingPrev);
                                                  _buttonpressed = false;
                                                  pendingPrev = '';
                                                });
                                              }
                                            : null,
                                        child: _buttonpressed
                                            ? CircularProgressIndicator()
                                            : Text('Previous',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'default',
                                                )),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: (pendingNext
                                                      .isNotEmpty &&
                                                  pendingNext != 'None' &&
                                                  _isLoading)
                                              ? const Color.fromRGBO(
                                                  25, 192, 122, 1)
                                              : Colors.grey, // Disabled color
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: (pendingNext.isNotEmpty &&
                                                pendingNext != 'None' &&
                                                _isLoading)
                                            ? () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Loading...'),
                                                  ),
                                                );
                                                print('Next: $pendingNext');
                                                setState(() {
                                                  _buttonpressed = true;
                                                  _isFetchedFull = false;
                                                  fetchConnectionRequestsPagination(
                                                      pendingNext);
                                                  _buttonpressed = false;
                                                  pendingNext = '';
                                                });
                                              }
                                            : null,
                                        child: _buttonpressed
                                            ? CircularProgressIndicator()
                                            : Text('Next',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                          StaffDashboardPendingTripsUI(
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
                                      builder: (context) => const ProfileUI(
                                            shouldRefresh: true,
                                          )));
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
