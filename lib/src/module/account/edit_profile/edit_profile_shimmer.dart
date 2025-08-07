import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: const Border(
                  bottom: BorderSide(style: BorderStyle.none),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _buildShimmerTextField(), // First Name
                      const SizedBox(height: 20),
                      _buildShimmerTextField(), // Last Name
                      const SizedBox(height: 20),
                      // Gender Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildShimmerRadio(),
                              const SizedBox(width: 20),
                              _buildShimmerRadio(),
                              const SizedBox(width: 20),
                              _buildShimmerRadio(),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildShimmerTextField(), // Email
                      const SizedBox(height: 20),
                      _buildShimmerTextField(), // Mobile
                      const SizedBox(height: 20),
                      _buildShimmerTextField(), // Date of Birth
                    ],
                  ),
                ),
              ),
            ),
            // Delete Account Button Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 12,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8),
        ),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerRadio() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 14,
          color: Colors.white,
        ),
      ],
    );
  }
}