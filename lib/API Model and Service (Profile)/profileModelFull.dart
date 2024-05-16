class UserProfileFull {
  final int id;
  final String name;
  final String organization;
  final String designation;
  final String phone;
  final String VisitorType;
  final String email;
  final String photo;

  UserProfileFull({
    required this.id,
    required this.name,
    required this.organization,
    required this.designation,
    required this.phone,
    required this.VisitorType,
    required this.email,
    required this.photo,
  });

  factory UserProfileFull.fromJson(Map<String, dynamic> json) {
    return UserProfileFull(
      id: json['userId'],
      name: json['name'],
      organization: json['organization'],
      designation: json['designation'],
      phone: json['phone'],
      VisitorType: json['user_type'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}