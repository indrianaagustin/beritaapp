import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailPage extends StatefulWidget {
  final Map newsData;

  const NewsDetailPage({super.key, required this.newsData});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorited();
  }

  Future<void> checkIfFavorited() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    final current = jsonEncode(widget.newsData);

    setState(() {
      isFavorited = favorites.contains(current);
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    final current = jsonEncode(widget.newsData);

    if (favorites.contains(current)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita sudah ada di favorit')),
      );
    } else {
      favorites.add(current);
      await prefs.setStringList('favorites', favorites);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita ditambahkan ke favorit')),
      );

      setState(() {
        isFavorited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.newsData['urlToImage'];
    final title = widget.newsData['title'] ?? 'Judul tidak tersedia';
    final description = widget.newsData['description'] ?? 'Deskripsi tidak tersedia';
    final content = widget.newsData['content'] ?? 'Konten tidak tersedia.';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            Text(content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Arahkan ke browser jika perlu
                },
                child: const Text('Baca Selengkapnya'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
