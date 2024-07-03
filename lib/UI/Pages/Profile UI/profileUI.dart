import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Data Sources/API Service (User Info Update)/apiServiceImageUpdate.dart';
import '../../../Data/Data Sources/API Service (User Info Update)/apiServiceUserInfoUpdate.dart';
import '../../../Data/Models/profileModelFull.dart';
import '../../../Data/Models/userInfoUpdateModel.dart';
import '../Login UI/loginUI.dart';
import 'passwordChange.dart';

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
  File? _imageFile;
  late TextEditingController _fullNameController;
  late TextEditingController _organizationController;
  late TextEditingController _designationController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _licenseNumberController;

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
    _fullNameController = TextEditingController();
    _organizationController = TextEditingController();
    _designationController = TextEditingController();
    _phoneController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _passwordController = TextEditingController();
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
                body: _pageLoading
                    ? Center(
                        child: CircularProgressIndicator()) // Show indicator
                    : SingleChildScrollView(
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
                                          height:
                                              120, // Adjust height as needed
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
                                        Positioned(
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
                                                // _showImagePicker();
                                              },
                                              alignment: Alignment.center,
                                              icon: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
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
                                            _buildDataCouple(Icons.person,
                                                'Name', userProfile!.name),
                                            Divider(),
                                            /*_buildDataCouple(Icons.house_outlined,
                                    'Organization', userProfile!.organization),
                                Divider(),
                                _buildDataCouple(Icons.work, 'Designation',
                                    userProfile!.designation),
                                Divider(),*/
                                            _buildDataCouple(
                                                Icons.phone_android_outlined,
                                                'Mobile',
                                                userProfile!.phone),
                                            Divider(),
                                            _buildDataCouple(Icons.mail,
                                                'Email', userProfile!.email),
                                            Divider(),
                                            /* _buildDataCouple(
                                    Icons.supervised_user_circle_rounded,
                                    'Visitor Type',
                                    userProfile!.VisitorType),
                                Divider(),*/
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PasswordChange(),
                                                    ));
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
                                                              text:
                                                                  'Change Password',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                height: 1.6,
                                                                letterSpacing:
                                                                    1.3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'default',
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
                                            )
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Icon(
                                              Icons.home,
                                              color: const Color.fromRGBO(
                                                  25, 192, 122, 1),
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            const Text('Back to Home',
                                                style: TextStyle(
                                                  color: const Color.fromRGBO(
                                                      25, 192, 122, 1),
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
                floatingActionButton: _pageLoading
                    ? null // Show indicator
                    : FloatingActionButton(
                        onPressed: () {
                          _showEditDialog();
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30,
                        ),
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        // Change the background color as needed
                        elevation: 8,
                        // Increase the elevation to make it appear larger
                        highlightElevation: 12,
                        // Increase the highlight elevation for the pressed state

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Adjust the border radius as needed
                        ),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
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

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text('Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
          content: SingleChildScrollView(
            child: Form(
              key: globalfromkey, // Use the global form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      'Full Name', userProfile!.name, _fullNameController),
                  SizedBox(
                    height: 5,
                  ),
                  /*_buildTextField('Organization Name',
                      userProfile!.organization, _organizationController),
                  SizedBox(
                    height: 5,
                  ),*/
                  /* _buildTextField('Designation', userProfile!.designation,
                      _designationController),
                  SizedBox(
                    height: 5,
                  ),*/
                  _buildTextField('Phone Number', userProfile!.phone as String,
                      _phoneController),
                  SizedBox(
                    height: 5,
                  ),
                  /* _buildTextField('License Number', userProfile!.license,
                      _licenseNumberController),
                  SizedBox(
                    height: 5,
                  ),*/
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      print('Dialog closed');
                    },
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                        MediaQuery.of(context).size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (globalfromkey.currentState!.validate()) {
                      print(userProfile!.id.toString());
                      print(userProfile!.name);
                      // print(userProfile!.organization);
                      // print(userProfile!.designation);
                      print(userProfile!.phone);
                      //print(userProfile!.license);

                      // Validate the form
                      // If validation succeeds, update the profile
                      final userProfileUpdate = UserProfileUpdate(
                        userId: userProfile!.id.toString(),
                        // Provide the user ID here
                        name: _fullNameController.text,
                        organization: _organizationController.text,
                        designation: _designationController.text,
                        phone: _phoneController.text,
                        licenseNumber: _licenseNumberController.text,
                      );
                      final apiService = await APIServiceUpdateUser.create();
                      final result =
                          await apiService.updateUserProfile(userProfileUpdate);
                      Navigator.of(context).pop();
                      const snackBar = SnackBar(
                        content: Text('Profile Updated'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Profile(shouldRefresh: true)));
                      // Handle the result as needed, e.g., show a toast message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      ); // Close the dialog
                    }
                  },
                  child: Text('Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String label, String initialValue, TextEditingController controller) {
    // Initialize the controller with the initial value if provided
    if (initialValue != null && controller != null) {
      controller.text = initialValue;
    }

    // Add a listener to the controller to track changes in the text field
    controller.addListener(() {
      // This function will be called whenever the text changes
      String updatedValue = controller.text;

      // Do something with the updated value
      print("Updated value: $updatedValue");
    });

    return Container(
      width: 350,
      height: 70,
      child: TextFormField(
        controller: controller,
        // Use the provided controller
        validator: (input) {
          if (input == null || input.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        style: const TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'default',
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text(
                  'Take a picture',
                  style: const TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                onTap: () async {
                  final pickedImage = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                    await _updateProfilePicture(_imageFile!);
                  }
                  Navigator.pop(context, 'gallery');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  'Choose from gallery',
                  style: const TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                onTap: () async {
                  final pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                    await _updateProfilePicture(_imageFile!);
                  }
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProfilePicture(File imageFile) async {
    try {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Profile Picture Updating ....'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final apiService = await APIProfilePictureUpdate.create();
      print(imageFile.path);
      print(imageFile);
      final response = await apiService.updateProfilePicture(image: imageFile);
      print('Profile picture update status: ${response.status}');
      print('Message: ${response.message}');
      const snackBar2 = SnackBar(
        content: Text('Profile Picture Update Successfully'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(shouldRefresh: true)));
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }
}
