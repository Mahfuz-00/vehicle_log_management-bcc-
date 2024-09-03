import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for starting a trip via an API.
///
/// This class is responsible for sending a request to start a trip by
/// using a specific trip ID.
///
/// **Actions:**
/// - [create]: Initializes the API service and loads the authentication token.
/// - [TripStarted]: Sends a request to the API to start a trip using the
///   provided trip ID. It returns a boolean indicating the success or failure
///   of the operation.
///
/// **Variables:**
/// - [_baseUrl]: The base URL for the API endpoints.
/// - [authToken]: The authentication token required for API requests.
/// - [url]: The full URL for the trip start request, constructed using the
///   base URL and the trip ID.
/// - [requestBody]: The body of the request containing the trip ID.
/// - [response]: The response received from the API after sending the request.
class StartTripAPIService {
  static const String _baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  StartTripAPIService._();

  static Future<StartTripAPIService> create() async {
    var apiService = StartTripAPIService._();
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

  Future<bool> TripStarted({
    required int tripId,
  }) async {
    print('Trip Starting');
    final url = '$_baseUrl/vlm/trip/start/$tripId';
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
      print('Trip Started successfully');
      return true;
    } else {
      print('Failed to Start Trip. Status code: ${response.statusCode}');
      return false;
    }
  }
}
