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