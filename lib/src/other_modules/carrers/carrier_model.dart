class CarrierModel {
  final int id;
  final String categories;
  final String positionName;
  final String jobSummary;
  final String responsibilities;
  final String desiredSkills;

  CarrierModel({
    required this.id,
    required this.categories,
    required this.positionName,
    required this.jobSummary,
    required this.responsibilities,
    required this.desiredSkills,
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
    );
  }
}
