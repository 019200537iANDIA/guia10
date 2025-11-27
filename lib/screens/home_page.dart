import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/guide_service.dart';
import '../models/guide.dart';
import 'guide_detail_page.dart';
import 'profile_page.dart';
import 'admin_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  final _guideService = GuideService();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await _authService.isAdmin();
    setState(() => isAdmin = admin);
  }

  Future<void> _logout() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guías de Emergencia'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          // Botón de admin (solo si es admin)
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Panel Admin',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPanel()),
                );
              },
            ),
          
          // Botón de perfil
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          
          // Botón de logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<List<Guide>>(
        stream: _guideService.getGuides(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay guías disponibles'),
            );
          }

          final guides = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: guides.length,
            itemBuilder: (context, i) {
              final guide = guides[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      guide.imagePath.isNotEmpty 
                          ? guide.imagePath 
                          : 'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.medical_services,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  title: Text(
                    guide.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    guide.content.length > 80
                        ? '${guide.content.substring(0, 80)}...'
                        : guide.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GuideDetailPage(guide: guide),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}