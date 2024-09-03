import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching complete dashboard items from an API.
///
/// This class manages the authentication token and handles requests to
/// retrieve full dashboard data based on a provided URL.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [create]: Creates an instance of [DashboardFullAPIService] and loads
///   the authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [fetchDashboardItemsFull]: Sends a GET request to the specified [url]
///   to fetch full dashboard items and returns the response data as a [Map].
class DashboardFullAPIService{
  late final String authToken;

  DashboardFullAPIService._();

  static Future<DashboardFullAPIService> create() async {
    var apiService = DashboardFullAPIService._();
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

  Future<Map<String, dynamic>> fetchDashboardItemsFull(String url) async {
    print(url);
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}
