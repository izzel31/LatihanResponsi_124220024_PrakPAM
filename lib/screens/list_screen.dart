import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class ListScreen extends StatelessWidget {
  final String type; // 'articles', 'blogs', or 'reports'
  final String title;

  ListScreen({required this.type, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.grey, // AppBar berwarna abu-abu
      ),
      body: FutureBuilder(
        future: ApiService.fetchList(type),  // Mengambil daftar dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data as List;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                // Mendapatkan URL gambar dari API
                final imageUrl = data[index]['image_url'] ?? ''; // Mendapatkan 'image_url'

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    // Menampilkan gambar jika URL tersedia
                    leading: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: Icon(Icons.image, size: 40, color: Colors.white),
                    ),
                    title: Text(data[index]['title'] ?? 'No Title'),
                    subtitle: Text(data[index]['summary'] ?? 'No Description'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            id: data[index]['id'],
                            type: type,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
