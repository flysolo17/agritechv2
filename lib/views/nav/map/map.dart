import 'dart:convert';

import 'package:agritechv2/models/pest/pest_map.dart';
import 'package:agritechv2/repository/content_repository.dart';
import 'package:agritechv2/repository/pest_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/cms/TopicSubject.dart';

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
        StreamBuilder<List<TopicSubject>>(
          stream: ContentRepository().getAllTopicSubject(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              final topicSubjects = snapshot.data!;
              return ListView.builder(
                itemCount: topicSubjects.length,
                itemBuilder: (context, index) {
                  final topicSubject = topicSubjects[index];
                  return PestMapCard(
                    topicSubject: topicSubject,
                  );
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
  final TopicSubject topicSubject;
  const PestMapCard({super.key, required this.topicSubject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {context.push("/view-pest-map", extra: topicSubject.id.toString())},
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: NetworkImage(
              topicSubject.cover,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  topicSubject.name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
