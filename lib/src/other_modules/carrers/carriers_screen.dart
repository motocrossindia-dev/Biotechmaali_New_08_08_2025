import 'package:biotech_maali/src/other_modules/carrers/carriers_provider.dart';
import '../../../import.dart';

class CarrersScreen extends StatefulWidget {
  const CarrersScreen({super.key});

  @override
  State<CarrersScreen> createState() => _CarrersScreenState();
}

class _CarrersScreenState extends State<CarrersScreen> {
  static const Color themeColor = Color(0xFF749F09);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<CarrersProvider>().loadCarriers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Careers'),
        backgroundColor: Colors.white,
        foregroundColor: themeColor,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shape the Future with Biotech Maali',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore exciting career opportunities and join our team!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      tabs: [
                        Tab(text: 'Non-Tech Positions'),
                        Tab(text: 'Technology Positions'),
                      ],
                      labelColor: themeColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: themeColor,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        _JobListingsTab(isNonTech: true),
                        _JobListingsTab(isNonTech: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobListingsTab extends StatelessWidget {
  final bool isNonTech;
  static const Color themeColor = Color(0xFF749F09);

  const _JobListingsTab({required this.isNonTech});

  Future<void> _handleApplyJob(BuildContext context, JobListing job) async {
    try {
      final provider = context.read<CarrersProvider>();

      // Check if Google Form URL is available
      if (job.googleForm == null ||
          job.googleForm!.isEmpty ||
          job.googleForm == 'null') {
        if (context.mounted) {
          _showErrorDialog(
              context,
              'Google Form Not Available',
              'The application form for this position is currently not available. Please contact HR for assistance.',
              'Contact HR');
        }
        return;
      }

      // Show confirmation dialog before opening form
      if (context.mounted) {
        final shouldProceed = await _showApplicationConfirmDialog(context, job);
        if (!shouldProceed) return;
      }

      // Try to open Google Form
      final success = await provider.openGoogleForm(job.googleForm);

      if (context.mounted) {
        if (success) {
          _showApplicationOpenedDialog(context, job);
        } else {
          _showErrorDialog(
              context,
              'Failed to Open Form',
              'Unable to open the application form. Please check your internet connection and try again.',
              'Retry');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Error',
            'An unexpected error occurred: ${e.toString()}', 'OK');
      }
    }
  }

  Future<bool> _showApplicationConfirmDialog(
      BuildContext context, JobListing job) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              icon: const Icon(
                Icons.assignment,
                color: themeColor,
                size: 50,
              ),
              title: Text(
                'Apply for ${job.title}',
                style: const TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You will be redirected to the application form in your browser.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please complete the form and return to this app once submitted.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showApplicationOpenedDialog(BuildContext context, JobListing job) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: const Icon(
            Icons.open_in_browser,
            color: themeColor,
            size: 50,
          ),
          title: const Text(
            'Application Form Opened',
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The application form for "${job.title}" has been opened in your browser.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Complete the form in your browser',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.mobile_friendly,
                            color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Return to this app once submitted',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text(
                'Got it!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(
      BuildContext context, String title, String message, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: themeColor));
        }

        final jobs = isNonTech ? provider.nonTechJobs : provider.techJobs;

        if (jobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/images/empty_data.svg',
                  width: 100,
                  height: 100,
                  color: themeColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No openings currently',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Stay tuned for future opportunities!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: themeColor.withOpacity(0.15), width: 1),
              ),
              margin: const EdgeInsets.only(bottom: 18),
              color: Colors.white,
              child: ExpansionTile(
                leading: const Icon(Icons.work, color: themeColor, size: 28),
                title: Text(
                  job.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: themeColor,
                  ),
                ),
                subtitle: Text(
                  job.location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Experience Required: ${job.experience}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: themeColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Requirements:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...job.requirements.map(
                          (req) => Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(
                                        fontSize: 14, color: themeColor)),
                                Expanded(
                                  child: Text(req,
                                      style: const TextStyle(fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<CarrersProvider>(
                            builder: (context, provider, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: provider.isApplying
                                    ? null
                                    : () => _handleApplyJob(context, job),
                                child: provider.isApplying
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Apply Now'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
