import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    setState(() {
      userData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('No hay usuario activo'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Nombre
                      Text(
                        userData?['name'] ?? user.displayName ?? 'Usuario',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 30),

                      // Tarjetas de información
                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'Correo electrónico',
                        value: user.email ?? 'No disponible',
                      ),
                      const SizedBox(height: 15),

                      _buildInfoCard(
                        icon: Icons.phone,
                        title: 'Teléfono',
                        value: userData?['phone'] ?? 'No registrado',
                      ),
                      const SizedBox(height: 15),

                      _buildInfoCard(
                        icon: Icons.admin_panel_settings,
                        title: 'Tipo de usuario',
                        value: userData?['isAdmin'] == true ? 'Administrador' : 'Usuario',
                      ),
                      const SizedBox(height: 30),

                      // Botón de cerrar sesión
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _authService.signOut();
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Cerrar Sesión'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}