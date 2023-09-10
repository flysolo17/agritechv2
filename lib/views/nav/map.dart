import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'lib/assets/images/rice.png',
      'lib/assets/images/corn.png',
      'lib/assets/images/vege.png',
      // Add more image URLs as needed
    ];
    return Stack(
      children: [
        ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imageUrls[index],
                  fit: BoxFit.cover, // Adjust image size to cover the card
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16.0, // Adjust the position as needed
          right: 16.0, // Adjust the position as needed
          child: FloatingActionButton(
            onPressed: () {
              context.go('/calculator');
            },
            child: const Icon(Icons.calculate_outlined),
          ),
        ),
      ],
    );
  }
}
