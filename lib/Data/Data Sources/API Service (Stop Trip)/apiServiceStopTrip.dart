import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for stopping a trip via an API.
///
/// This class handles the process of sending a request to stop a trip using
/// a specific trip ID.
///
/// **Actions:**
/// - [create]: Initializes the API service and loads the authentication token.
/// - [TripStopped]: Sends a request to the API to stop a trip using the
///   provided trip ID. It returns a boolean indicating whether the operation
///   was successful.
///
/// **Variables:**
/// - [_baseUrl]: The base URL for the API endpoints.
/// - [authToken]: The authentication token required for API requests.
/// - [url]: The full URL for the trip stop request, constructed using the
///   base URL and the trip ID.
/// - [requestBody]: The body of the request containing the trip ID.
/// - [response]: The response received from the API after sending the request.
class StopTripAPIService {
  static const String _baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  StopTripAPIService._();

  static Future<StopTripAPIService> create() async {
    var apiService = StopTripAPIService._();
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

  Future<bool> TripStopped({
    required int tripId,
  }) async {
    print('Trip Stopping');
    final url = '$_baseUrl/vlm/trip/stop/$tripId';
    final Map<String, dynamic> requestBody = {
      'trip_id': tripId,
    };

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      print('Trip Stopped successfully');
      return true;
    } else {
      print('Failed to Stop Trip. Status code: ${response.statusCode}');
      return false;
    }
  }
}
