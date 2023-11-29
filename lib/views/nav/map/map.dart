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
    final List<String> imageUrls = [
      'lib/assets/images/rice.png',
      'lib/assets/images/corn.png',
      'lib/assets/images/vege.png',
      // Add more image URLs as needed
    ];
    return Stack(
      children: [
        StreamBuilder<List<PestMap>>(
          stream: context.read<PestRepository>().getAllPestMap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('No Pest map yet'));
            } else {
              final pestmapList = snapshot.data ?? [];
              return ListView.builder(
                itemCount: pestmapList.length,
                itemBuilder: (context, index) {
                  final pestMap = pestmapList[index];

                  return PestMapCard(pestMap: pestMap);
                },
              );
            }
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
  final PestMap pestMap;
  const PestMapCard({super.key, required this.pestMap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {context.push("/view-pest-map", extra: jsonEncode(pestMap.toJson()))},
      child: Container(
          height: 150,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: NetworkImage(
                  pestMap.image,
                ),
                fit: BoxFit.cover,
              )),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              pestMap.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
          )),
    );
  }
}
