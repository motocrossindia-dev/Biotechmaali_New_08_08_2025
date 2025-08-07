class AddressModel {
  final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String state;
  final String city;
  final String addressType;
  final int pincode;
  final bool isDefault;
  final int user;

  AddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.state,
    required this.city,
    required this.addressType,
    required this.pincode,
    required this.isDefault,
    required this.user,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      addressType: json['address_type'],
      pincode: json['pincode'],
      isDefault: json['is_default'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'state': state,
      'city': city,
      'address_type': addressType,
      'pincode': pincode,
      'is_default': isDefault,
      'user': user,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'address_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'state': state,
      'city': city,
      'address_type': addressType,
      'pincode': pincode,
    };
  }
}
