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
import '../../Widgets/AvailableDriverDetails.dart';
import '../../Widgets/OngoingTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// This class [AdminDashboardOngoingTripsUI] manages the UI for displaying ongoing trips in the admin dashboard.
/// It includes functionalities for fetching user profile details and ongoing trip requests, handling pagination,
/// and displaying a loading state until the data is fetched.
///
/// [shouldRefresh]: A [bool] that indicates whether the dashboard should refresh its content.
///
/// State Variables:
/// - [_scaffoldKey]: A [GlobalKey] for the Scaffold widget to control its state.
/// - [pendingRequests]: A List<Widget> holding the widgets for pending requests.
/// - [acceptedRequests]: A List<Widget> containing the widgets for accepted requests.
/// - [recentRequests]: A List<Widget> for the recent requests.
/// - [drivers]: A List<Widget> that holds driver-related widgets.
/// - [_isFetched]: A bool indicating if the data has been fetched.
/// - [_isFetchedFull]: A bool indicating if all paginated data has been fetched.
/// - [_isLoading]: A bool representing whether the data is still loading.
/// - [_pageLoading]: A bool that shows whether the entire page is loading.
/// - [_errorOccurred]: A bool indicating if an error occurred during data fetching.
/// - [photoUrl]: A String with the user's profile photo URL.
/// - [notifications]: A List<String> of notifications fetched from the server.
/// - [acceptedPagination]: A [Pagination] object managing pagination for accepted requests.
/// - [canFetchMoreAccepted]: A bool that determines if more accepted requests can be fetched.
/// - [acceptedNext]: A String storing the next page URL for accepted requests.
/// - [acceptedPrev]: A String storing the previous page URL for accepted requests.
///
/// [loadUserProfile]: An async function to load user profile details from SharedPreferences.
///
/// [fetchConnectionRequests]: An async function to fetch ongoing trip requests from the API. It handles
/// loading states and updates the UI with the fetched data.
///
/// [fetchConnectionRequestsPagination]: An async function to handle pagination when fetching ongoing trip requests.
class AdminDashboardOngoingTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const AdminDashboardOngoingTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AdminDashboardOngoingTripsUI> createState() =>
      _AdminDashboardOngoingTripsUIState();
}

class _AdminDashboardOngoingTripsUIState
    extends State<AdminDashboardOngoingTripsUI> {
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

      final List<dynamic> acceptedRequestsData = records['Ongoing'] ?? [];
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
        drivers = driverWidgets;
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

      final List<dynamic> acceptedRequestsData = records['Ongoing'] ?? [];
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
        drivers = driverWidgets;
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
                                Text('Ongoing Trip',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      fontFamily: 'default',
                                    )),
                                SizedBox(height: screenHeight * 0.01),
                                AllRequestsWidget(
                                  loading: _isLoading,
                                  fetch: _isFetched,
                                  errorText: 'No trip onging.',
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
                                      builder: (context) =>
                                          AdminDashboardOngoingTripsUI(
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
