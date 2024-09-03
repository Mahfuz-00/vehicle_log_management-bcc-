import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for accepting or rejecting trips via an API.
///
/// This class manages the authentication token and handles requests to
/// accept or reject trips.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
/// - [URL]: The base URL for the API endpoint.
///
/// **Actions:**
/// - [create]: Creates an instance of [TripAcceptRejectAPIService] and loads
///   the authentication token from shared preferences.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [acceptOrRejectTrip]: Sends a POST request to accept or reject a trip
///   using the provided [type] and [tripId].
class TripAcceptRejectAPIService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  TripAcceptRejectAPIService._();

  static Future<TripAcceptRejectAPIService> create() async {
    var apiService = TripAcceptRejectAPIService._();
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

  Future<void> acceptOrRejectTrip({required String type, required int tripId,}) async {
    final String url = '$URL/vlm/trip/accept/or/reject';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final Map<String, dynamic> body = {
      "type": type,
      "trip_id": tripId,
    };

    print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Trip accepted/rejected successfully');
        if (type.toLowerCase() == 'accepted') {
          print('Request accepted');
        } else if (type.toLowerCase() == 'rejected') {
          print('Request declined');
        }
      } else {
        print('Failed to accept/reject Trip. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting/rejecting Trip: $e');
    }
  }
}
