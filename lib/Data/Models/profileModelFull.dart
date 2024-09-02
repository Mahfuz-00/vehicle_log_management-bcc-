/// Represents a full user profile with detailed user information.
///
/// This class encapsulates comprehensive user data and provides a method
/// for creating an instance from JSON data.
///
/// **Variables:**
/// - [id]: An int that holds the unique identifier for the user.
/// - [name]: A String that contains the full name of the user.
/// - [organization]: A String that specifies the organization the user is associated with.
/// - [designation]: A String that indicates the user's job title or position.
/// - [phone]: A String that holds the user's phone number.
/// - [VisitorType]: A String that represents the type of visitor (e.g., guest, member).
/// - [email]: A String that contains the user's email address.
/// - [photo]: A String that holds the URL or path to the user's profile photo.
class UserProfileFull {
  final int id;
  final String name;
  final String designation;
  final String phone;
  final String email;
  final String photo;

  UserProfileFull({
    required this.id,
    required this.name,
    required this.designation,
    required this.phone,
    required this.email,
    required this.photo,
  });

  factory UserProfileFull.fromJson(Map<String, dynamic> json) {
    return UserProfileFull(
      id: json['userId'],
      name: json['name'],
      designation: json['designation'],
      phone: json['phone'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}