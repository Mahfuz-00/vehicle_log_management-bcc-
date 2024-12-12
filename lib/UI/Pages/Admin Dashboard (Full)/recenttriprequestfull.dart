import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_log_management/UI/Bloc/auth_cubit.dart';
import 'package:vehicle_log_management/UI/Widgets/requestWidgetShowAll.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboardFull.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../Data/Models/tripRequestModel.dart';
import '../../../Data/Models/tripRequestModelRecent.dart';
import '../../Widgets/AvailableDriverDetails.dart';
import '../../Widgets/RecentTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// The [AdminDashboardRecentTripsUI] widget represents the user interface
/// for displaying recent trip information on the Admin Dashboard.
///
/// [shouldRefresh]: Determines if the UI should refresh the data upon loading.
///
/// Variables:
/// * [_scaffoldKey]: Key for managing the scaffold state.
/// * [pendingRequests]: Holds the list of widgets representing pending requests.
/// * [acceptedRequests]: Holds the list of widgets representing accepted requests.
/// * [recentRequests]: Holds the list of widgets representing recent requests.
/// * [drivers]: Holds the list of widgets representing driver details.
/// * [_isFetched]: Tracks whether the data has been fetched to avoid redundant calls.
/// * [_isFetchedFull]: Tracks whether the full data has been fetched.
/// * [_isLoading]: Indicates whether data loading is currently in progress.
/// * [_pageLoading]: Indicates whether the initial page loading is ongoing.
/// * [_errorOccurred]: Tracks if an error occurred during data fetching.
/// * [userName]: Stores the name of the user fetched from SharedPreferences.
/// * [organizationName]: Stores the organization name fetched from SharedPreferences.
/// * [photoUrl]: Stores the URL of the user's photo fetched from SharedPreferences.
/// * [notifications]: Holds the list of notifications fetched from the API.
/// * [recentPagination]: Stores pagination information for recent trips.
/// * [canFetchMoreRecent]: Indicates if more recent trips can be fetched.
/// * [recentNext]: Stores the URL for fetching the next page of recent trips.
/// * [recentPrev]: Stores the URL for fetching the previous page of recent trips.
///
/// Actions:
/// * [loadUserProfile]: Fetches and sets the user's profile information from SharedPreferences.
/// * [fetchConnectionRequests]: Fetches connection requests and updates the UI accordingly.
/// * [fetchConnectionRequestsPagination(String url)]: Fetches paginated data for recent trips.
class AdminDashboardRecentTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const AdminDashboardRecentTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AdminDashboardRecentTripsUI> createState() =>
      _AdminDashboardRecentTripsUIState();
}

class _AdminDashboardRecentTripsUIState
    extends State<AdminDashboardRecentTripsUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> recentRequests = [];
  List<Widget> drivers = [];
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

      recentPagination = Pagination.fromJson(pagination['Recent']);
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

      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Pending Request at index $index: ${recentTripData[index]}\n');
      }

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
      recentPagination = Pagination.fromJson(pagination['Recent']);
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

      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Pending Request at index $index: ${recentTripData[index]}\n');
      }

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
        recentRequests = recentWidgets;
        _isFetched = true;
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
    recentPagination = Pagination(nextPage: null, previousPage: null);
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
                        'Admin Dashboard',
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
                              horizontal: 20, vertical: 20),
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
                                  errorText: 'No Recent Trip.',
                                  listWidget: recentRequests,
                                  fetchData: fetchConnectionRequests(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            (recentPrev.isNotEmpty &&
                                                    recentPrev != 'None' &&
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
                                      onPressed: (recentPrev.isNotEmpty &&
                                              recentPrev != 'None' &&
                                              _isLoading)
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
                                                fetchConnectionRequestsPagination(
                                                    recentPrev);
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
                                        backgroundColor:
                                            (recentNext.isNotEmpty &&
                                                    recentNext != 'None' &&
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
                                      onPressed: (recentNext.isNotEmpty &&
                                              recentNext != 'None' &&
                                              _isLoading)
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
                                                fetchConnectionRequestsPagination(
                                                    recentNext);
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
                                          AdminDashboardRecentTripsUI(
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
