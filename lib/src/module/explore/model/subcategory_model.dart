// Data model for the root response
class SubcategoryModel {
  final String message;
  final SubcategoryData data;

  SubcategoryModel({
    required this.message,
    required this.data,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      message: json['message'] ?? '',
      data: SubcategoryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Data model for the data object containing subcategories
class SubcategoryData {
  final List<Subcategory> subCategories;

  SubcategoryData({
    required this.subCategories,
  });

  factory SubcategoryData.fromJson(Map<String, dynamic> json) {
    return SubcategoryData(
      subCategories: (json['subCategorys'] as List?)
              ?.map((item) => Subcategory.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategorys': subCategories.map((item) => item.toJson()).toList(),
    };
  }
}

// Data model for individual subcategory
class Subcategory {
  final int id;
  final List<InfoCard> infoCards;
  final String name;
  final String image;
  final bool isPublished;
  final int order;
  final SubCategoryInfo? subCategoryInfo;
  final String slug;
  final int category;
  final MetaInfo? metaInfo;

  Subcategory({
    required this.id,
    required this.infoCards,
    required this.name,
    required this.image,
    required this.isPublished,
    required this.order,
    this.subCategoryInfo,
    required this.slug,
    required this.category,
    this.metaInfo,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? 0,
      infoCards: (json['info_cards'] as List?)
              ?.map((item) => InfoCard.fromJson(item))
              .toList() ??
          [],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isPublished: json['is_published'] ?? false,
      order: json['order'] ?? 0,
      subCategoryInfo: json['sub_category_info'] != null
          ? SubCategoryInfo.fromJson(json['sub_category_info'])
          : null,
      slug: json['slug'] ?? '',
      category: json['category'] ?? 0,
      metaInfo: json['meta_info'] != null
          ? MetaInfo.fromJson(json['meta_info'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'info_cards': infoCards.map((item) => item.toJson()).toList(),
      'name': name,
      'image': image,
      'is_published': isPublished,
      'order': order,
      'sub_category_info': subCategoryInfo?.toJson(),
      'slug': slug,
      'category': category,
      'meta_info': metaInfo?.toJson(),
    };
  }
}

class InfoCard {
  final int id;
  final String? icon;
  final String title;
  final String description;
  final int order;

  InfoCard({
    required this.id,
    this.icon,
    required this.title,
    required this.description,
    required this.order,
  });

  factory InfoCard.fromJson(Map<String, dynamic> json) {
    return InfoCard(
      id: json['id'] ?? 0,
      icon: json['icon'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
      'order': order,
    };
  }
}

class SubCategoryInfo {
  final String headingBefore;
  final String italicText;
  final String headingAfter;
  final String description;
  final List<String> tags;
  final List<Stat> stats;
  final List<CareGuide> careGuides;

  SubCategoryInfo({
    required this.headingBefore,
    required this.italicText,
    required this.headingAfter,
    required this.description,
    required this.tags,
    required this.stats,
    required this.careGuides,
  });

  factory SubCategoryInfo.fromJson(Map<String, dynamic> json) {
    return SubCategoryInfo(
      headingBefore: json['heading_before'] ?? '',
      italicText: json['italic_text'] ?? '',
      headingAfter: json['heading_after'] ?? '',
      description: json['description'] ?? '',
      tags: (json['tags'] as List?)?.map((item) {
        if (item is Map) return item['label']?.toString() ?? '';
        return item.toString();
      }).where((s) => s.isNotEmpty).toList() ?? [],
      stats: (json['stats'] as List?)
              ?.map((item) => Stat.fromJson(item))
              .toList() ??
          [],
      careGuides: (json['care_guides'] as List?)
              ?.map((item) => CareGuide.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heading_before': headingBefore,
      'italic_text': italicText,
      'heading_after': headingAfter,
      'description': description,
      'tags': tags,
      'stats': stats.map((item) => item.toJson()).toList(),
      'care_guides': careGuides.map((item) => item.toJson()).toList(),
    };
  }
}

class Stat {
  final int id;
  final String number;
  final String label;

  Stat({
    required this.id,
    required this.number,
    required this.label,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      id: json['id'] ?? 0,
      number: json['number']?.toString() ?? json['value']?.toString() ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'label': label,
    };
  }
}

class CareGuide {
  final int id;
  final String? icon;
  final String title;
  final String description;

  CareGuide({
    required this.id,
    this.icon,
    required this.title,
    required this.description,
  });

  factory CareGuide.fromJson(Map<String, dynamic> json) {
    return CareGuide(
      id: json['id'] ?? 0,
      icon: json['icon'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
    };
  }
}

class MetaInfo {
  final int id;
  final String metaTitle;
  final String metaDescription;
  final String canonicalUrl;
  final Map<String, dynamic>? schemaMarkup;

  MetaInfo({
    required this.id,
    required this.metaTitle,
    required this.metaDescription,
    required this.canonicalUrl,
    this.schemaMarkup,
  });

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
      id: json['id'] ?? 0,
      metaTitle: json['meta_title'] ?? '',
      metaDescription: json['meta_description'] ?? '',
      canonicalUrl: json['canonical_url'] ?? '',
      schemaMarkup: json['schema_markup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'canonical_url': canonicalUrl,
      'schema_markup': schemaMarkup,
    };
  }
}
