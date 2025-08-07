import 'package:flutter/material.dart';
import '../../../../core/config/pallet.dart';
import '../widgets/service_detail_header.dart';

class GardenMaintenanceScreen extends StatelessWidget {
  const GardenMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const ServiceDetailHeader(
                imageUrl:
                    'https://5.imimg.com/data5/SELLER/Default/2023/10/353128437/TP/IL/EB/15526456/garden-maintenance-service.png',
                title: 'Garden Maintenance',
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Professional Garden Care',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Dark green color
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    context,
                    'Regular lawn mowing and edging',
                    'https://dirt2neat.com.au/wp-content/uploads/2021/04/L01-min.jpg',
                    'Keep your lawn neat and tidy with our regular mowing and edging services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Plant pruning and trimming',
                    'https://grainger-prod.adobecqms.net/content/dam/grainger/gus/en/public/digital-tactics/know-how/hero/SS-KH_MustHaveOutdoorPruningTools_KH-HRO.jpg',
                    'Ensure healthy growth and a beautiful appearance with our expert pruning and trimming.',
                  ),
                  _buildDetailItem(
                    context,
                    'Weed control and prevention',
                    'https://performancelawncare.com/wp-content/uploads/Weed-Control-Frequency-of-Services.webp',
                    'Keep your garden free from weeds with our effective control and prevention methods.',
                  ),
                  _buildDetailItem(
                    context,
                    'Fertilization programs',
                    'https://cdn.prod.website-files.com/66acdd367ca9070aee30e76e/66b104cdc7ae6a3b5903cb9e_3.png',
                    'Promote healthy plant growth with our customized fertilization programs.',
                  ),
                  _buildDetailItem(
                    context,
                    'Pest management',
                    'https://www.ugaoo.com/cdn/shop/articles/shutterstock_682576462.jpg?v=1661875027',
                    'Protect your garden from pests with our comprehensive pest management services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Seasonal clean-ups',
                    'https://caseyslawncare.com/wp-content/uploads/2023/02/Cleanup.jpg',
                    'Keep your garden looking its best year-round with our seasonal clean-up services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Plant health monitoring',
                    'https://planthealthmonitoring.com/photo/planthealthmonitoringcom/plant-health-monitoring.jpg',
                    'Ensure the health of your plants with our regular monitoring and care.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: cButtonGreen,
        child: const Icon(Icons.phone_outlined),
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String title, String imageUrl, String description) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image at the top
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Content padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // Dark green color
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
