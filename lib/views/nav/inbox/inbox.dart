import 'package:agritechv2/models/newsletter/Newsletter.dart';
import 'package:agritechv2/repository/newsletter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../styles/color_styles.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<NewsLetter>>(
        stream: context.read<NewsletterRepository>().getNewsletter(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching newsletters'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final newsletters = snapshot.data ?? [];
          return ListView.builder(
            itemCount: newsletters.length,
            itemBuilder: (context, index) {
              final newsletter = newsletters[index];
              return NewsCard(newsLetter: newsletter);
            },
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsLetter newsLetter;
  const NewsCard({Key? key, required this.newsLetter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Image.asset(
              "lib/assets/images/logo.png",
              height: 60,
            ),
            title: const Text("S&P Inc."),
            subtitle:
                Text(DateFormat('EEE d MMM yyyy').format(newsLetter.createdAt)),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              newsLetter.description,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10.0),
          if (newsLetter.image.isNotEmpty &&
              Uri.parse(newsLetter.image).isAbsolute)
            Image.network(newsLetter.image),
        ],
      ),
    );
  }
}
