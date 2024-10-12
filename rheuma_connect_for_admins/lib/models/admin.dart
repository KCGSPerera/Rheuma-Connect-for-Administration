class Admin {
  final String id;
  final String email;
  final String username;
  final String name;
  final String contact;
  final String nic;
  final String role;

  Admin({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.contact,
    required this.nic,
    required this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      nic: json['nic']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
