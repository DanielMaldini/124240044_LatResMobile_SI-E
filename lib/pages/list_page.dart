import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import '../widgets/item_thumb.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class ListPage extends StatefulWidget {
  final String type; // articles / blogs / reports
  final String title;
  const ListPage({super.key, required this.type, required this.title});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Item>> _future;
  String? _selectedAuthor; // null = tampilkan semua

  @override
  void initState() {
    super.initState();
    _future = ApiService.getItems(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Favorite',
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritePage()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat data: ${snap.error}'));
          }
          final all = snap.data!;
          // Daftar author unik dari data -> jadi chip
          final authors = all
              .map((e) => e.author)
              .where((a) => a.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
          final items = _selectedAuthor == null
              ? all
              : all.where((e) => e.author == _selectedAuthor).toList();

          return Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: authors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final a = authors[i];
                    return FilterChip(
                      label: Text(a),
                      selected: _selectedAuthor == a,
                      onSelected: (sel) =>
                          setState(() => _selectedAuthor = sel ? a : null),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Card(
                      child: ListTile(
                        leading: ItemThumb(url: item.imageUrl),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(item.author),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(type: item.type, id: item.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}