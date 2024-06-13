import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Models/profileModelFull.dart';
import '../Login UI/loginUI.dart';

class Profile extends StatefulWidget {
  final bool shouldRefresh;

  const Profile({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  late final UserProfileFull? userProfile;

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));

    final apiService = await APIProfileService();
    final profile = await apiService.fetchUserProfile(token);
    userProfile = UserProfileFull.fromJson(profile);
    name = userProfile!.name;
    print(userProfile!.name);
    print(userProfile!.id);

    try {
      await prefs.setString('userName', userProfile!.name);
      await prefs.setString('photoUrl', userProfile!.photo);
      final String? UserName = prefs.getString('userName');
      final String? PhotoURL = prefs.getString('photoUrl');
      print('User Name: $UserName');
      print('Photo URL: $PhotoURL');
      print('User profile saved successfully');
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    print('initState called');
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !isloaded) {
        isloaded = true;

        setState(() {
          print('Page Loading');
          _pageLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        : InternetChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
              backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
              title: Text(
                'Profile Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  )),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  child: Divider(
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              )),
          body:  _pageLoading
              ? Center(child: CircularProgressIndicator()) // Show indicator
              :SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: const Color.fromRGBO(25, 192, 122, 1),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(children: [
                        Stack(
                          children: [
                            Container(
                              width: 120, // Adjust width as needed
                              height: 120, // Adjust height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://bcc.touchandsolve.com' +
                                          userProfile!.photo),
                                ),
                              ),
                            ),
                            /* Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      //padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          _showImagePicker();
                                        },
                                        alignment: Alignment.center,
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),*/
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userProfile!.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 50),
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Column(
                              children: [
                                _buildDataCouple(
                                    Icons.person, 'Name', userProfile!.name),
                                Divider(),
                                /*_buildDataCouple(Icons.house_outlined,
                                    'Organization', userProfile!.organization),
                                Divider(),
                                _buildDataCouple(Icons.work, 'Designation',
                                    userProfile!.designation),
                                Divider(),*/
                                _buildDataCouple(Icons.phone_android_outlined,
                                    'Mobile', userProfile!.phone),
                                Divider(),
                                _buildDataCouple(
                                    Icons.mail, 'Email', userProfile!.email),
                                Divider(),
                               /* _buildDataCouple(
                                    Icons.supervised_user_circle_rounded,
                                    'Visitor Type',
                                    userProfile!.VisitorType),
                                Divider(),*/
                                /*GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PasswordChange(),));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 9,
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Change Password',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          height: 1.6,
                                                          letterSpacing: 1.3,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontFamily: 'default',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )*/
                              ],
                            ),
                          ),
                        )
                      ])),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.8,
                                  MediaQuery.of(context).size.height * 0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Icon(
                                  Icons.home,
                                  color: const Color.fromRGBO(25, 192, 122, 1),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                const Text('Back to Home',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(25, 192, 122, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCouple(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(icon, size: 25),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 1.6,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 35,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 1.6,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login())); // Close the drawer
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
