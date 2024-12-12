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
import '../../../Data/Models/tripRequestModelOngingTrip.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/OngoingTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// The [SROfficerDashboardOngoingTripsUI] class represents the user interface
/// for the ongoing trips dashboard for a Senior Officer. It manages the
/// loading and displaying of ongoing trip requests and user profile details.
///
/// **Constructor:**
/// - [SROfficerDashboardOngoingTripsUI]: Initializes the widget with an optional
///   parameter [shouldRefresh] to control refresh behavior.
///
/// **State Variables:**
/// - [shouldRefresh]: A boolean indicating whether the dashboard should refresh.
/// - [_scaffoldKey]: A key for the scaffold to manage the state of the widget.
/// - [pendingRequests]: A list of widgets representing pending trip requests.
/// - [acceptedRequests]: A list of widgets representing accepted trip requests.
/// - [_isFetched]: A boolean indicating whether the data has been fetched.
/// - [_isFetchedFull]: A boolean indicating whether all data has been fetched.
/// - [_isLoading]: A boolean indicating whether the data is currently loading.
/// - [_pageLoading]: A boolean indicating whether the page is currently loading.
/// - [_errorOccurred]: A boolean indicating whether an error occurred during data fetch.
/// - [userName]: A string representing the user's name.
/// - [organizationName]: A string representing the user's organization name.
/// - [photoUrl]: A string representing the URL to the user's photo.
/// - [notifications]: A list of strings representing notifications for the user.
/// - [acceptedPagination]: An instance of [Pagination] containing pagination details.
/// - [canFetchMoreAccepted]: A boolean indicating whether more accepted requests can be fetched.
/// - [acceptedNext]: A string representing the URL for the next page of accepted requests.
/// - [acceptedPrev]: A string representing the URL for the previous page of accepted requests.
///
/// **Methods:**
/// - [loadUserProfile]: Loads the user's profile data from shared preferences.
/// - [fetchConnectionRequests]: Fetches ongoing trip requests from the dashboard API.
/// - [fetchConnectionRequestsPagination]: Fetches paginated ongoing trip requests from the dashboard API.
class SROfficerDashboardOngoingTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const SROfficerDashboardOngoingTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<SROfficerDashboardOngoingTripsUI> createState() =>
      _SROfficerDashboardOngoingTripsUIState();
}

class _SROfficerDashboardOngoingTripsUIState
    extends State<SROfficerDashboardOngoingTripsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
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

      acceptedPagination = Pagination.fromJson(pagination['ongoing']);

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
              type: request['trip_type'],
            route: request['route_name'],
            stoppage: request['stoppage_name'],
            startMonth: request['start_month_and_year'],
            endMonth: request['end_month_and_year'],),
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
      acceptedPagination = Pagination.fromJson(pagination['ongoing']);

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
              type: request['trip_type'],route: request['route_name'],
            stoppage: request['stoppage_name'],
            startMonth: request['start_month_and_year'],
            endMonth: request['end_month_and_year'],),
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
                    startTrip: request['start'],
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
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    print('initState called');
    loadUserProfile();
    if (!_isFetched) {
      fetchConnectionRequests();
    }
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
                        'Sr Officer Dashboard',
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
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20),
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
                                Text('Ongoing Trip',
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
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                            MediaQuery.of(context).size.height *
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
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                            MediaQuery.of(context).size.height *
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
                                          SROfficerDashboardOngoingTripsUI()));
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
