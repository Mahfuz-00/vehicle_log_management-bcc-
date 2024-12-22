import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Data Sources/API Service (User Info Update)/apiServiceImageUpdate.dart';
import '../../../Data/Data Sources/API Service (User Info Update)/apiServiceUserInfoUpdate.dart';
import '../../../Data/Models/profileModelFull.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../../Data/Models/userInfoUpdateModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../Login UI/loginEmailUI.dart';
import '../Login UI/loginUI.dart';
import 'passwordChange.dart';

/// A [ProfileUI] widget that displays the user's profile information.
///
/// This widget is responsible for fetching and displaying the user's profile data
/// and managing the state for profile loading, editing, and logout actions.
///
/// **Variables:**
/// - [shouldRefresh]: Indicates whether the profile should be refreshed.
/// - [globalKey]: A [GlobalKey] used for the scaffold state.
/// - [globalfromkey]: A [GlobalKey] used for the form state.
/// - [_isLoading]: Indicates whether data is currently loading.
/// - [name]: Stores the user's name.
/// - [isloaded]: Indicates whether the profile has been loaded.
/// - [_pageLoading]: Indicates whether the page is loading.
/// - [userProfile]: Stores the fetched user's profile data of type [UserProfileFull].
/// - [_imageFile]: Stores the selected image file for the profile picture.
/// - [_fullNameController]: A [TextEditingController] for the full name input field.
/// - [_organizationController]: A [TextEditingController] for the organization input field.
/// - [_designationController]: A [TextEditingController] for the designation input field.
/// - [_phoneController]: A [TextEditingController] for the phone number input field.
/// - [_passwordController]: A [TextEditingController] for the password input field.
/// - [_licenseNumberController]: A [TextEditingController] for the license number input field.
/// - [userProfileCubit]: An instance of [UserProfile] to manage user profile state in the application.
///
/// **Actions:**
/// - [_fetchUserProfile]: Asynchronously fetches the user's profile data and updates the state.
/// - [initState]: Initializes the profile state and fetches the user profile on widget creation.
/// - [dispose]: Cleans up the controllers when the widget is removed from the widget tree.
/// - [build]: Builds the UI for the profile, including loading indicators and profile details.
/// - [_buildDataCouple]: Builds a UI component displaying an icon, label, and value.
/// - [_showLogoutDialog]: Displays a confirmation dialog for logging out.
class ProfileUI extends StatefulWidget {
  final bool shouldRefresh;

  const ProfileUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
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

  late UserProfile userProfileCubit;

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));

    final apiService = await ProfileAPIService();
    final profile = await apiService.fetchUserProfile(token);
    userProfile = UserProfileFull.fromJson(profile);
    name = userProfile!.name;
    print(userProfile!.name);
    print(userProfile!.id);

    setState(() {
      userProfileCubit = UserProfile(
        Id: userProfile!.id,
        name: userProfile!.name,
        photo: userProfile!.photo,
      );
    });

    context.read<AuthCubit>().updateProfile(UserProfile(
          Id: userProfile!.id,
          name: userProfile!.name,
          photo: userProfile!.photo,
        ));
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
              child: CircularProgressIndicator(),
            ),
          )
        : InternetConnectionChecker(
            child: Scaffold(
              backgroundColor: Colors.grey[100],
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
                  ? Center(child: CircularProgressIndicator())
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
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                'https://bcc.touchandsolve.com${userProfile!.photo}'),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 35,
                                          width: 35,
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
                                          _buildDataCouple(
                                              Icons.phone_android_outlined,
                                              'Mobile',
                                              userProfile!.phone),
                                          Divider(),
                                          _buildDataCouple(Icons.mail,
                                              'Email', userProfile!.email),
                                          Divider(),
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
                      elevation: 8,
                      highlightElevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Adjust the border radius as needed
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
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
                                  LoginUI()));
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
              key: globalfromkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      'Full Name', userProfile!.name, _fullNameController),
                  SizedBox(
                    height: 5,
                  ),
                  _buildTextField('Phone Number', userProfile!.phone as String,
                      _phoneController),
                  SizedBox(
                    height: 5,
                  ),
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
                      Navigator.of(context).pop();
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
                      print(userProfile!.phone);
                      final userProfileUpdate = UserProfileUpdateModel(
                        userId: userProfile!.id.toString(),
                        name: _fullNameController.text,
                        phone: _phoneController.text,
                      );
                      final apiService = await UpdateUserAPIService.create();
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
                                  ProfileUI(shouldRefresh: true)));
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
    if (initialValue != null && controller != null) {
      controller.text = initialValue;
    }

    controller.addListener(() {
      String updatedValue = controller.text;
      print("Updated value: $updatedValue");
    });

    return Container(
      width: 350,
      height: 70,
      child: TextFormField(
        controller: controller,
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
      final apiService = await ProfilePictureUpdateAPIService.create();
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
              builder: (context) => ProfileUI(shouldRefresh: true)));
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }
}
