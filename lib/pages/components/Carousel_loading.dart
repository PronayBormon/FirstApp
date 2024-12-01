import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CarouselLoading extends StatelessWidget {
  const CarouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey[300]!,
      child: Column(
        children: [
          // Container acting as the carousel item placeholder
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% width of screen
            height: 200, // Set a height for the placeholder
            decoration: BoxDecoration(
              color: const Color.fromARGB(94, 119, 119, 119),
              borderRadius: BorderRadius.circular(10), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3), // Shadow effect
                ),
              ],
            ),
            // Adding a Circular Progress Indicator or a Shimmer effect
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0, // Custom stroke width
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue), // Loading spinner color
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
