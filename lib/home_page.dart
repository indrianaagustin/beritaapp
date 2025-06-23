import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'news_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List beritaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&apiKey=2beb26a3a6724dbd9df2bcbcd7b6ef01'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        beritaList = data['articles'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              final berita = beritaList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(
                        title: berita['title'] ?? 'Tanpa Judul',
                        imageUrl: berita['urlToImage'] ?? '',
                        content: berita['content'] ?? berita['description'] ?? 'Tidak ada isi.',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (berita['urlToImage'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            berita['urlToImage'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          berita['title'] ?? 'Tanpa Judul',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
