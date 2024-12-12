import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/UI/Widgets/requestWidgetShowAll.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboardFull.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../../Data/Models/tripRequestModelApprovedStaff.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/staffTripTile.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Driver Dashboard/driverStopTrip.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// This class represents the user interface for displaying pending trips.
/// It manages the loading state, user profile retrieval, and connection requests fetching.
///
/// **Variables:**
/// - [shouldRefresh]: A boolean indicating whether the UI should refresh on load.
/// - [pendingRequests]: A list of widgets representing pending requests.
/// - [acceptedRequests]: A list of widgets representing accepted requests.
/// - [recentRequests]: A list of widgets representing recent requests.
/// - [_isFetched]: A boolean flag indicating if the data has been fetched.
/// - [_isFetchedFull]: A boolean flag indicating if all data has been fetched.
/// - [_isLoading]: A boolean flag indicating if the data is currently loading.
/// - [_pageLoading]: A boolean flag indicating if the page is loading.
/// - [_errorOccurred]: A boolean flag indicating if an error has occurred.
/// - [userName]: A string representing the name of the user.
/// - [organizationName]: A string representing the organization of the user.
/// - [photoUrl]: A string representing the user's photo URL.
/// - [notifications]: A list of strings representing notifications for the user.
/// - [acceptedPagination]: An object of type Pagination for managing pagination data.
/// - [canFetchMoreAccepted]: A boolean indicating if more accepted requests can be fetched.
/// - [acceptedNext]: A string representing the URL for the next page of accepted requests.
/// - [acceptedPrev]: A string representing the URL for the previous page of accepted requests.
///
/// **Actions:**
/// - [initState]: Initializes the state, retrieves user profile, and fetches requests.
/// - [build]: Builds the UI for the dashboard, including loading indicators and requests.
/// - [fetchProfile]: Fetches the user profile and updates the state.
/// - [fetchPendingRequests]: Fetches pending requests and updates the state.
/// - [fetchAcceptedRequests]: Fetches accepted requests and updates the state.
/// - [showErrorMessage]: Displays an error message to the user.
/// - [refresh]: Refreshes the data displayed in the dashboard.
class DriverDashboardPendingTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const DriverDashboardPendingTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<DriverDashboardPendingTripsUI> createState() =>
      _DriverDashboardPendingTripsUIState();
}

class _DriverDashboardPendingTripsUIState
    extends State<DriverDashboardPendingTripsUI> {
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
  late Pagination acceptedPagination;
  bool canFetchMoreAccepted = false;

  late String acceptedNext = '';
  late String acceptedPrev = '';

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
      ;
      acceptedPagination = Pagination.fromJson(pagination['new_trip']);

      print(acceptedPagination.nextPage);
      setState(() {
        acceptedNext = acceptedPagination.nextPage as String;
      });
      print(acceptedPagination.previousPage);
      setState(() {
        acceptedPrev = acceptedPagination.previousPage as String;
      });

      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      print(canFetchMoreAccepted);
      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> acceptedRequestsData = records['New_Trip'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverStopTripUI(
                  staff: ApprovedStaffTripRequest(
                    driver: request['driver'],
                    Car: request['car'],
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
                  ),
                ),
              ),
            );
            DriverStopTripUI(
              staff: ApprovedStaffTripRequest(
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
                  id: request['trip_id']),
            );
          },
        );
      }).toList();

      setState(() {
        acceptedRequests = acceptedWidgets;
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
      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItemsFull(url);
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
      acceptedPagination = Pagination.fromJson(pagination['new_trip']);

      print(acceptedPagination.nextPage);
      setState(() {
        acceptedNext = acceptedPagination.nextPage as String;
      });
      print(acceptedPagination.previousPage);
      setState(() {
        acceptedPrev = acceptedPagination.previousPage as String;
      });

      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      print(canFetchMoreAccepted);

      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> acceptedRequestsData = records['New_Trip'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverStopTripUI(
                  staff: ApprovedStaffTripRequest(
                    driver: request['driver'],
                    Car: request['car'],
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
                  ),
                ),
              ),
            );
            DriverStopTripUI(
              staff: ApprovedStaffTripRequest(
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
                  id: request['trip_id']),
            );
          },
        );
      }).toList();

      setState(() {
        acceptedRequests = acceptedWidgets;
        _isFetchedFull = true;
      });
    } catch (e) {
      print('Error fetching trip requests: $e');
      _isFetchedFull = true;
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    loadUserProfile();
    Future.delayed(Duration(seconds: 5), () {
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
                  child: Scaffold(
                    extendBody: true,
                    key: _scaffoldKey,
                    appBar: AppBar(
                      backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                      titleSpacing: 5,
                      automaticallyImplyLeading: false,
                      title: const Text(
                        'Driver Dashboard',
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
                                  if (acceptedRequests.isEmpty) ...[
                                    AllRequestsWidget(
                                      loading: _isLoading,
                                      fetch: _isFetched,
                                      errorText: 'No New Trip.',
                                      listWidget: pendingRequests,
                                      fetchData: fetchConnectionRequests(),
                                    ),
                                  ] else if (acceptedRequests.isNotEmpty) ...[
                                    buildNoRequestsWidget(screenWidth,
                                        'You Currently on a Trip. Please complete that trip to start a new trip.')
                                  ],
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              (acceptedPrev.isNotEmpty &&
                                                      acceptedPrev != 'None' &&
                                                      _isLoading)
                                                  ? const Color.fromRGBO(
                                                      25, 192, 122, 1)
                                                  : Colors.grey,
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
                                        onPressed: (acceptedPrev.isNotEmpty &&
                                                acceptedPrev != 'None' &&
                                                _isLoading)
                                            ? () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Loading...'),
                                                  ),
                                                );
                                                print('Prev: $acceptedPrev');
                                                setState(() {
                                                  _isFetchedFull = false;
                                                  fetchConnectionRequestsPagination(
                                                      acceptedPrev);
                                                  acceptedPrev = '';
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
                                          backgroundColor:
                                              (acceptedNext.isNotEmpty &&
                                                      acceptedNext != 'None' &&
                                                      _isLoading)
                                                  ? const Color.fromRGBO(
                                                      25, 192, 122, 1)
                                                  : Colors.grey,
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
                                        onPressed: (acceptedNext.isNotEmpty &&
                                                acceptedNext != 'None' &&
                                                _isLoading)
                                            ? () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Loading...'),
                                                  ),
                                                );
                                                print('Next: $acceptedNext');
                                                setState(() {
                                                  _isFetchedFull = false;
                                                  fetchConnectionRequestsPagination(
                                                      acceptedNext);
                                                  acceptedNext = '';
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                            DriverDashboardPendingTripsUI(
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
                                  color: const Color.fromRGBO(25, 192, 122, 1),
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
                          MaterialPageRoute(builder: (context) => LoginwithEmailUI()));
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
