import 'package:flutter/material.dart';
import '../../../../core/config/pallet.dart';
import '../widgets/service_detail_header.dart';
import '../../../widgets/network_image_widget.dart';

class VerticalGardenScreen extends StatelessWidget {
  const VerticalGardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const ServiceDetailHeader(
                imageUrl:
                    'https://www.nexsel.tech/wp-content/uploads/2024/10/Vertical-Green-Wall-with-Lights-770x415.webp',
                title: 'Vertical Wall & Garden',
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
                    'Living Walls & Vertical Gardens',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Dark green color
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    context,
                    'Custom vertical garden design',
                    'https://5.imimg.com/data5/SELLER/Default/2025/1/479044875/SV/UU/EA/140998683/custom-stainless-steel-vertical-garden-metal-hanging-decor-500x500.jpg',
                    'Create a stunning vertical garden with our custom design services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Living wall installations',
                    'https://media.licdn.com/dms/image/v2/D4D12AQHKCh4GLImYUQ/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1697012987765?e=2147483647&v=beta&t=qCJ839ZU0fLsuw1aHxt3GLOKIG_x3oFQCx72tLEd70E',
                    'Install beautiful living walls that enhance your space and improve air quality.',
                  ),
                  _buildDetailItem(
                    context,
                    'Plant selection for vertical growth',
                    'https://florissa.com/wp-content/uploads/2020/04/Vertical-Gardening.png',
                    'Choose the best plants for vertical growth with our expert guidance.',
                  ),
                  _buildDetailItem(
                    context,
                    'Automated irrigation systems',
                    'https://staygreengarden.com/wp-content/uploads/DALL%C2%B7E-2024-06-09-11.43.38-A-vibrant-vertical-garden-with-a-drip-irrigation-system.-The-garden-is-lush-and-full-of-various-plants-growing-in-rows.-The-irrigation-system-includes.webp',
                    'Ensure your vertical garden is well-watered with our automated irrigation systems.',
                  ),
                  _buildDetailItem(
                    context,
                    'Low-maintenance solutions',
                    'https://www.agrifarming.in/wp-content/uploads/2022/10/Low-Maintenance-Indoor-Vertical-Garden6-683x1024.jpg',
                    'Enjoy a beautiful garden with minimal upkeep using our low-maintenance solutions.',
                  ),
                  _buildDetailItem(
                    context,
                    'Regular maintenance services',
                    'https://5.imimg.com/data5/SELLER/Default/2021/1/QG/HA/CM/14028553/vertica-garden-maintenance-service-500x500.jpg',
                    'Keep your vertical garden thriving with our regular maintenance services.',
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
