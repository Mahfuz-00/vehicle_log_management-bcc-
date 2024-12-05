import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/UI/Pages/Admin%20Dashboard%20(Full)/availabledriverlistfull.dart';
import 'package:vehicle_log_management/UI/Pages/Admin%20Dashboard%20(Full)/ongoingtriprequestfull.dart';
import 'package:vehicle_log_management/UI/Pages/Admin%20Dashboard%20(Full)/pendingtriprequestfull.dart';
import 'package:vehicle_log_management/UI/Pages/Advance%20Search%20Report/searchReport.dart';
import 'package:vehicle_log_management/UI/Widgets/requestWidget.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../../Data/Models/tripRequestModelOngingTrip.dart';
import '../../../Data/Models/tripRequestModelRecent.dart';
import '../../../Data/Models/tripRequestModelSROfficer.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/AdminPendingTripDetails.dart';
import '../../Widgets/AvailableDriverDetails.dart';
import '../../Widgets/OngoingTripDetails.dart';
import '../../Widgets/RecentTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// The [AdminDashboardUI] widget represents the main dashboard screen for administrators.
/// This screen allows admins to view and manage various requests and drivers, including pending, accepted, and recent requests.
///
/// **Variables:**
/// - [shouldRefresh] (bool): Determines if the dashboard should refresh upon loading.
///
/// **StatefulWidget Components:**
/// - [AdminDashboardUI]: The main widget class for the admin dashboard.
/// - [_AdminDashboardUIState]: Manages the state and logic for the admin dashboard, including data fetching and user profile loading.
///
/// **State Management:**
/// - [_scaffoldKey] (GlobalKey<ScaffoldState>): Key for managing the scaffold state.
/// - [pendingRequests] (List<Widget>): List of widgets representing pending requests.
/// - [acceptedRequests] (List<Widget>): List of widgets representing accepted requests.
/// - [recentRequests] (List<Widget>): List of widgets representing recent requests.
/// - [drivers] (List<Widget>): List of widgets representing available drivers.
/// - [_isFetched] (bool): Flag indicating if the data has been fetched.
/// - [_isLoading] (bool): Flag indicating if data is currently being loaded.
/// - [_pageLoading] (bool): Flag indicating if the page is in a loading state.
/// - [_errorOccurred] (bool): Flag indicating if an error occurred during data fetching.
///
/// **User Profile Data:**
/// - [userName] (String): Stores the user's name.
/// - [organizationName] (String): Stores the user's organization name.
/// - [photoUrl] (String): Stores the user's profile photo URL.
/// - [notifications] (List<String>): Stores a list of user notifications.
///
/// **Pagination Data:**
/// - [pendingPagination] (Pagination): Manages pagination for pending requests.
/// - [acceptedPagination] (Pagination): Manages pagination for accepted requests.
/// - [recentPagination] (Pagination): Manages pagination for recent requests.
/// - [driversPagination] (Pagination): Manages pagination for available drivers.
///
/// **Data Fetching Flags:**
/// - [canFetchMorePending] (bool): Indicates if more pending requests can be fetched.
/// - [canFetchMoreAccepted] (bool): Indicates if more accepted requests can be fetched.
/// - [canFetchMoreRecent] (bool): Indicates if more recent requests can be fetched.
/// - [canFetchMoreDrivers] (bool): Indicates if more drivers can be fetched.
class AdminDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const AdminDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AdminDashboardUI> createState() => _AdminDashboardUIState();
}

class _AdminDashboardUIState extends State<AdminDashboardUI> {
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
  late Pagination pendingPagination;
  late Pagination acceptedPagination;
  late Pagination recentPagination;
  late Pagination driversPagination;

  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;
  bool canFetchMoreRecent = false;
  bool canFetchMoreDrivers = false;

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

      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination['new_trip']);
      acceptedPagination = Pagination.fromJson(pagination['ongoing']);
      driversPagination = Pagination.fromJson(pagination['driver']);

      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      canFetchMoreDrivers = driversPagination.canFetchNext;

      notifications = List<String>.from(records['notifications'] ?? []);

      await Future.delayed(Duration(seconds: 3));

      final List<dynamic> driverData = records['Available_Driver'] ?? [];
      for (var index = 0; index < driverData.length; index++) {
        print('Pending Request at index $index: ${driverData[index]}\n');
      }

      final List<Widget> driverWidgets = driverData.map((request) {
        return DriverInfoCard(
          Name: request['name'],
          MobileNo: request['phone'],
          CarName: request['car_name'],
          CarRegNo: request['car_number'],
          CarModel: request['car_model'],
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
              type: request['trip_type'],
              startTime: request['start_time'],
              endTime: request['end_time'],
              distance: request['approx_distance'],
              category: request['trip_category']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPendingTrip(
                  shouldRefresh: true,
                  staff: SROfficerTripRequest(
                      id: request['trip_id'],
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
              startTime: request['start_time'],
              endTime: request['end_time'],
              distance: request['approx_distance'],
              category: request['trip_category'],
              type: request['trip_type']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OngoingTrip(
                  staff: OngoingTripRequest(
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
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      distance: request['approx_distance'],
                      category: request['trip_category'],
                      type: request['trip_type'],
                      id: request['trip_id'],
                      startTrip: request['start']),
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
        drivers = driverWidgets;
        pendingRequests = pendingWidgets;
        acceptedRequests = acceptedWidgets;
        recentRequests = recentWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetched = true;
    }
  }

  bool shouldShowSeeAllButton(List list) {
    return list.length > 10;
  }

  @override
  void initState() {
    super.initState();
    pendingPagination = Pagination(nextPage: null, previousPage: null);
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    recentPagination = Pagination(nextPage: null, previousPage: null);
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    loadUserProfile();
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
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
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetConnectionChecker(
                  child: PopScope(
                    /*  canPop: false,*/
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
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
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
                                  Text('Available Drivers',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  RequestsWidget(
                                    loading: _isLoading,
                                    fetch: _isFetched,
                                    errorText: 'No Available Driver.',
                                    listWidget: drivers,
                                    fetchData: fetchConnectionRequests(),
                                    numberOfWidgets: 3,
                                    showSeeAllButton: canFetchMoreDrivers,
                                    seeAllButtonText: 'See All Drivers',
                                    nextView: AdminDashboardAvailableDriverUI(
                                      shouldRefresh: true,
                                    ),
                                    pagination: canFetchMoreDrivers,
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                  Text('New Trips',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  RequestsWidget(
                                    loading: _isLoading,
                                    fetch: _isFetched,
                                    errorText:
                                        'There aren\'t any trip request yet.',
                                    listWidget: pendingRequests,
                                    fetchData: fetchConnectionRequests(),
                                    numberOfWidgets: 5,
                                    showSeeAllButton: (shouldShowSeeAllButton(
                                        pendingRequests)),
                                    seeAllButtonText: 'See All New Trips',
                                    nextView: AdminDashboardPendingTripsUI(
                                      shouldRefresh: true,
                                    ),
                                    pagination: canFetchMorePending,
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                  Text('Ongoing Trips',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  RequestsWidget(
                                    loading: _isLoading,
                                    fetch: _isFetched,
                                    errorText: 'No trip onging.',
                                    listWidget: acceptedRequests,
                                    fetchData: fetchConnectionRequests(),
                                    numberOfWidgets: 5,
                                    showSeeAllButton: (shouldShowSeeAllButton(
                                        acceptedRequests)),
                                    seeAllButtonText: 'See All Ongoing Trips',
                                    nextView: AdminDashboardOngoingTripsUI(
                                      shouldRefresh: true,
                                    ),
                                    pagination: canFetchMoreAccepted,
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                  Text('Pick-Drop Trips',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: screenHeight * 0.01),
                                  RequestsWidget(
                                    loading: _isLoading,
                                    fetch: _isFetched,
                                    errorText: 'No trip onging.',
                                    listWidget: acceptedRequests,
                                    fetchData: fetchConnectionRequests(),
                                    numberOfWidgets: 5,
                                    showSeeAllButton: (shouldShowSeeAllButton(
                                        acceptedRequests)),
                                    seeAllButtonText: 'See All Ongoing Trips',
                                    nextView: AdminDashboardOngoingTripsUI(
                                      shouldRefresh: true,
                                    ),
                                    pagination: canFetchMoreAccepted,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
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
                                        builder: (context) => AdminDashboardUI(
                                            shouldRefresh: true)));
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
                                        builder: (context) => const ProfileUI(
                                              shouldRefresh: true,
                                            )));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdvancedSearchUI(
                                            /*   shouldRefresh: true,*/
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
                                      Icons.search,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Search',
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
                    Navigator.of(context).pop();
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
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userName');
                    await prefs.remove('organizationName');
                    await prefs.remove('photoUrl');
                    var logoutApiService = await LogOutApiService.create();
                    logoutApiService.authToken;
                    if (await logoutApiService.signOut()) {
                      Navigator.pop(context);
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginUI()));
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
