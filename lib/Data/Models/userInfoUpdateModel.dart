/// Represents a model for updating user profile information.
///
/// This class holds the necessary details required to update a user's profile.
///
/// **Variables:**
/// - [userId]: A String that represents the unique identifier of the user.
/// - [name]: A String that holds the user's name.
/// - [organization]: A String indicating the name of the user's organization.
/// - [designation]: A String specifying the user's job title or designation.
/// - [phone]: A String representing the user's phone number.
///
/// **Actions:**
/// - [toJson]: Converts the UserProfileUpdate object to a JSON map for API submission.
class UserProfileUpdate {
  final String userId;
  final String name;
  final String phone;

  UserProfileUpdate({
    required this.userId,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
    };
  }
}
