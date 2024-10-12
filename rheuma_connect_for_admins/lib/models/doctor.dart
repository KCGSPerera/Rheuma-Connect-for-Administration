class Doctor {
  final String id;
  final String email;
  final String username;
  final String name;
  final String contact;
  final String nic;
  final String docId;
  final String role;

  Doctor({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.contact,
    required this.nic,
    required this.docId,
    required this.role,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      nic: json['nic']?.toString() ?? '',
      docId: json['docId']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
