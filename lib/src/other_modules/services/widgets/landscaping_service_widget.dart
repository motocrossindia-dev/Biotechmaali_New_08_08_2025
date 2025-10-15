import 'package:biotech_maali/src/module/services/screens/drip_irrigation_screen.dart';
import 'package:biotech_maali/src/module/services/screens/garden_maintenance_screen.dart';
import 'package:biotech_maali/src/module/services/screens/landscaping_service_screen.dart';
import 'package:biotech_maali/src/module/services/screens/terrace_garden_screen.dart';
import 'package:biotech_maali/src/module/services/screens/vertical_garden_screen.dart';

import '../../../../import.dart';

class LandscapingServiceCard extends StatelessWidget {
  const LandscapingServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildServiceCard(
            context: context,
            title: 'Landscaping',
            imageUrl:
                'https://static.wixstatic.com/media/0e86fc_3c46288efa2441fab93089a47d7e6277~mv2.jpeg/v1/fill/w_640,h_688,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/0e86fc_3c46288efa2441fab93089a47d7e6277~mv2.jpeg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandscapingServiceScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context: context,
            title: 'Terrace & Kitchen Garden',
            imageUrl:
                'https://i.pinimg.com/474x/62/7d/b4/627db446caf61439694c80173835b8c0.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TerraceGardenScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context: context,
            title: 'Vertical Wall & Garden',
            imageUrl:
                'https://media.architecturaldigest.com/photos/66bfa51bbb9599ad676d0e19/master/w_1600%2Cc_limit/GettyImages-455075581.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerticalGardenScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context: context,
            title: 'Drip Irrigation',
            imageUrl:
                'https://img-cdn.krishijagran.com/98815/drip-irrigation-1.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DripIrrigationScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context: context,
            title: 'Garden Maintenance',
            imageUrl:
                'https://images.unsplash.com/photo-1416879595882-3373a0480b5b',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GardenMaintenanceScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Image
                NetworkImageWidget(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Title
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
