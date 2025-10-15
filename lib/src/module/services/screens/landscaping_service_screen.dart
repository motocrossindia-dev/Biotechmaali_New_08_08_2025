import 'package:flutter/material.dart';
import '../../../../core/config/pallet.dart';
import '../widgets/service_detail_header.dart';
import '../../../widgets/network_image_widget.dart';

class LandscapingServiceScreen extends StatelessWidget {
  const LandscapingServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const ServiceDetailHeader(
                imageUrl:
                    'https://5.imimg.com/data5/IOS/Default/2023/12/370141509/WB/XR/WZ/50041611/product-jpeg-500x500.png',
                title: 'Landscaping Services',
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
                    'Transform Your Outdoor Space',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Dark green color
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    context,
                    'Custom landscape design and planning',
                    'https://dtelandscaping.co/wp-content/uploads/2024/06/Revitalize-Your-Property-Premier-Landscaping-Services-in-Centennial-and-Lone-Tree-CO.jpg',
                    'We work closely with you to create beautiful, sustainable landscapes that enhance your property\'s value and create enjoyable outdoor living spaces.',
                  ),
                  _buildDetailItem(
                    context,
                    'Garden bed preparation and planting',
                    'https://media.istockphoto.com/id/1348318810/photo/newly-built-raised-vegetable-beds-empty-beds-with-prepared-soil-in-the-garden-in-spring.jpg?s=612x612&w=0&k=20&c=CFOtbtWvPWP_LbCJ9KscuzLwZjsy1KF99yTNrvAl1wo=',
                    'Prepare and plant garden beds with our expert services to ensure healthy growth and beautiful blooms.',
                  ),
                  _buildDetailItem(
                    context,
                    'Lawn installation and maintenance',
                    'https://balajinursery.org/wp-content/uploads/2024/09/natural-grass-turf-installer-1015x698.jpg',
                    'Install and maintain lush, green lawns with our professional services.',
                  ),
                  _buildDetailItem(
                    context,
                    'Hardscape installation (pathways, patios)',
                    'https://cdn.prod.website-files.com/63a02e61e7ffb565c30bcfc7/677f979a86e3d42338833841_659bbd88f009ff7a93a8cbf7_hardscape%2520ideas.webp',
                    'Enhance your outdoor space with pathways, patios, and other hardscape features.',
                  ),
                  _buildDetailItem(
                    context,
                    'Water features and fountain installation',
                    'https://www.gardendesign.com/pictures/images/900x705Max/site_3/black-garden-fountain-shutterstock-com_17945.jpg',
                    'Add tranquility to your garden with water features and fountains.',
                  ),
                  _buildDetailItem(
                    context,
                    'Outdoor lighting design',
                    'https://www.landscapedesigntoronto.ca/wp-content/uploads/2023/11/Landscape-lighting-design.jpg',
                    'Illuminate your outdoor space with our custom lighting designs.',
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
