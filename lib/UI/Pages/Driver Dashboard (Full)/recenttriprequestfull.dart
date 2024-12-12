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
import '../../../Data/Models/tripRequestModelRecent.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/RecentTripDetails.dart';
import '../../Widgets/staffTripTile.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// [DriverDashboardRecentTripsUI] is a StatefulWidget that represents
/// the user interface for the driver's dashboard, displaying recent trips.
///
/// Variables:
/// - [shouldRefresh]: A boolean indicating whether the UI should refresh
///   upon initialization.
///
/// State Class Variables:
/// - [_scaffoldKey]: A GlobalKey for the Scaffold widget.
/// - [pendingRequests]: A list of widgets representing pending trip requests.
/// - [acceptedRequests]: A list of widgets representing accepted trip requests.
/// - [recentRequests]: A list of widgets representing recent trip requests.
/// - [_isFetched]: A boolean indicating whether the initial data has been fetched.
/// - [_isFetchedFull]: A boolean indicating whether the full data has been fetched.
/// - [_isLoading]: A boolean indicating whether data is currently being loaded.
/// - [_pageLoading]: A boolean indicating whether the page is currently loading.
/// - [_errorOccurred]: A boolean indicating whether an error has occurred during data fetching.
/// - [userName]: A string representing the user's name.
/// - [organizationName]: A string representing the user's organization name.
/// - [photoUrl]: A string representing the user's profile photo URL.
/// - [notifications]: A list of notifications received.
/// - [pendingPagination]: A Pagination object for pending requests.
/// - [acceptedPagination]: A Pagination object for accepted requests.
/// - [recentPagination]: A Pagination object for recent requests.
/// - [canFetchMorePending]: A boolean indicating if more pending requests can be fetched.
/// - [canFetchMoreAccepted]: A boolean indicating if more accepted requests can be fetched.
/// - [canFetchMoreRecent]: A boolean indicating if more recent requests can be fetched.
/// - [pendingNext]: A string for the next page URL for pending requests.
/// - [acceptedNext]: A string for the next page URL for accepted requests.
/// - [recentNext]: A string for the next page URL for recent requests.
/// - [pendingPrev]: A string for the previous page URL for pending requests.
/// - [acceptedPrev]: A string for the previous page URL for accepted requests.
/// - [recentPrev]: A string for the previous page URL for recent requests.
///
/// Actions:
/// - [loadUserProfile]: Loads user profile information from SharedPreferences.
/// - [fetchConnectionRequests]: Fetches the initial connection requests data.
/// - [fetchConnectionRequestsPagination(url)]: Fetches paginated connection requests data.
/// - [initState]: Initializes the state of the widget, loading user profile and fetching data.
class DriverDashboardRecentTripsUI extends StatefulWidget {
  final bool shouldRefresh;

  const DriverDashboardRecentTripsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<DriverDashboardRecentTripsUI> createState() => _DriverDashboardRecentTripsUIState();
}

class _DriverDashboardRecentTripsUIState extends State<DriverDashboardRecentTripsUI> {
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

      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Recent Trip at index $index: ${recentTripData[index]}\n');
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

      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> recentTripData = records['Recent'] ?? [];
      for (var index = 0; index < recentTripData.length; index++) {
        print('Recent Trip at index $index: ${recentTripData[index]}\n');
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
        recentRequests = recentWidgets;
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
    recentPagination = Pagination(nextPage: null, previousPage: null);
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    print('initState called');
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

    double fabHeight =
    56.0;
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                            AllRequestsWidget(
                              loading: _isLoading,
                              fetch: _isFetched,
                              errorText: 'You haven\'t finished any trip yet.',
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
                                        : Colors.grey,
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
                                        : Colors.grey,
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
                                  builder: (context) => DriverDashboardRecentTripsUI(
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
                              color: const Color.fromRGBO(25, 192, 122, 1),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginwithEmailUI()));
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
