class ContactInquiry {
  final String name;
  final String contactNumber;
  final String email;
  final String message;

  ContactInquiry({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'message': message,
    };
  }
}

// models/corporate_contact.dart
class CorporateContact {
  final String title;
  final String contactPerson;
  final String contactNo;
  final String email;

  CorporateContact({
    required this.title,
    required this.contactPerson,
    required this.contactNo,
    required this.email,
  });
}