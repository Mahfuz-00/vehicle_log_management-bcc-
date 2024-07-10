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