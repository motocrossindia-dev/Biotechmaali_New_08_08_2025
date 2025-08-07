class OurStoreModel {
  final int id;
  final String location;
  final String address;
  final String contact;
  final String timePeriod;
  final String addressLink;

  OurStoreModel({
    required this.id,
    required this.location,
    required this.address,
    required this.contact,
    required this.timePeriod,
    required this.addressLink,
  });

  factory OurStoreModel.fromJson(Map<String, dynamic> json) {
    return OurStoreModel(
      id: json['id'],
      location: json['location'],
      address: json['address'],
      contact: json['contact'],
      timePeriod: json['time_period'],
      addressLink: json['address_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'address': address,
      'contact': contact,
      'time_period': timePeriod,
      'address_link': addressLink,
    };
  }
}