import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/favorite_controller.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final String type; // articles / blogs / reports
  final int id;
  const DetailPage({super.key, required this.type, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Item> _future;
  final fav = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    _future = ApiService.getDetail(widget.type, widget.id);
  }

  Future<void> _toggleFavorite(Item item) async {
    final wasFav = fav.isFavorite(item);
    await fav.toggle(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
            wasFav ? 'Dihapus dari favorite' : 'Ditambahkan ke favorite'),
      ));
  }

  Future<void> _openWeb(Item item) async {
    final ok = await launchUrl(
      Uri.parse(item.url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak bisa membuka situs'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder membungkus Scaffold supaya AppBar & FAB
    // bisa memakai data item setelah selesai dimuat.
    return FutureBuilder<Item>(
      future: _future,
      builder: (context, snap) {
        final item = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail'),
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            actions: [
              if (item != null)
                Obx(() => IconButton(
                      tooltip: 'Favorite',
                      icon: Icon(
                        fav.isFavorite(item)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: fav.isFavorite(item) ? Colors.red : Colors.white,
                      ),
                      onPressed: () => _toggleFavorite(item),
                    )),
            ],
          ),
          floatingActionButton: item == null
              ? null
              : FloatingActionButton(
                  tooltip: 'Buka Web',
                  onPressed: () => _openWeb(item),
                  child: const Icon(Icons.open_in_new),
                ),
          body: _buildBody(snap, item),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<Item> snap, Item? item) {
    if (snap.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snap.hasError || item == null) {
      return Center(child: Text('Gagal memuat detail: ${snap.error}'));
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image(item.imageUrl),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(item.author,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(item.publishedAt,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                Text(item.summary, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(String url) {
    final fallback = Container(
      width: double.infinity,
      height: 220,
      color: Colors.grey.shade300,
      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
    );
    if (url.isEmpty) return fallback;
    return Image.network(
      url,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => fallback,
    );
  }
}