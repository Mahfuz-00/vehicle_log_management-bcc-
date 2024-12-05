import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **Payment View Management** functionalities,
/// specifically for fetching payment-related data from the API.
///
/// This class provides methods to manage authentication and retrieve
/// a list of unpaid payments for the user.
///
/// ### Key Actions:
/// - **getallPayment()**:
///   Sends a GET request to retrieve the list of unpaid payments for the user.
///
///   - **Returns**:
///     A `Map<String, dynamic>?` representing the JSON response
///     containing payment details, or `null` if the request fails.
///
///   - **Throws**:
///     An exception if the authentication token is empty or if an error
///     occurs during the request, providing relevant error messages.
class SubmitTransactionAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SubmitTransactionAPIService._();

  static Future<SubmitTransactionAPIService> create() async {
    var apiService = SubmitTransactionAPIService._();
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

  Future<Map<String, dynamic>?> submitTransaction({
    required String transactionId,
    required String transactionDate,
    required String transactionType,
    required double transactionAmount,
  }) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/itee/payment/exam/registration'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          'transaction_id': transactionId,
          'transaction_date': transactionDate,
          'transaction_type': transactionType,
          'amount': transactionAmount,
        },
      );
      print(response.request);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to Submit');
      }
    } catch (e) {
      throw Exception('Error Submitting: $e');
    }
  }
}
