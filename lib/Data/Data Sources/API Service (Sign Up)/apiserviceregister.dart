import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/registermodels.dart';

/// A service class for handling user registration via an API.
///
/// This class is responsible for sending a registration request, including
/// user details and an optional profile image, to the API.
///
/// **Actions:**
/// - [register]: Sends a registration request to the API with user details
///   and an optional image file. It returns a message indicating success or
///   failure of the registration process.
///
/// **Variables:**
/// - [url]: The endpoint URL for the registration API.
/// - [request]: The [http.MultipartRequest] object used to send the registration data.
/// - [imageStream]: A stream of bytes from the image file to be uploaded.
/// - [length]: The length of the image file in bytes.
/// - [multipartFile]: The [http.MultipartFile] object created from the image file.
/// - [response]: The response received from the API after sending the registration request.
class UserRegistrationAPIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['app_name'] = 'ndc';
      request.fields['full_name'] = registerRequestModel.fullName;
      request.fields['organization'] = registerRequestModel.organization;
      request.fields['designation'] = registerRequestModel.designation;
      request.fields['email'] = registerRequestModel.email;
      request.fields['phone'] = registerRequestModel.phone;
      request.fields['password'] = registerRequestModel.password;
      request.fields['password_confirmation'] = registerRequestModel.confirmPassword;
      request.fields['user_type'] = registerRequestModel.userType;

      var imageStream = http.ByteStream(imageFile!.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: imageFile.path.split('/').last);

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('User registered successfully!');
        return jsonResponse['message'];
      } else {
        print('Failed to register user: ${await response.stream.bytesToString()}');
        return 'Failed to register user. Please try again.';
      }
    } catch (e) {
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
