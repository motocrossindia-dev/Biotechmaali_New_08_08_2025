import 'package:flutter/material.dart';
import '../../../../core/config/pallet.dart';
import '../widgets/service_detail_header.dart';
import '../../../widgets/network_image_widget.dart';

class TerraceGardenScreen extends StatelessWidget {
  const TerraceGardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const ServiceDetailHeader(
                imageUrl:
                    'https://static.vecteezy.com/system/resources/previews/023/378/230/large_2x/modern-garden-terrace-kitchen-interior-ai-generated-photo.jpg',
                title: 'Terrace & Kitchen Garden',
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
                    'Grow Your Own Urban Garden',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Dark green color
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    context,
                    'Custom terrace garden design',
                    'https://www.anzlandscaping.in/wp-content/uploads/2023/07/Screenshot-2023-02-17-115051.png',
                    'Create a beautiful and functional terrace garden with our custom design services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Kitchen garden setup with vegetable plots',
                    'https://media.architecturaldigest.com/photos/626aab7c3eb88382e12961b4/3:2/w_4737,h_3158,c_limit/16%20Backyard%20Vegetable%20Garden%20Ideas.jpg',
                    'Set up a productive kitchen garden with our expert guidance and vegetable plots.',
                  ),
                  _buildDetailItem(
                    context,
                    'Container gardening solutions',
                    'https://www.allthatgrows.in/cdn/shop/articles/81478036_m_1_1100x1100.jpg?v=1603343363',
                    'Optimize your space with our innovative container gardening solutions.',
                  ),
                  _buildDetailItem(
                    context,
                    'Herb garden installations',
                    'https://media.istockphoto.com/id/164666590/photo/roof-terrace.jpg?s=612x612&w=0&k=20&c=WKF9eZ_Tj2G5lFqxpuYsEZ4b5d7jS7OUVQ3zyXFeCtw=',
                    'Install a thriving herb garden with our professional services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Efficient irrigation systems',
                    'https://m.media-amazon.com/images/I/910YBxiVcIL.jpg',
                    'Ensure your garden is well-watered with our efficient irrigation systems.',
                  ),
                  _buildDetailItem(
                    context,
                    'Organic growing techniques',
                    'https://geneticliteracyproject.org/wp-content/uploads/elementor/thumbs/predlog-za-velinu-slikuu-pe4xzp6h8fjg0qi42uaagc7r6hh3xtwd9s1t1ns0am.jpg',
                    'Grow healthy, organic produce with our sustainable growing techniques.',
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
            child: NetworkImageWidget(
              imageUrl: imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error_outline, size: 50),
                );
              },
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
                const SizedBox(height: 12),
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
