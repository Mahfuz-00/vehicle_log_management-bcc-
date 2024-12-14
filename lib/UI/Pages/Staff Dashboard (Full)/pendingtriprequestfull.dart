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
import '../../../Data/Models/triprequestfetchModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/staffPendingTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Trip Request Form(Staff)/triprequestformUI.dart';

/// This class represents the [StaffDashboardPendingTripsUI], which displays
/// the pending trips for staff members. It fetches user profile information
/// and connection requests from the API and displays them in a list format.
///
/// Variables:
/// - [shouldRefresh]: A boolean indicating whether the UI should refresh.
/// - [_scaffoldKey]: A global key used for the Scaffold widget.
/// - [pendingRequests]: A list of widgets representing pending trip requests.
/// - [acceptedRequests]: A list of widgets representing accepted trip requests.
/// - [recentRequests]: A list of widgets representing recent trip requests.
/// - [_isFetched]: A boolean indicating whether the trip requests have been fetched.
/// - [_isFetchedFull]: A boolean indicating whether all trip requests have been fetched.
/// - [_isLoading]: A boolean indicating whether data is being loaded.
/// - [_pageLoading]: A boolean indicating whether the page is still loading.
/// - [_buttonpressed]: A boolean indicating whether a button has been pressed.
/// - [_errorOccurred]: A boolean indicating whether an error has occurred during fetching.
/// - [userName]: A string holding the name of the user.
/// - [organizationName]: A string holding the organization name of the user.
/// - [photoUrl]: A string holding the URL of the user's profile photo.
/// - [notifications]: A list of strings containing notifications for the user.
/// - [pendingPagination]: An instance of the [Pagination] model for pending requests.
/// - [acceptedPagination]: An instance of the [Pagination] model for accepted requests.
/// - [recentPagination]: An instance of the [Pagination] model for recent requests.
/// - [canFetchMorePending]: A boolean indicating if more pending requests can be fetched.
/// - [canFetchMoreAccepted]: A boolean indicating if more accepted requests can be fetched.
/// - [canFetchMoreRecent]: A boolean indicating if more recent requests can be fetched.
/// - [pendingNext]: A string holding the URL for the next page of pending requests.
/// - [acceptedNext]: A string holding the URL for the next page of accepted requests.
/// - [recentNext]: A string holding the URL for the next page of recent requests.
/// - [pendingPrev]: A string holding the URL for the previous page of pending requests.
/// - [acceptedPrev]: A string holding the URL for the previous page of accepted requests.
/// - [recentPrev]: A string holding the URL for the previous page of recent requests.
///
/// Actions:
/// - [loadUserProfile()]: Fetches user profile information from SharedPreferences.
/// - [fetchConnectionRequests()]: Fetches the initial set of connection requests.
/// - [fetchConnectionRequestsPagination(String url)]: Fetches additional connection requests based on pagination.
class StaffDashboardPendingTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const StaffDashboardPendingTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<StaffDashboardPendingTripsUI> createState() =>
      _StaffDashboardPendingTripsUIState();
}

class _StaffDashboardPendingTripsUIState
    extends State<StaffDashboardPendingTripsUI> {
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
            type: request['trip_type'],
            route: request['route_name'],
            stoppage: request['stoppage_name'],
            startMonth: request['start_month_and_year'],
            endMonth: request['end_month_and_year'],
          ),
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
            type: request['trip_type'],
            route: request['route_name'],
            stoppage: request['stoppage_name'],
            startMonth: request['start_month_and_year'],
            endMonth: request['end_month_and_year'],
          ),
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

      setState(() {
        pendingRequests = pendingWidgets;
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
    pendingPagination = Pagination(nextPage: null, previousPage: null);
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
    recentPagination = Pagination(nextPage: null, previousPage: null);
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    print('initState called');
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
                              builder: (context) => LoginwithEmailUI()));
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
