import 'dart:convert';

import 'package:agritechv2/repository/content_repository.dart';
import 'package:agritechv2/repository/pest_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/cms/Topic.dart';
import '../../../styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPestMapPage extends StatelessWidget {
  final String topic;
  const ViewPestMapPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<List<Topic>>(
        stream: context.read<ContentRepository>().getAllTopics(topic),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Topic> topics = snapshot.data ?? [];

            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(
                        text: 'All',
                        icon: Icon(Icons.search),
                      ),
                      Tab(
                        text: 'Insects',
                        icon: Icon(Icons.bug_report),
                      ),
                      Tab(
                        text: 'Diseases',
                        icon: Icon(Icons.dangerous),
                      ),
                      Tab(
                        text: 'Weeds',
                        icon: Icon(Icons.grass),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        TabContainer(maps: topics),
                        TabContainer(
                            maps: topics
                                .where((e) => e.category == "INSECTS")
                                .toList()),
                        TabContainer(
                            maps: topics
                                .where((e) => e.category == "DISEASES")
                                .toList()),
                        TabContainer(
                            maps: topics
                                .where((e) => e.category == "WEEDS")
                                .toList()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class TabContainer extends StatelessWidget {
  final List<Topic> maps;
  const TabContainer({super.key, required this.maps});
  String? extractSampleString(String text) {
    final RegExp regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  String removeWrappedCharacters(String text) {
    return text.replaceAll(
        RegExp(r'\([^()]*\)'), ''); // Replace characters wrapped in ()
  }

  String? extractWrappedCharacters(String text) {
    final RegExp regex = RegExp(r'\((.*?)\)'); // Match characters wrapped in ()
    final match = regex.firstMatch(text);
    return match?.group(1); // Return the matched characters
  }

  @override
  Widget build(BuildContext context) {
    return maps.isEmpty
        ? const Center(
            child: Text("No pest map yet!"),
          )
        : ListView.builder(
            itemCount: maps.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    {context.push("/view-pest-map-topic", extra: maps[index])},
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    leading: maps[index].image.isNotEmpty
                        ? Image.network(
                            maps[index].image,
                            height: double.infinity,
                            width: 100,
                            fit: BoxFit.contain,
                          )
                        : null,
                    title: Text(
                      removeWrappedCharacters(maps[index].title),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      maps[index].desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
