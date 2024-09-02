/// Represents a user profile containing essential user information.
///
/// This class encapsulates user-related data and provides a method for
/// creating an instance from JSON data.
///
/// **Variables:**
/// - [Id]: An int that holds the unique identifier for the user.
/// - [name]: A String that contains the name of the user.
/// - [organization]: A String that specifies the organization the user belongs to.
/// - [photo]: A String that holds the URL or path to the user's profile photo.
/// - [user]: A String that indicates the type of user (e.g., admin, guest).
class UserProfile {
  final int Id;
  final String name;
  final String photo;

  UserProfile({
    required this.Id,
    required this.name,
    required this.photo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      Id: json['userId'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}