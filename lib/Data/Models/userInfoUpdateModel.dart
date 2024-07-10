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
