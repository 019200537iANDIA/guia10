import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registrar con email y contraseña
  Future<User?> signUpWithEmail(String email, String password, String name, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      
      // Guardar datos adicionales en Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      return user;
    } catch (e) {
      print('Error en registro: $e');
      return null;
    }
  }

  // Login con email y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  // Login con Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Guardar usuario en Firestore si es nuevo
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'Usuario',
            'email': user.email,
            'phone': '',
            'isAdmin': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      print('Error en Google Sign In: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Verificar si es admin
  Future<bool> isAdmin() async {
    if (currentUser == null) return false;
    final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
    return doc.data()?['isAdmin'] ?? false;
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData() async {
    if (currentUser == null) return null;
    final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
    return doc.data();
  }
}
