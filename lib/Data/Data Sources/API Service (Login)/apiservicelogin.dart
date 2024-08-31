import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/loginmodels.dart';

class APIService {
  Future<LoginResponseModel?> login(LoginRequestmodel loginRequestModel) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/login";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequestModel.toJSON()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while logging in: $e');
    }
  }
}
