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
import '../../Widgets/StaffApprovedTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Trip Request Form(Staff)/triprequestformUI.dart';

/// The [StaffDashboardAcceptedTripsUI] class represents a dashboard
/// UI for staff members to view accepted trip requests. It manages
/// the display of pending and accepted trip requests, user profile
/// loading, and pagination for trip request data.
///
/// Variables:
/// - [shouldRefresh]: A boolean indicating whether the dashboard should refresh.
///
/// Actions:
/// - [loadUserProfile]: Loads the user profile from shared preferences.
/// - [fetchConnectionRequests]: Fetches the initial connection requests data.
/// - [fetchConnectionRequestsPagination(url)]: Fetches paginated connection requests data.
///
/// State Management:
/// - [pendingRequests]: A list of widgets representing pending requests.
/// - [acceptedRequests]: A list of widgets representing accepted requests.
/// - [recentRequests]: A list of widgets representing recent requests.
/// - [_isFetched]: A boolean indicating if data has been fetched.
/// - [_isFetchedFull]: A boolean indicating if full data has been fetched.
/// - [_isLoading]: A boolean indicating if data is currently being loaded.
/// - [_pageLoading]: A boolean indicating if the page is loading.
/// - [_errorOccurred]: A boolean indicating if an error occurred during fetching.
/// - [userName]: A string representing the user's name.
/// - [organizationName]: A string representing the user's organization name.
/// - [photoUrl]: A string representing the URL of the user's photo.
/// - [notifications]: A list of strings representing notifications for the user.
/// - [acceptedPagination]: A [Pagination] object for managing pagination of accepted requests.
/// - [canFetchMoreAccepted]: A boolean indicating if more accepted requests can be fetched.
/// - [acceptedNext]: A string representing the URL for the next page of accepted requests.
/// - [acceptedPrev]: A string representing the URL for the previous page of accepted requests.
class StaffDashboardAcceptedTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const StaffDashboardAcceptedTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<StaffDashboardAcceptedTripsUI> createState() =>
      _StaffDashboardAcceptedTripsUIState();
}

class _StaffDashboardAcceptedTripsUIState
    extends State<StaffDashboardAcceptedTripsUI> {
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
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
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
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovedStaffTrip(
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
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
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
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovedStaffTrip(
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
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    if (!_isFetched) {
      fetchConnectionRequests();
    }
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
                                  Text('Approved Trip',
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
                                    errorText: 'No trip request reviewed yet.',
                                    listWidget: acceptedRequests,
                                    fetchData: fetchConnectionRequests(),
                                  ),
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
                                          StaffDashboardAcceptedTripsUI(
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
