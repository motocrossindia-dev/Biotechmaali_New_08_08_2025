class ContentBlock {
  final int id;
  final String section;
  final String title;
  final String subtitle;
  final String buttonText;
  final String? image;
  final String? videoLink;
  final int order;
  final bool isActive;

  ContentBlock({
    required this.id,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.image,
    this.videoLink,
    required this.order,
    required this.isActive,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      id: json['id'] ?? 0,
      section: json['section'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      buttonText: json['button_text'] ?? '',
      image: json['image'],
      videoLink: json['video_link'],
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': section,
      'title': title,
      'subtitle': subtitle,
      'button_text': buttonText,
      'image': image,
      'video_link': videoLink,
      'order': order,
      'is_active': isActive,
    };
  }
}
