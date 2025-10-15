import 'package:biotech_maali/src/other_modules/services/services_provider.dart';

import '../../../../import.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'How it works',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWorkStep(
                      imagePath:
                          'https://img.icons8.com/ios-filled/50/4a90e2/team-skin-type-7.png',
                      label: 'Professional\nTeam',
                    ),
                    _buildWorkStep(
                      imagePath:
                          'https://img.icons8.com/ios-filled/50/4a90e2/fire-element.png',
                      label: 'Best\nEquipment',
                    ),
                    _buildWorkStep(
                      imagePath:
                          'https://img.icons8.com/ios-filled/50/4a90e2/calendar--v1.png',
                      label: 'Time\nManagement',
                    ),
                    _buildWorkStep(
                      imagePath:
                          'https://img.icons8.com/ios-filled/50/4a90e2/maintenance.png',
                      label: 'Quality\nWork',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkStep({required String imagePath, required String label}) {
    return Column(
      children: [
        NetworkImageWidget(
          imageUrl: imagePath,
          width: 24,
          height: 24,
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            size: 24,
            color: Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
