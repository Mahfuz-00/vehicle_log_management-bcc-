import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footer/footer.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceForgotPassword.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceOTPVerification.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/forgotpasswordotpbox.dart';
import '../Admin Dashboard/admindashboardUI.dart';
import '../Driver Dashboard/driverdashboardUI.dart';
import '../Senior Officer Dashboard/srofficerdashboardUI.dart';
import '../Staff Dashboard/staffdashboardUI.dart';

/// The [OPTVerification] widget is responsible for displaying the OTP
/// (One-Time Password) verification screen. It allows users to enter
/// the OTP sent to their email address and verify it.
///
/// The widget includes:
/// - A loading indicator while the verification code is being processed.
/// - Text fields for entering the OTP, with focus management for
///   user convenience.
/// - A button to verify the OTP, which triggers the API call for
///   verification and navigates to the password creation screen upon success.
/// - A footer for resending the OTP if the user did not receive it.
///
/// It uses the [EmailCubit] to retrieve the user's email and
/// provides visual feedback through snack bars for various actions.
///
/// The following variables and actions are highlighted:
/// - [_isLoading]: Indicates whether the loading spinner is visible.
/// - [_pageloading]: Indicates whether the page is currently processing a request.
/// - [_controllers]: A list of controllers for the OTP input fields.
/// - [_focusNodes]: A list of focus nodes for managing input field focus.
/// - [_sendCode(String email)]: Sends the OTP to the user's email.
/// - [_sendOTP(String email, String OTP)]: Verifies the entered OTP.
class LoginOPTVerficationUI extends StatefulWidget {
  const LoginOPTVerficationUI({super.key});

  @override
  State<LoginOPTVerficationUI> createState() => _LoginOPTVerficationUIState();
}

class _LoginOPTVerficationUIState extends State<LoginOPTVerficationUI> {
  bool _isLoading = true;
  bool _pageloading = false;
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  late String userType;

  Future<void> _sendCode(String email) async {
    final apiService = await ForgotPasswordAPIService();
    apiService.sendForgotPasswordOTP(email).then((response) {
      if (response == 'Forget password otp send successfully') {
        const snackBar = SnackBar(
          content: Text('Code Sent to your Email.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response == 'validation error') {
        const snackBar = SnackBar(
          content: Text('Invalid Email'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      print(error);
      const snackBar = SnackBar(
        content: Text('Invalid Email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> _sendOTP(String email, String OTP) async {
    setState(() {
      _pageloading = true;
    });
    final apiService = await OTPVerificationAPIService.create();
    apiService.OTPVerification(email, OTP).then((response) {
      if (response == 'Otp Verified Successfully') {
        setState(() {
          _pageloading = false;
        });
          print('Checking $userType');
          if (userType != null) {
            if (userType == 'vlm_staff') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StaffDashboardUI(
                            shouldRefresh: true)),
                    (route) => false,
              );
            } else if (userType == 'vlm_driver') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DriverDashboardUI(
                            shouldRefresh: true)),
                    (route) => false,
              );
            } else if (userType ==
                'vlm_senior_officer') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SROfficerDashboardUI(
                            shouldRefresh: true)),
                    (route) => false,
              );
            } else if (userType == 'vlm_admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdminDashboardUI(
                            shouldRefresh: true)),
                    (route) => false,
              );
            } else {
              String errorMessage =
                  'Invalid User!, Please enter a valid email address.';
              showTopToast(context, errorMessage);
            }
          }
      } else if (response ==
          'Otp not match. Please resend forget password otp') {
        setState(() {
          _pageloading = false;
        });
        const snackBar = SnackBar(
          content: Text('OTP did not Match. Try again!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      setState(() {
        _pageloading = false;
      });
      print(error);
      const snackBar = SnackBar(
        content: Text('OTP did not Match. Try again!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void showTopToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Show circular loading indicator while waiting
        child: CircularProgressIndicator(),
      ),
    )
        : InternetConnectionChecker(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(25, 192, 122, 1),
                              width: 2),
                          // Border properties
                          borderRadius: BorderRadius.circular(
                              10), // Optional: Rounded border
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle back button press here
                            Navigator.pop(
                                context); // This will pop the current route off the navigator stack
                          },
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 30,
                          padding: EdgeInsets.all(10),
                          splashRadius: 30,
                          color: Color.fromRGBO(25, 192, 122, 1),
                          splashColor: Colors.grey,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                'OTP Verification',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(25, 192, 122, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default'),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Text(
                                  'Enter the Verification code we just sent on your email address',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (index) {
                                    return Row(
                                      children: [
                                        CustomTextBox(
                                          textController: _controllers[index],
                                          currentFocusNode:
                                          _focusNodes[index],
                                          nextFocusNode: index < 3
                                              ? _focusNodes[index + 1]
                                              : null,
                                        ),
                                        if (index < 3) SizedBox(width: 10),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    bool allFieldsFilled = _controllers.every(
                                            (controller) =>
                                        controller.text.isNotEmpty);
                                    if (allFieldsFilled) {
                                      String OTP = _controllers
                                          .map(
                                              (controller) => controller.text)
                                          .join();
                                      final emailcubit =
                                      context.read<EmailCubit>();
                                      final emailState = emailcubit.state;
                                      String email = '';
                                      if (emailState is EmailSaved) {
                                        email = emailState.email;
                                      }
                                      _sendOTP(email, OTP);
                                    } else {
                                      const snackBar = SnackBar(
                                        content: Text(
                                            'Please fill all OTP fields'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Color.fromRGBO(25, 192, 122, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: Size(screenWidth * 0.9, 70),
                                  ),
                                  child: _pageloading
                                      ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                      : const Text('Verify',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'default',
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Footer(
                      backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Didn\'t recived code?  ',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final emailcubit =
                                  context.read<EmailCubit>();
                                  final emailState = emailcubit.state;
                                  String email = '';
                                  if (emailState is EmailSaved) {
                                    email = emailState.email;
                                  }
                                  _sendCode(email!);
                                },
                                child: Text(
                                  'Resend',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(25, 192, 122, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
