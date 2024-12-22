import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/UI/Pages/Driver%20Dashboard%20(Full)/pendingtriprequestfull.dart';
import 'package:vehicle_log_management/UI/Pages/Driver%20Dashboard%20(Full)/recenttriprequestfull.dart';
import 'package:vehicle_log_management/UI/Widgets/recentPickDropTripDetails.dart';
import 'package:vehicle_log_management/UI/Widgets/requestWidget.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/driverstaffModel.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../../Data/Models/tripRequestModelRecent.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/RecentTripDetails.dart';
import '../../Widgets/driverTripTile.dart';
import '../../Widgets/staffTripTile.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import 'driverPickDropStartTrip.dart';
import 'driverPickDropStopTrip.dart';
import 'driverStartTrip.dart';
import 'driverStopTrip.dart';

/// This widget represents the [DriverDashboardUI] where drivers can view and interact with trip requests.
///
/// **Parameters:**
/// - **[shouldRefresh]:** A bool flag to determine if the UI should be refreshed upon initialization.
///
/// **Widgets:**
/// - **[_scaffoldKey]:** A GlobalKey for controlling the Scaffold state.
/// - **[pendingRequests]:** A List of Widgets representing pending trip requests.
/// - **[acceptedRequests]:** A List of Widgets representing accepted trip requests.
/// - **[recentRequests]:** A List of Widgets representing recent trip requests.
///
/// **State Variables:**
/// - **[_isFetched]:** A bool flag indicating whether the trip requests have been fetched.
/// - **[_isLoading]:** A bool flag indicating whether data is being loaded.
/// - **[_pageLoading]:** A bool flag indicating if the page is in the loading state.
/// - **[_errorOccurred]:** A bool flag indicating if an error occurred during data fetch.
/// - **[userName]:** A String to store the name of the logged-in user.
/// - **[organizationName]:** A String to store the organization name of the logged-in user.
/// - **[photoUrl]:** A String to store the URL of the user's profile photo.
/// - **[notifications]:** A List of Strings representing notifications.
/// - **[pendingPagination]:** A [Pagination] object handling pagination for pending trip requests.
/// - **[acceptedPagination]:** A [Pagination] object handling pagination for accepted trip requests.
/// - **[recentPagination]:** A [Pagination] object handling pagination for recent trip requests.
/// - **[canFetchMorePending]:** A bool flag indicating if more pending requests can be fetched.
/// - **[canFetchMoreAccepted]:** A bool flag indicating if more accepted requests can be fetched.
/// - **[canFetchMoreRecent]:** A bool flag indicating if more recent requests can be fetched.
class DriverDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const DriverDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<DriverDashboardUI> createState() => _DriverDashboardUIState();
}

class _DriverDashboardUIState extends State<DriverDashboardUI>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> recentRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  List<Widget> pendingPickDropRequests = [];
  List<Widget> acceptedPickDropRequests = [];
  List<Widget> recentPickDropRequests = [];
  bool _isPickDropFetched = false;
  bool _isPickDropLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];
  late Pagination pendingPagination;
  late Pagination acceptedPagination;
  late Pagination recentPagination;
  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;
  bool canFetchMoreRecent = false;
  late Pagination pendingPickDropPagination;
  late Pagination acceptedPickDropPagination;
  late Pagination recentPickDropPagination;
  bool canPickDropFetchMorePending = false;
  bool canPickDropFetchMoreAccepted = false;
  bool canPickDropFetchMoreRecent = false;
  late TabController _tabController;

  bool hasNewTripInRegularTab = false; // Tracks new trips in the Regular tab
  bool hasNewTripInPickDropTab = false; // Tracks new trips in the Pick-Drop tab

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
      recentPagination = Pagination.fromJson(pagination['recent']);
      print(pendingPagination.nextPage);
      print(acceptedPagination.previousPage);
      print(recentPagination);

      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreRecent = recentPagination.canFetchNext;

      notifications = List<String>.from(records['notifications'] ?? []);

      await Future.delayed(Duration(seconds: 3));

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
        print('Recent Trip at index $index: ${recentTripData[index]}\n');
      }

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        setState(() {
          hasNewTripInRegularTab = true;
        });
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
          staff: TripRequestSubmit(
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
                builder: (context) => DriverStartTripUI(
                  staff: ApprovedStaffModel(
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
                    type: request['trip_type'],
                    route: request['route_name'],
                    stoppage: request['stoppage_name'],
                    startMonth: request['start_month_and_year'],
                    endMonth: request['end_month_and_year'],
                  ),
                ),
              ),
            );
          },
        );
      }).toList();

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return StaffTile(
          staff: TripRequestSubmit(
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverStopTripUI(
                  staff: ApprovedStaffModel(
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
                    type: request['trip_type'],
                    route: request['route_name'],
                    stoppage: request['stoppage_name'],
                    startMonth: request['start_month_and_year'],
                    endMonth: request['end_month_and_year'],
                  ),
                ),
              ),
            );
            DriverStopTripUI(
              staff: ApprovedStaffModel(
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
                type: request['trip_type'],
                route: request['route_name'],
                stoppage: request['stoppage_name'],
                startMonth: request['start_month_and_year'],
                endMonth: request['end_month_and_year'],
              ),
            );
          },
        );
      }).toList();

      final List<Widget> recentWidgets = recentTripData.map((request) {
        return StaffTile(
          staff: TripRequestSubmit(
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
                    DateTime: request['date_time'],
                    Driver: request['driver'],
                    Car: request['car'],
                    Duration: request['duration'],
                    Start: request['start'],
                    route: request['route_name'],
                    stoppage: request['stoppage_name'],
                    startMonth: request['start_month_and_year'],
                    endMonth: request['end_month_and_year'],
                  ),
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
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

  Future<void> fetchPickDropConnectionRequests() async {
    print('Pick drop connection requests Invoking');
    if (_isPickDropFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print('Dashboard: $dashboardData');
      print('Top-level keys: ${dashboardData.keys}');
      print('Records key: ${dashboardData['records']}');
      if (dashboardData['records'] != null) {
        print('Records keys: ${dashboardData['records'].keys}');
        print('Pick_New_Trip: ${dashboardData['records']['Pick_New_Trip']}');
      } else {
        print('Records key is null');
      }

      final dynamic? records = dashboardData['records'] ?? [];
      print('Records : $records');
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      /*  final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPickDropPagination = Pagination.fromJson(pagination['new_trip']);
      recentPickDropPagination = Pagination.fromJson(pagination['recent']);
      print(pendingPickDropPagination.nextPage);
      print(acceptedPickDropPagination.previousPage);
      print(recentPickDropPagination);

      canPickDropFetchMorePending = pendingPickDropPagination.canFetchNext;
      canPickDropFetchMoreRecent = recentPickDropPagination.canFetchNext;*/

      notifications = List<String>.from(records['notifications'] ?? []);

      await Future.delayed(Duration(seconds: 3));

      final List<dynamic> pendingRequestsData = records['Pick_New_Trip'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pick Drop New Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Pick_Ongoing'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }
      final List<dynamic> recentTripData = records['Pick_Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Recent Trip at index $index: ${recentTripData[index]}\n');
      }

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        setState(() {
          hasNewTripInPickDropTab = true;
          print('New Trip in pick drop tab. Press enter to continue...');
        });
        return DriverTile(
          staff: DriveTripRoute(
              name: request['name'],
              date: request['date'],
              startTime: request['start_time'],
              endTime: request['end_time'],
              routeId: request['route_id'],
              stoppages: request['stoppages']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DriverPickDropStartTripUI(
                  staff: DriveTripRoute(
                      name: request['name'],
                      date: request['date'],
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      routeId: request['route_id'],
                      stoppages: request['stoppages']),
                ),
              ),
            );
          },
        );
      }).toList();

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return DriverTile(
          staff: DriveTripRoute(
              name: request['name'],
              date: request['date'],
              startTime: request['start_time'],
              endTime: request['end_time'],
              routeId: request['route_id'],
              stoppages: request['stoppages']),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverPickDropStopTripUI(
                  staff: DriveTripRoute(
                      name: request['name'],
                      date: request['date'],
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      routeId: request['route_id'],
                      stoppages: request['stoppages']),
                ),
              ),
            );
            /*DriverStopTripUI(
              staff: ApprovedStaffModel(
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
                type: request['trip_type'],
                route: request['route_name'],
                stoppage: request['stoppage_name'],
                startMonth: request['start_month_and_year'],
                endMonth: request['end_month_and_year'],),
            );*/
          },
        );
      }).toList();

      final List<Widget> recentWidgets = recentTripData.map((request) {
        return DriverTile(
          staff: DriveTripRoute(
              name: request['name'],
              date: request['date'],
              startTime: request['start_time'],
              endTime: request['end_time'],
              routeId: request['route_id'],
              stoppages: request['stoppages']),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecentPickDropTripDetails(
                  staff: DriveTripRoute(
                      name: request['name'],
                      date: request['date'],
                      startTime: request['start_time'],
                      endTime: request['end_time'],
                      routeId: request['route_id'],
                      stoppages: request['stoppages']),
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
        pendingPickDropRequests = pendingWidgets;
        acceptedPickDropRequests = acceptedWidgets;
        recentPickDropRequests = recentWidgets;
        _isPickDropFetched = true;
      });
    } catch (e) {
      print('Error fetching PickDrop trip requests: $e');
      _isPickDropFetched = true;
    }
  }

  /*void checkNewTrips() {
    // Logic to update trip states (e.g., API call results)
    setState(() {
      hasNewTripInRegularTab = false; // Replace with actual check
      hasNewTripInPickDropTab = false; // Example: no trips in Pick-Drop tab
    });
  }*/

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //checkNewTrips();
    print('initState called');
    pendingPagination = Pagination(nextPage: null, previousPage: null);
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    recentPagination = Pagination(nextPage: null, previousPage: null);
    loadUserProfile();
    if (!_isFetched && !_isPickDropFetched) {
      fetchConnectionRequests();
      fetchPickDropConnectionRequests();
    }
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fabHeight = 56.0;
    double containerHeight = screenHeight * 0.08;

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
                      extendBody: true,
                      key: _scaffoldKey,
                      appBar: AppBar(
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        titleSpacing: 5,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: EdgeInsets.only(left: screenWidth*0.05),
                          child: const Text(
                            'Driver Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                        //centerTitle: true,
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
                        bottom: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[300],
                          indicatorColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'default',
                          ),
                          tabs: const [
                            Tab(
                              text: 'Regular Trip',
                            ),
                            Tab(text: 'Pick-Drop Trip'),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          // Regular trip tab content
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                              'Welcome, ${userProfile.name}',
                                              textAlign: TextAlign.center,
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
                                        Text('New Trip',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              fontFamily: 'default',
                                            )),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.01),
                                        if (hasNewTripInPickDropTab) ...[
                                          buildNoRequestsWidget(screenWidth,
                                              'New Trip in Pick-Drop Trip Tab')
                                        ] else if (acceptedRequests
                                            .isEmpty) ...[
                                          RequestsWidget(
                                            loading: _isLoading,
                                            fetch: _isFetched,
                                            errorText: 'No New Trip.',
                                            listWidget: pendingRequests,
                                            fetchData:
                                                fetchConnectionRequests(),
                                            numberOfWidgets: 5,
                                            showSeeAllButton:
                                                canFetchMorePending,
                                            seeAllButtonText:
                                                'See All New Trips',
                                            nextView:
                                                DriverDashboardPendingTripsUI(
                                              shouldRefresh: true,
                                            ),
                                            pagination: canFetchMorePending,
                                          ),
                                        ] else if (acceptedRequests
                                            .isNotEmpty) ...[
                                          buildNoRequestsWidget(screenWidth,
                                              'You Currently on a Trip. Please complete that trip to start a new trip.')
                                        ],
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.02),
                                        Text('Ongoing Trip',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              fontFamily: 'default',
                                            )),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.01),
                                        RequestsWidget(
                                          loading: _isLoading,
                                          fetch: _isFetched,
                                          errorText: 'No trip onging.',
                                          listWidget: acceptedRequests,
                                          fetchData: fetchConnectionRequests(),
                                          numberOfWidgets: 10,
                                          showSeeAllButton:
                                              canFetchMoreAccepted,
                                          seeAllButtonText: '',
                                          nextView: null,
                                          pagination: canFetchMoreAccepted,
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
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
                                        SizedBox(height: screenHeight * 0.01),
                                        RequestsWidget(
                                          loading: _isLoading,
                                          fetch: _isFetched,
                                          errorText:
                                              'You haven\'t finished any trip yet.',
                                          listWidget: recentRequests,
                                          fetchData: fetchConnectionRequests(),
                                          numberOfWidgets: 5,
                                          showSeeAllButton: canFetchMoreRecent,
                                          seeAllButtonText:
                                              'See All Recent Trips',
                                          nextView:
                                              DriverDashboardRecentTripsUI(
                                            shouldRefresh: true,
                                          ),
                                          pagination: canFetchMoreRecent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Pick-Drop trip tab content
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                              'Welcome, ${userProfile.name}',
                                              textAlign: TextAlign.center,
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
                                        Text('New Pick-Drop Trip',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              fontFamily: 'default',
                                            )),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.01),
                                        if (hasNewTripInRegularTab) ...[
                                          buildNoRequestsWidget(screenWidth,
                                              'New Trip in Regular Trip Tab')
                                        ] else if (acceptedPickDropRequests
                                            .isEmpty) ...[
                                          RequestsWidget(
                                            loading: _isPickDropLoading,
                                            fetch: _isPickDropFetched,
                                            errorText: 'No New Pick-Drop Trip.',
                                            listWidget: pendingPickDropRequests,
                                            fetchData:
                                                fetchPickDropConnectionRequests(),
                                            numberOfWidgets: 5,
                                            showSeeAllButton:
                                                canPickDropFetchMorePending,
                                            seeAllButtonText:
                                                'See All New Pick-Drop Trips',
                                            nextView:
                                                DriverDashboardPendingTripsUI(
                                              shouldRefresh: true,
                                            ),
                                            pagination:
                                                canPickDropFetchMorePending,
                                          ),
                                        ] else if (acceptedPickDropRequests
                                            .isNotEmpty) ...[
                                          buildNoRequestsWidget(screenWidth,
                                              'You Currently on a Trip. Please complete that trip to start a new trip.')
                                        ],
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.02),
                                        Text('Ongoing Pick-Drop Trip',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              fontFamily: 'default',
                                            )),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.01),
                                        RequestsWidget(
                                          loading: _isPickDropLoading,
                                          fetch: _isPickDropFetched,
                                          errorText:
                                              'No Ongoing Pick-Drop Trip.',
                                          listWidget: acceptedPickDropRequests,
                                          fetchData:
                                              fetchPickDropConnectionRequests(),
                                          numberOfWidgets: 10,
                                          showSeeAllButton:
                                              canPickDropFetchMoreAccepted,
                                          seeAllButtonText: '',
                                          nextView: null,
                                          pagination:
                                              canPickDropFetchMoreAccepted,
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.02),
                                        Text('Last 5 Pick-Drop Trip',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              fontFamily: 'default',
                                            )),
                                        SizedBox(height: screenHeight * 0.01),
                                        Divider(),
                                        SizedBox(height: screenHeight * 0.01),
                                        RequestsWidget(
                                          loading: _isPickDropLoading,
                                          fetch: _isPickDropFetched,
                                          errorText:
                                              'You haven\'t finished any Pick-Drop trip yet.',
                                          listWidget: recentPickDropRequests,
                                          fetchData:
                                              fetchPickDropConnectionRequests(),
                                          numberOfWidgets: 10,
                                          showSeeAllButton:
                                              canPickDropFetchMoreRecent,
                                          seeAllButtonText:
                                              'See All Pick-Drop Recent Trips',
                                          nextView:
                                              DriverDashboardRecentTripsUI(
                                            shouldRefresh: true,
                                          ),
                                          pagination:
                                              canPickDropFetchMoreRecent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                                          builder: (context) =>
                                              DriverDashboardUI(
                                                shouldRefresh: true,
                                              )));
                                },
                                child: Container(
                                  width: screenWidth / 3,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
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
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileUI(
                                                shouldRefresh: true,
                                              )));
                                },
                                child: Container(
                                  width: screenWidth / 3,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
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
                                onTap: () {
                                  _showLogoutDialog(context);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(25, 192, 122, 1),
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
                                        Icons.logout,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Log Out',
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginUI()));
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
