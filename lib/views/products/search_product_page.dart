import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';

class SearchProductPage extends StatelessWidget {
  const SearchProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(8.0),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              child: Text(
                'Search product here!',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('This Feature is not implemented yet!'),
            ),
          )
        ],
      ),
    );
  }
}
