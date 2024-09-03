import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/imageUpdateModel.dart';

/// A service class for updating the user's profile picture via an API request.
///
/// This class provides methods to handle the uploading of a profile picture using a [File] object and an [authToken]
/// for authorization. It communicates with the backend to update the user's profile picture.
///
/// **Variables:**
/// - [URL]: The API endpoint for updating the profile picture.
/// - [authToken]: The authentication token used for authorizing the API request.
///
/// **Actions:**
/// - [create]: A factory method that initializes the [ProfilePictureUpdateAPIService] class and loads the [authToken].
/// - [_loadAuthToken]: Loads the [authToken] from shared preferences.
/// - [updateProfilePicture]: Sends a POST request to the API with the selected image file. It constructs a multipart
///   request containing the image file, and if the request is successful, it returns a [ProfilePictureUpdateResponse].
///   If the request fails, it throws an exception and prints relevant error messages.
class ProfilePictureUpdateAPIService {
  static const String URL =
      'https://bcc.touchandsolve.com/api/user/profile/photo/update';
  late final String authToken;

  ProfilePictureUpdateAPIService._();

  static Future<ProfilePictureUpdateAPIService> create() async {
    var apiService = ProfilePictureUpdateAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<ProfilePictureUpdateResponse> updateProfilePicture({required File image}) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }
      var request = http.MultipartRequest('POST', Uri.parse(URL));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      print(image);
      var imageStream = http.ByteStream(image!.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: image.path.split('/').last);
      print(multipartFile);
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        print(json);
        return ProfilePictureUpdateResponse.fromJson(json);
      } else {
        String responseBody = await response.stream.bytesToString();
        print(response.statusCode);
        print(responseBody);
        throw Exception(
            'Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}
