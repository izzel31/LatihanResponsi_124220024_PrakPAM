import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  final String type;

  DetailScreen({required this.id, required this.type});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Detail'),
        backgroundColor: Colors.grey,  // AppBar berwarna abu-abu
      ),
      body: FutureBuilder(
        future: ApiService.fetchDetail(type, id),  // Mengambil detail dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data as Map;
            final imageUrl = data['image_url'] ?? ''; // Mendapatkan 'image_url'

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                    height: 200,
                    color: Colors.grey,
                    child: Icon(Icons.image, size: 100, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      data['title'] ?? 'No Title',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      data['summary'] ?? 'No Description',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _launchURL(data['url']),
                      child: Text('Read More'),
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
