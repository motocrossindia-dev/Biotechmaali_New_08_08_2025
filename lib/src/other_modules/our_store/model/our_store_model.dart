// Response wrapper class
class OurStoreResponse {
  final String message;
  final OurStoreData data;

  OurStoreResponse({
    required this.message,
    required this.data,
  });

  factory OurStoreResponse.fromJson(Map<String, dynamic> json) {
    return OurStoreResponse(
      message: json['message'] ?? '',
      data: OurStoreData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Data class containing the list of stores
class OurStoreData {
  final List<OurStoreModel> stores;

  OurStoreData({
    required this.stores,
  });

  factory OurStoreData.fromJson(Map<String, dynamic> json) {
    return OurStoreData(
      stores: (json['stores'] as List<dynamic>?)
              ?.map((store) => OurStoreModel.fromJson(store))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stores': stores.map((store) => store.toJson()).toList(),
    };
  }
}

// Individual store model
class OurStoreModel {
  final int id;
  final String location;
  final String address;
  final String contact;
  final String timePeriod;
  final String addressLink;
  final String image;

  OurStoreModel({
    required this.id,
    required this.location,
    required this.address,
    required this.contact,
    required this.timePeriod,
    required this.addressLink,
    required this.image,
  });

  factory OurStoreModel.fromJson(Map<String, dynamic> json) {
    return OurStoreModel(
      id: json['id'] ?? 0,
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      timePeriod: json['time_period'] ?? '',
      addressLink: json['address_link'] ?? '',
      image: json['image'] ?? '',
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
      'image': image,
    };
  }
}
