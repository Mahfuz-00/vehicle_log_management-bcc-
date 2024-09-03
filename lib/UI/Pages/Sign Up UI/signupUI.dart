import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

import '../../../Data/Models/registermodels.dart';
import '../../Widgets/dropdownfield.dart';
import '../../Widgets/radiooptionSignUp.dart';
import '../Login UI/loginUI.dart';

class SignupUI extends StatefulWidget {
  const SignupUI({super.key});

  @override
  State<SignupUI> createState() => _SignupUIState();
}

class _SignupUIState extends State<SignupUI> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> dropdownItems1 = [
    DropdownMenuItem(child: Text("IT"), value: "IT"),
    DropdownMenuItem(child: Text("Management"), value: "Management"),
    DropdownMenuItem(child: Text("Executive"), value: "Executive"),
  ];

  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    //_registerRequest = RegisterRequestmodel(Email: '', Password: '');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
     return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children : [
                        const Text(
                          'Hello! Register to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(25, 192, 122, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sign in to see how we manage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Choose User Type',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                            ],
                          ),
                        ),
                        RadioListTileGroup(
                            options: ['Staff', 'Driver'],
                            selectedOption: null,
                            onChanged: (String value) {
                              print('Selected option: $value');
                              // You can perform any other actions here based on the selected option
                            }
                        ),
                        SizedBox(height: 10,),
                        Form(
                          key: globalfromkey,
                          child: Column(
                            children: [
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Designation',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              DropdownFormField(hintText: 'Department', dropdownItems: dropdownItems1,),
                              const SizedBox(height: 20),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                 // onSaved: (input) => _registerRequest.Email= input!,
                                  validator: (input) {
                                    if (input == null || !input.contains('@')) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 6 ? "Password should be more than 3 characters": null,
                                  controller: _passwordController,
                                  obscureText: _isObscuredPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredPassword = !_isObscuredPassword;
                                          _passwordController.text =
                                              _passwordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 6 ? "Password should be more than 3 characters": null,
                                  controller: _confirmPasswordController,
                                  obscureText: _isObscuredConfirmPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconConfirmPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                                          _confirmPasswordController.text =
                                              _confirmPasswordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Add Profile Picture',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: (){},
                                      child: Container(
                                          margin: EdgeInsets.only(right: 2),
                                          padding: EdgeInsets.all(3),
                                          width: 80,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(2),
                                              bottomRight: Radius.circular(2),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(Icons.file_upload,
                                                color: Color.fromRGBO(143, 150, 158, 1),),
                                              Text('Upload',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(143, 150, 158, 1),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'default',
                                                ),)
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: /*_registerUser*/() {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(350, 70),
                            ),
                            child: const Text('Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'default',
                                ))),
                      ]
                    )
                  ),
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
                            const Text(
                              'Already have an account?  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LoginUI()));
                              },
                              child: const Text(
                                'Login now',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
          ),
        ),
      ),
    );
  }

/*  void _registerUser() {
    if (validateAndSave() && checkConfirmPassword()) {
      RegisterRequestmodel registerRequest = RegisterRequestmodel(
        //fullName: _fullNameController.text,
        Email: _emailController.text,
        Password: _passwordController.text,
      );

      // Call your API service to register the user
      APIService apiService = APIService();
      apiService.register(registerRequest).then((response) {
        // Handle the response accordingly
        // For example, show a success message or navigate to the next screen
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
        const snackBar = SnackBar(
          content: Text('Register Failed!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }*/

  bool validateAndSave() {
    final form = globalfromkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool checkConfirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }
}
