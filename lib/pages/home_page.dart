import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'list_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, ${auth.username.value ?? ''}!'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _menuCard(context, Icons.newspaper, 'News', 'articles',
              'Get an overview of the latest SpaceFlight news, from various sources!'),
          _menuCard(context, Icons.article, 'Blog', 'blogs',
              'Blogs often provide a more detailed overview of launches and missions.'),
          _menuCard(context, Icons.bar_chart, 'Reports', 'reports',
              'Space stations and other missions often publish their data.'),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await auth.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(BuildContext context, IconData icon, String title,
      String type, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 36, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListPage(type: type, title: title),
          ),
        ),
      ),
    );
  }
}