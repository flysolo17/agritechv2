import 'dart:io';

import 'package:agritechv2/models/cms/contents.dart';
import 'package:agritechv2/models/product/Products.dart';
import 'package:agritechv2/repository/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/cms/Topic.dart';
import '../../../repository/content_repository.dart';
import '../../../styles/color_styles.dart';
import '../../../utils/Constants.dart';

class ViewTopic extends StatelessWidget {
  final Topic topic;

  const ViewTopic({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
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
            StreamBuilder<List<Contents>>(
              stream:
                  context.read<ContentRepository>().getAllContents(topic.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Contents> contents = snapshot.data ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contents.length,
                    itemBuilder: (context, index) {
                      final content = contents[index];
                      final lastIndex = contents.length - 1;
                      if (lastIndex == index &&
                          contents[lastIndex].image.isNotEmpty) {
                        return ProgramCard(contents: content);
                      }
                      return ContentContainer(contents: content);
                    },
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Suggested Products",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<List<Products>>(
              stream: context
                  .read<ContentRepository>()
                  .getProductRecommendation(topic.recomendations),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Products> products = snapshot.data ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SuggestedProducts(product: product);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProgramCard extends StatefulWidget {
  final Contents contents;
  const ProgramCard({super.key, required this.contents});

  @override
  State<ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  final storageRef = FirebaseStorage.instance;
  String imageURL = '';
  final _flutterMediaDownloaderPlugin = MediaDownload();
  bool isDownloading = false; // Add this line

  Future<void> downloadFile(Reference ref) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final url = await ref.getDownloadURL();
      // Construct the destination file path in the Downloads directory
      String path = '${tempDir.path}/${ref.name}.png'; // add ref.

      // Download the file to the destination file path
      await Dio().download(url, path);
      final result = await ImageGallerySaver.saveFile(path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File downloaded successfully to: $path'),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "S&P Crop Program",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            TextButton(
              onPressed: () async {
                final ref = storageRef.refFromURL(widget.contents.image);
                downloadFile(ref);
              },
              child: Text(
                "Download",
                style: TextStyle(
                  color: isDownloading
                      ? Colors.grey
                      : Colors.green, // Update this line
                ),
              ),
            )
          ],
        ),
        Image.network(widget.contents.image)
      ],
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    print("Clickedddddd");
    try {
      _flutterMediaDownloaderPlugin.downloadMedia(context, imageUrl);
    } catch (e) {
      print('Error downloading image: $e');
    }
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
  final Products product;
  const SuggestedProducts({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push("/product/${product.id}");
      },
      hoverColor: Colors.grey[200],
      leading: Image.network(
        product.images[0],
        width: 100,
        height: 100,
      ),
      dense: true,
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      ),
      subtitle: Text(
        getEffectivePrice(product),
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.favorite),
    );
  }
}
