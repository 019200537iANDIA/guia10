import 'package:flutter/material.dart';
import '../models/guide.dart';

class GuideDetailPage extends StatelessWidget {
  final Guide guide;
  const GuideDetailPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                guide.imagePath.isNotEmpty
                    ? guide.imagePath
                    : 'assets/images/logo.png',
                height: 200,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.medical_services,
                  size: 100,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              guide.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 30),
            Text(
              guide.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
