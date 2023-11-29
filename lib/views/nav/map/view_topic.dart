import 'package:agritechv2/models/pest/pest_map.dart';
import 'package:agritechv2/models/product/Products.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../styles/color_styles.dart';
import '../../../utils/Constants.dart';

class ViewTopic extends StatelessWidget {
  final Topic topic;
  const ViewTopic({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        centerTitle: true,
        backgroundColor: ColorStyle.brandRed,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              topic.image,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                topic.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(topic.desc),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topic.contents.length,
                itemBuilder: (context, index) {
                  final content = topic.contents[index];
                  return ContentContainer(contents: content);
                }),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Suggested Products",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topic.recomendations.length,
                itemBuilder: (context, index) {
                  final productID = topic.recomendations[index];
                  return SuggestedProducts(productID: productID);
                }),
          ],
        ),
      ),
    );
  }
}

class ContentContainer extends StatelessWidget {
  final Contents contents;
  const ContentContainer({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contents.image.isNotEmpty)
          Image.network(
            contents.image,
            width: double.infinity,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            contents.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(contents.description),
        )
      ],
    );
  }
}

class SuggestedProducts extends StatelessWidget {
  final String productID;
  const SuggestedProducts({super.key, required this.productID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Products>(
      future: context.read<ProductRepository>().getProductById(productID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmerLoading1(); // Loa
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final product = snapshot.data;

          return ListTile(
            onTap: () {
              context.push("/product/${product.id}");
            },
            hoverColor: Colors.grey[200],
            leading: Image.network(
              product!.images[0],
              width: 100,
              height: 100,
            ),
            dense: true,
            title: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            subtitle: Text(
              getEffectivePrice(product),
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.favorite),
          );
        } else {
          return const Center(
            child: Text('Product not found'),
          );
        }
      },
    );
  }
}
