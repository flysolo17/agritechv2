import 'dart:convert';

import 'package:agritechv2/models/pest/pest_map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../styles/color_styles.dart';

class ViewPestMapPage extends StatelessWidget {
  final PestMap pestMap;
  const ViewPestMapPage({super.key, required this.pestMap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pestMap.title),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.grey[200],
      body: DefaultTabController(
        length: 4, // Number of tabs
        child: Column(
          children: [
            // const TextField(
            //   controller: null,
            //   decoration: InputDecoration(
            //     hintText: 'Search...',
            //     prefixIcon: Icon(Icons.search),
            //     filled: true,
            //     border: null,
            //     fillColor: Colors.white,
            //   ),
            // ),
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
                  TabContainer(topics: pestMap.topic),
                  TabContainer(
                      topics: pestMap.topic
                          .where((e) => e.category == "INSECTS")
                          .toList()),
                  TabContainer(
                      topics: pestMap.topic
                          .where((e) => e.category == "DISEASES")
                          .toList()),
                  TabContainer(
                      topics: pestMap.topic
                          .where((e) => e.category == "WEEDS")
                          .toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabContainer extends StatelessWidget {
  final List<Topic> topics;
  const TabContainer({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => {
            context.push("/view-pest-map-topic",
                extra: jsonEncode(topics[index].toJson()))
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: topics[index].image.isNotEmpty
                  ? Image.network(
                      topics[index].image,
                      height: double.infinity,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(topics[index].title),
              subtitle: Text(
                topics[index].desc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        );
      },
    );
  }
}
