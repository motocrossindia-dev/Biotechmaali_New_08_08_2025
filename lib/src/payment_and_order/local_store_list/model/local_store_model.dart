class LocalStoreModel {
  final int id;
  final String location;
  final String address;
  final String contact;
  final String timePeriod;
  final String addressLink;
  final String? image;

  LocalStoreModel({
    required this.id,
    required this.location,
    required this.address,
    required this.contact,
    required this.timePeriod,
    required this.addressLink,
    this.image,
  });

  String? getFullImageUrl() {
    if (image == null) return null;
    const baseUrl = 'https://www.backend.biotechmaali.com';
    return '$baseUrl$image';
  }

  factory LocalStoreModel.fromJson(Map<String, dynamic> json) {
    return LocalStoreModel(
      id: json['id'] ?? 0,
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      timePeriod: json['time_period'] ?? '',
      addressLink: json['address_link'] ?? '',
      image: json['image'],
    );
  }
}

class StoreListResponse {
  final String message;
  final List<LocalStoreModel> stores;

  StoreListResponse({
    required this.message,
    required this.stores,
  });

  factory StoreListResponse.fromJson(Map<String, dynamic> json) {
    final storesList = (json['data']['stores'] as List?)
            ?.map(
              (store) => LocalStoreModel.fromJson(store),
            )
            .toList() ??
        [];

    return StoreListResponse(
      message: json['message'] ?? '',
      stores: storesList,
    );
  }
}
