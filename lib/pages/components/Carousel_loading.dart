import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:shimmer/shimmer.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

class CarouselLoading extends StatelessWidget {
  const CarouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
      child: SizedBox(
        height: 200,
        // width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // child: Image.asset(
    //   'assets/images/refer.png',
    //   fit: BoxFit.cover,
    // ),
    // decoration: BoxDecoration(
    //   color: const Color.fromARGB(94, 119, 119, 119),
    //   borderRadius: BorderRadius.circular(10), // Rounded corners
    // ),

    // Shimmer.fromColors(
    //   highlightColor: Colors.white,
    //   baseColor: Colors.grey[300]!,
    //   child: Column(
    //     children: [
    //       // Container acting as the carousel item placeholder
    //       Container(
    //         margin: const EdgeInsets.only(
    //           left: 20,
    //           right: 20,
    //           top: 20,
    //           bottom: 10,
    //         ),
    //         width: MediaQuery.of(context).size.width, // 80% width of screen
    //         height: 150, // Set a height for the placeholder
    //         decoration: BoxDecoration(
    //           color: const Color.fromARGB(94, 119, 119, 119),
    //           borderRadius: BorderRadius.circular(10), // Rounded corners
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.1),
    //               blurRadius: 6,
    //               offset: const Offset(0, 3), // Shadow effect
    //             ),
    //           ],
    //         ),
    //         // Adding a Circular Progress Indicator or a Shimmer effect
    //         child: Image.asset(
    //           'assets/images/refer.png',
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       // const SizedBox(height: 8),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: List.generate(6, (index) {
    //           return Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 3),
    //             child: Container(
    //               height: 8,
    //               width: 8,
    //               decoration: const BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.grey,
    //               ),
    //               child: Image.asset(
    //                 'assets/images/refer.png',
    //               ),
    //             ),
    //           );
    //         }),
    //       ),
    //     ],
    //   ),
    // );
  }
}
