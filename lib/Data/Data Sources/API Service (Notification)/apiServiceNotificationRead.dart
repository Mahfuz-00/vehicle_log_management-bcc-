import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NotificationReadApiService._();

  static Future<NotificationReadApiService> create() async {
    var apiService = NotificationReadApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  NotificationReadApiService() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
    //return token;
  }


  Future<bool> readNotification() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/notification/read'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        // Request was successful, handle response accordingly
        print(response.body);
        print('Notification Read!!');
        return true;
      } else {
        print(response.body);
        // Request failed, handle error accordingly
        print('Failed to read Notification: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      print(response.body);
      // Exception occurred, handle error accordingly
      print('Exception While Reading Notification: $e');
      return false;
    }
  }
}