import 'dart:convert';

import 'package:agritechv2/models/pest/pest_map.dart';
import 'package:agritechv2/repository/pest_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> maps = [
      {'topic': Topic.CORN.name, 'image': 'lib/assets/images/corn.png'},
      {'topic': Topic.RICE.name, 'image': 'lib/assets/images/rice.png'},
      {'topic': Topic.VEGETABLE.name, 'image': 'lib/assets/images/vege.png'},
    ];

    return Stack(
      children: [
        ListView.builder(
          itemCount: maps.length,
          itemBuilder: (context, index) {
            final pestMap = maps[index];

            return PestMapCard(
              image: pestMap['image'] ?? '',
              topic: pestMap['topic'] ?? '',
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

class PestMapCard extends StatelessWidget {
  final String image;
  final String topic;
  const PestMapCard({super.key, required this.image, required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {context.push("/view-pest-map", extra: topic.toString())},
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
