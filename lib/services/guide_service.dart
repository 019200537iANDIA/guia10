import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guide.dart';

class GuideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'guides';

  // Obtener todas las guías (Stream en tiempo real)
  Stream<List<Guide>> getGuides() {
    return _firestore.collection(collection).orderBy('title').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return Guide(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          imagePath: data['imagePath'] ?? '',
        );
      }).toList(),
    );
  }

  // Crear guía
  Future<void> createGuide(String title, String content, String imagePath) async {
    await _firestore.collection(collection).add({
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Actualizar guía
  Future<void> updateGuide(String id, String title, String content, String imagePath) async {
    await _firestore.collection(collection).doc(id).update({
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Eliminar guía
  Future<void> deleteGuide(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  // Inicializar guías por defecto (llamar una sola vez)
  Future<void> initializeDefaultGuides() async {
    final snapshot = await _firestore.collection(collection).get();
    if (snapshot.docs.isEmpty) {
      final defaultGuides = [
        {
          'title': 'Quemaduras',
          'content': '1. Enfría el área con agua limpia durante 10 minutos.\n2. No revientes ampollas.\n3. Cubre con un paño limpio.\n4. Llama al 105 si es grave.',
          'imagePath': 'assets/images/quemadura.png'
        },
        {
          'title': 'Fracturas (Huesos rotos)',
          'content': '1. Inmoviliza el área afectada.\n2. No intentes alinear el hueso.\n3. Aplica hielo envuelto.\n4. Llama al 105.',
          'imagePath': 'assets/images/fractura.png'
        },
        {
          'title': 'Atragantamiento',
          'content': '1. Anima a toser.\n2. Si no respira, aplica maniobra de Heimlich.\n3. Llama al 105 si no mejora.',
          'imagePath': 'assets/images/atragantamiento.png'
        },
        {
          'title': 'RCP (Reanimación)',
          'content': '1. Comprueba respiración.\n2. Aplica 30 compresiones y 2 ventilaciones.\n3. Mantén el ritmo hasta que llegue ayuda.',
          'imagePath': 'assets/images/rcp.png'
        },
        {
          'title': 'Cortes y Hemorragias',
          'content': '1. Aplica presión directa con una gasa limpia.\n2. No retires objetos clavados.\n3. Llama al 105 si sangra mucho.',
          'imagePath': 'assets/images/cortes.png'
        },
        {
          'title': 'Desmayos',
          'content': '1. Acuesta a la persona y eleva sus piernas.\n2. Afloja su ropa.\n3. Si no despierta en 1 minuto, llama al 105.',
          'imagePath': 'assets/images/desmayo.png'
        },
        {
          'title': 'Picaduras y Mordeduras',
          'content': '1. Lava la zona.\n2. Aplica hielo.\n3. Si hay reacción grave, llama al 105.',
          'imagePath': 'assets/images/picadura.png'
        },
        {
          'title': 'Hipotermia',
          'content': '1. Lleva a la persona a un lugar cálido.\n2. Cubre con mantas.\n3. No apliques calor directo.\n4. Llama al 105.',
          'imagePath': 'assets/images/hipotermia.png'
        },
        {
          'title': 'Intoxicaciones',
          'content': '1. No provoques el vómito.\n2. Identifica la sustancia.\n3. Llama al 105 o acude a emergencias.',
          'imagePath': 'assets/images/intoxicacion.png'
        },
      ];

      for (var guide in defaultGuides) {
        await createGuide(
          guide['title'] as String,
          guide['content'] as String,
          guide['imagePath'] as String,
        );
      }
    }
  }
}
