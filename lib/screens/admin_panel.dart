import 'package:flutter/material.dart';
import '../services/guide_service.dart';
import '../models/guide.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _guideService = GuideService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
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

          final guides = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: guides.length,
            itemBuilder: (context, i) {
              final guide = guides[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.deepOrange),
                  title: Text(guide.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    guide.content.length > 50
                        ? '${guide.content.substring(0, 50)}...'
                        : guide.content,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón Editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(guide),
                      ),
                      // Botón Eliminar
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(guide),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Guía'),
      ),
    );
  }

  // Diálogo para CREAR
  void _showCreateDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final imagePathController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Nueva Guía'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Ruta de imagen (ej: assets/images/ejemplo.png)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                await _guideService.createGuide(
                  titleController.text,
                  contentController.text,
                  imagePathController.text.isEmpty 
                      ? 'assets/images/logo.png' 
                      : imagePathController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guía creada exitosamente')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  // Diálogo para EDITAR
  void _showEditDialog(Guide guide) {
    final titleController = TextEditingController(text: guide.title);
    final contentController = TextEditingController(text: guide.content);
    final imagePathController = TextEditingController(text: guide.imagePath);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Guía'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Ruta de imagen',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                await _guideService.updateGuide(
                  guide.id!,
                  titleController.text,
                  contentController.text,
                  imagePathController.text.isEmpty 
                      ? 'assets/images/logo.png' 
                      : imagePathController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guía actualizada')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Confirmación para ELIMINAR
  void _confirmDelete(Guide guide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Guía'),
        content: Text('¿Estás seguro de eliminar "${guide.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _guideService.deleteGuide(guide.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guía eliminada')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}