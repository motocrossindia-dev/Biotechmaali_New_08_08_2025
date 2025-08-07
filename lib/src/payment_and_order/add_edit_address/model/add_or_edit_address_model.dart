class AddOrEditAddressModel {
  final int? addressId;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String state;
  final String addressType;
  final int pincode;

  AddOrEditAddressModel({
    this.addressId,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.state,
    required this.addressType,
    required this.pincode,
  });

  factory AddOrEditAddressModel.fromJson(Map<String, dynamic> json) {
    return AddOrEditAddressModel(
      addressId: json['address_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      addressType: json['address_type'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'city': city,
      'state': state,
      'address_type': addressType,
      'pincode': pincode,
    };
  }
}