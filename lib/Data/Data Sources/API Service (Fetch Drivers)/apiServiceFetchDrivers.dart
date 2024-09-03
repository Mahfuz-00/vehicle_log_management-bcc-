import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching available drivers from an API.
///
/// This class manages the authentication token and handles requests to
/// retrieve available driver data.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [create]: Creates an instance of [FetchDriverAPIService] and loads
///   the authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [fetchDrivers]: Sends a GET request to the API endpoint to fetch
///   available drivers and returns the response data as a [Map].
class FetchDriverAPIService{
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  FetchDriverAPIService._();

  static Future<FetchDriverAPIService> create() async {
    var apiService = FetchDriverAPIService._();
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

  Future<Map<String, dynamic>> fetchDrivers() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/vlm/available/driver'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load Drivers');
      }
    } catch (e) {
      throw Exception('Error fetching Drivers: $e');
    }
  }
}
