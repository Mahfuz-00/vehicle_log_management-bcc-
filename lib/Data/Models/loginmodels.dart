/// Represents the response model for a login request.
///
/// This class encapsulates the data returned from the server upon
/// a successful login attempt.
///
/// **Variables:**
/// - [token]: A String containing the authentication token provided by the server.
/// - [error]: A String containing any error message returned by the server, if applicable.
/// - [userType]: A String indicating the type of user (e.g., admin, regular user).
class LoginResponseModel {
  late final String token;
  late final String error;
  late final String userType;

  LoginResponseModel({this.token = "", this.error = "", this.userType = ""});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] ?? "",
      error: json["error"] ?? "",
      userType: json["userType"] ?? "",
    );
  }
}

/// Represents the request model for a login operation.
///
/// This class is used to encapsulate the credentials required for
/// a login request to the server.
///
/// **Variables:**
/// - [Email]: A String representing the user's email address used for login.
/// - [Password]: A String representing the user's password used for authentication.
class LoginRequestmodel {
  late String Email;
  late String Password;

  LoginRequestmodel({
    required this.Email,
    required this.Password
  });

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'email': Email,
      'password': Password
    };

    return map;
  }
}
