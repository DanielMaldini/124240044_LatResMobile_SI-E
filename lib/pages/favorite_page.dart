import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/item_thumb.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Get.find<FavoriteController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      // Obx otomatis rebuild tiap kali RxList favorites berubah,
      // baik dari halaman ini maupun dari halaman detail.
      body: Obx(() {
        final list = fav.favorites;
        if (list.isEmpty) {
          return const Center(child: Text('Belum ada data favorite'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final item = list[i];
            return Card(
              child: ListTile(
                leading: ItemThumb(url: item.imageUrl),
                title: Text(item.title,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(item.author),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => fav.toggle(item),
                ),
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
        );
      }),
    );
  }
}