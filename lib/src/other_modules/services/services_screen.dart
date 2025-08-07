import 'package:biotech_maali/src/other_modules/services/services_provider.dart';
import 'package:biotech_maali/src/other_modules/services/widgets/contact_form_widget.dart';
import 'package:biotech_maali/src/other_modules/services/widgets/how_its_work_widget.dart';
import 'package:biotech_maali/src/other_modules/services/widgets/landscaping_service_widget.dart';
import '../../../import.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch services when screen loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ServicesProvider>().fetchServices();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          // if (provider.isLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // if (provider.error.isNotEmpty) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(provider.error),
          //         const SizedBox(height: 16),
          //         ElevatedButton(
          //           onPressed: () => provider.fetchServices(),
          //           child: const Text('Retry'),
          //         ),
          //       ],
          //     ),
          //   );
          // }

          return const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LandscapingServiceCard(),
                HowItWorksSection(),
                ContactFormSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
