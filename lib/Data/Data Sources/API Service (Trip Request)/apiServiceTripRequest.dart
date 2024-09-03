import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import '../../Models/tripRequestModel.dart';

/// A service class for handling trip requests via an API.
///
/// This class manages the process of sending trip requests, including
/// optional file attachments, to the API endpoint.
///
/// **Actions:**
/// - [create]: Initializes the API service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [postTripRequest]: Sends a trip request to the API, optionally attaching
///   a file. Returns a message indicating the success or failure of the request.
///
/// **Variables:**
/// - [URL]: The base URL for the API endpoints.
/// - [authToken]: A future that resolves to the authentication token required
///   for API requests.
/// - [uri]: The complete URI for the trip request endpoint.
/// - [requestMultipart]: The multipart request object used to send the trip
///   request and any file attachments.
/// - [token]: The authentication token retrieved for the current session.
/// - [response]: The response received from the API after sending the request.
/// - [jsonResponse]: The JSON-decoded response body when the trip request
///   is successful.
class TripRequestAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  TripRequestAPIService._();

  static Future<TripRequestAPIService> create() async {
    var apiService = TripRequestAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  TripRequestAPIService() {
    authToken = _loadAuthToken();
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postTripRequest(TripRequest request, File? file) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var uri = Uri.parse('$URL/vlm/trip/request');
      var requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.headers['Authorization'] = 'Bearer $token';
      requestMultipart.headers['Content-Type'] = 'multipart/form-data';

      request.toJson().forEach((key, value) {
        requestMultipart.fields[key] = value.toString();
      });

      if(file != null){
        print('File Found');
        requestMultipart.files.add(await http.MultipartFile.fromPath(
          'attachment_file',
          file!.path,
          filename: basename(file.path),
        ));
      }

      var streamedResponse = await requestMultipart.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Trip request sent successfully.');
        return jsonResponse['message'];
      } else {
        print('Failed to send Trip request. Status code: ${response.statusCode}');
        return 'Failed to send Trip request';
      }
    } catch (e) {
      print('Error sending Trip request: $e');
      return 'Error sending Trip request';
    }
  }
}
