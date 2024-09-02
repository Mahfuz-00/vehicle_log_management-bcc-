/// Represents the response received after a profile picture update request.
///
/// This class encapsulates the information returned from the server
/// regarding the success or failure of the profile picture update.
///
/// **Variables:**
/// - [status]: A boolean indicating whether the profile picture update was successful.
/// - [message]: A String containing a message from the server providing additional information about the update.
class ProfilePictureUpdateResponse {
  final bool status;
  final String message;

  ProfilePictureUpdateResponse({required this.status, required this.message});

  factory ProfilePictureUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUpdateResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
