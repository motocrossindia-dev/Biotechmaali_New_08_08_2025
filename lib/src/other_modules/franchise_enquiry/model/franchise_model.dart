class FranchiseModel {
  final String name;
  final String mobile;
  final String email;
  final String area;
  final String address;
  final String message;

  FranchiseModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.area,
    required this.address,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'area': area,
      'address': address,
      'message': message,
    };
  }
}