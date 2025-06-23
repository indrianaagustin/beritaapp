import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Umum', 'code': 'general'},
    {'name': 'Bisnis', 'code': 'business'},
    {'name': 'Hiburan', 'code': 'entertainment'},
    {'name': 'Kesehatan', 'code': 'health'},
    {'name': 'Sains', 'code': 'science'},
    {'name': 'Olahraga', 'code': 'sports'},
    {'name': 'Teknologi', 'code': 'technology'},
  ];

  KategoriPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final kategori = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(kategori['name']!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // nanti diisi
            },
          ),
        );
      },
    );
  }
}
