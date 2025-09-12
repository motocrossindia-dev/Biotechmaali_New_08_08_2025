class CarrierModel {
  final int id;
  final String categories;
  final String positionName;
  final String jobSummary;
  final String responsibilities;
  final String desiredSkills;
  final String? googleForm;

  CarrierModel({
    required this.id,
    required this.categories,
    required this.positionName,
    required this.jobSummary,
    required this.responsibilities,
    required this.desiredSkills,
    this.googleForm,
  });

  // sample

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      id: json['id'] ?? 0,
      categories: json['categories'] ?? '',
      positionName: json['position_name'] ?? '',
      jobSummary: json['job_summary'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      desiredSkills: json['desired_skills'] ?? '',
      googleForm: json['google_form']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories': categories,
      'position_name': positionName,
      'job_summary': jobSummary,
      'responsibilities': responsibilities,
      'desired_skills': desiredSkills,
      'google_form': googleForm,
    };
  }
}
