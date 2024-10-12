class Intern {
  final String id;
  final String email;
  final String username;
  final String name;
  final String contact;
  final String nic;
  final String internId;
  final String role;

  Intern({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.contact,
    required this.nic,
    required this.internId,
    required this.role,
  });

  factory Intern.fromJson(Map<String, dynamic> json) {
    return Intern(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      nic: json['nic']?.toString() ?? '',
      internId: json['internId']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
