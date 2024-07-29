import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import '../../Models/tripRequestModel.dart';


class APIServiceTripRequest {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  APIServiceTripRequest._();

  static Future<APIServiceTripRequest> create() async {
    var apiService = APIServiceTripRequest._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  APIServiceTripRequest() {
    authToken = _loadAuthToken(); // Assigning the future here
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
    final String token = await authToken; // Wait for the authToken to complete
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var uri = Uri.parse('$URL/vlm/trip/request');
      var requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.headers['Authorization'] = 'Bearer $token';
      requestMultipart.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
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
