import 'dart:developer';

import '../../../import.dart';
import 'carriers_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class JobListing {
  final int id;
  final String title;
  final String description;
  final String location;
  final String experience;
  final List<String> requirements;
  final String? googleForm;

  JobListing({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.experience,
    required this.requirements,
    this.googleForm,
  });
}

class CarrersProvider with ChangeNotifier {
  final CarriersRepository _service = CarriersRepository();
  List<JobListing> _nonTechJobs = [];
  List<JobListing> _techJobs = [];
  bool _isLoading = false;
  bool _isApplying = false;

  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  List<JobListing> get nonTechJobs => _nonTechJobs;
  List<JobListing> get techJobs => _techJobs;

  Future<void> loadCarriers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final carriers = await _service.getCarriers();

      final techJobs = carriers
          .where((c) => c.categories == 'Tech Positions')
          .map((c) => JobListing(
                id: c.id,
                title: c.positionName,
                description: c.jobSummary,
                location: 'India', // Default location
                experience: 'Required',
                requirements: c.responsibilities
                    .split('\n')
                    .where((r) => r.trim().isNotEmpty)
                    .map((r) => r.trim())
                    .toList(),
                googleForm: c.googleForm,
              ))
          .toList();

      final nonTechJobs = carriers
          .where((c) => c.categories == 'Non-Tech Positions')
          .map((c) => JobListing(
                id: c.id,
                title: c.positionName,
                description: c.jobSummary,
                location: 'India', // Default location
                experience: 'Required',
                requirements: c.responsibilities
                    .split('\n')
                    .where((r) => r.trim().isNotEmpty)
                    .map((r) => r.trim())
                    .toList(),
                googleForm: c.googleForm,
              ))
          .toList();

      _techJobs = techJobs;
      _nonTechJobs = nonTechJobs;
    } catch (e) {
      // Handle error
      log('Error loading carriers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyForJob(int jobId) async {
    try {
      _isApplying = true;
      notifyListeners();

      final success = await _service.applyForJob(jobId);
      return success;
    } catch (e) {
      log('Error applying for job: $e');
      return false;
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }

  Future<bool> openGoogleForm(String? googleFormUrl) async {
    try {
      if (googleFormUrl == null ||
          googleFormUrl.isEmpty ||
          googleFormUrl == 'null') {
        return false;
      }

      // Validate URL format
      final Uri uri = Uri.parse(googleFormUrl);
      if (uri.host.isEmpty) {
        log('Invalid URL format: $googleFormUrl');
        return false;
      }

      // Launch the URL in external browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        log('Could not launch $googleFormUrl');
        return false;
      }
    } catch (e) {
      log('Error opening Google Form: $e');
      return false;
    }
  }
}
