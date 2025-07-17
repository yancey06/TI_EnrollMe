class Profile {
  final String username;
  String fullName;
  String email;
  int gradeLevel;
  String address;
  String contactNumber;
  String birthday;
  String guardianName;

  Profile({
    required this.username,
    required this.fullName,
    required this.email,
    required this.gradeLevel,
    this.address = '',
    this.contactNumber = '',
    this.birthday = '',
    this.guardianName = '',
  });
} 